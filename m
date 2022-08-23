Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84ED59DE39
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349353AbiHWLha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355734AbiHWLfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C3277561;
        Tue, 23 Aug 2022 02:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE7AB81C86;
        Tue, 23 Aug 2022 09:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F28C433D6;
        Tue, 23 Aug 2022 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246842;
        bh=ny41RisFgH2lXvSY1az4/VFPso6COSCs+418G2y4p4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwztcuajnhSe14CbMYBT4/bSPUyI/L+2BU4k8TIQIITufpd/vuQH+8IFpJu1tA7Um
         PKzzDkc14a8p5WwM64RAlNrQf+E8jtTwg6QQGCdqBtIb4Vq6S0APAfsE+J7vH2+zeK
         xnVv+TEHvhfv6eGWdGADsUMsykVKTNvXx4d/oQi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhongjin <chenzhongjin@huawei.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/389] kprobes: Forbid probing on trampoline and BPF code areas
Date:   Tue, 23 Aug 2022 10:25:16 +0200
Message-Id: <20220823080125.507143076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index c93340bae3ac..671b51782182 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1594,7 +1594,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
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



