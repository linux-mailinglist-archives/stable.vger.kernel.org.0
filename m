Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF1751006A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351610AbiDZO3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351608AbiDZO3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:29:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3716D377D3;
        Tue, 26 Apr 2022 07:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC6D2B82049;
        Tue, 26 Apr 2022 14:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798FBC385AA;
        Tue, 26 Apr 2022 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650983168;
        bh=ulX/RtnPAZiPCUCRgnficS0AKYmu2DfWNu6MqVxBOI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4zD8MsGt31kNHOh1QySZLBBw4Qw2micG4PeLBmE3+bfESEYbnuVv2b5eE7tVG2N8
         gySm0Y9XR9MDd7DtxdGp0fL+GJxM6aaXRRoooTYsgicEaoiAmhF41Och9/oqoS3+XN
         HH7OPs22zIdUjBsYnS22n4BIfxyyRcZQcenJtgcpE3qA7BzuaE6Q29WwG+dxRTLYid
         LvE1/u1ColvfHBLPA+4t4I8ug4+B4BHUyYi/EfZu25RdljvGKPMEaSZxlbUBv5Zx/X
         XUeYcgkiJKC7rZsvCBGSEDT/AY5spng35s+clXYwpS0kHwd1/tC8eLf51sdG08JVQl
         a7UUScnPZEYtg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mhiramat@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19.y 1/3] Revert "ia64: kprobes: Fix to pass correct trampoline address to the handler"
Date:   Tue, 26 Apr 2022 23:26:04 +0900
Message-Id: <165098316441.1366179.4768446584587876237.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <165098315444.1366179.5950180330185498273.stgit@devnote2>
References: <165098315444.1366179.5950180330185498273.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit f5f96e3643dc33d6117cf7047e73512046e4858b.

The commit f5f96e3643dc ("ia64: kprobes: Fix to pass correct trampoline
address to the handler") was wrongly backported. It involves another
commit which is a part of another bigger series, so it should not be
backported to the stable tree.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/ia64/kernel/kprobes.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 9cfd3ac027b7..8207b897b49d 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -411,8 +411,7 @@ static void kretprobe_trampoline(void)
 
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	regs->cr_iip = __kretprobe_trampoline_handler(regs,
-		dereference_function_descriptor(kretprobe_trampoline), NULL);
+	regs->cr_iip = __kretprobe_trampoline_handler(regs, kretprobe_trampoline, NULL);
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
@@ -428,7 +427,7 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
-	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);
+	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
 }
 
 /* Check the instruction in the slot is break */
@@ -958,14 +957,14 @@ static struct kprobe trampoline_p = {
 int __init arch_init_kprobes(void)
 {
 	trampoline_p.addr =
-		dereference_function_descriptor(kretprobe_trampoline);
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
 	return register_kprobe(&trampoline_p);
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	if (p->addr ==
-		dereference_function_descriptor(kretprobe_trampoline))
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
 		return 1;
 
 	return 0;

