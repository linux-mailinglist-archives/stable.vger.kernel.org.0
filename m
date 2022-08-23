Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5959E15E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiHWKsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355838AbiHWKoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D20AAB05E;
        Tue, 23 Aug 2022 02:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D798A60EFB;
        Tue, 23 Aug 2022 09:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8BFC433C1;
        Tue, 23 Aug 2022 09:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245834;
        bh=nSVXgxZC2TqTRvLOmt8W7a5C2RKHcTGAbGR3K/+fB68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWf0VoNmWrYizqM4tHiSwTkO2M1NECZe4Qs74mcHZb2kxdii3u0WiybSTLxJ8TItA
         E6bfT1wXiKWEQvG/t+YPAmcE6GkDEWub1U81yyHr6mdvvR0sfbgq8cMl7A/6MPtf1m
         tULtZssdk3s+yRuNJq0JcYVG2KaRwhjR+e19jcyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhongjin <chenzhongjin@huawei.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/287] kprobes: Forbid probing on trampoline and BPF code areas
Date:   Tue, 23 Aug 2022 10:25:43 +0200
Message-Id: <20220823080106.619249065@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 28f6c37a2910f565b4f5960df52b2eccae28c891 ]

kernel_text_address() treats ftrace_trampoline, kprobe_insn_slot
and bpf_text_address as valid kprobe addresses - which is not ideal.

These text areas are removable and changeable without any notification
to kprobes, and probing on them can trigger unexpected behavior:

  https://lkml.org/lkml/2022/7/26/1148

Considering that jump_label and static_call text are already
forbiden to probe, kernel_text_address() should be replaced with
core_kernel_text() and is_module_text_address() to check other text
areas which are unsafe to kprobe.

[ mingo: Rewrote the changelog. ]

Fixes: 5b485629ba0d ("kprobes, extable: Identify kprobes trampolines as kernel text area")
Fixes: 74451e66d516 ("bpf: make jited programs visible in traces")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20220801033719.228248-1-chenzhongjin@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 993b84cc1db5..099191716d4c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1566,7 +1566,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	preempt_disable();
 
 	/* Ensure it is not in reserved area nor out of text */
-	if (!kernel_text_address((unsigned long) p->addr) ||
+	if (!(core_kernel_text((unsigned long) p->addr) ||
+	    is_module_text_address((unsigned long) p->addr)) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
 	    find_bug((unsigned long)p->addr)) {
-- 
2.35.1



