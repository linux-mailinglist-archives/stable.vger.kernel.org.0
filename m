Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3B9593CDF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344500AbiHOTrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345039AbiHOTqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3116D9E0;
        Mon, 15 Aug 2022 11:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1134611CA;
        Mon, 15 Aug 2022 18:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD66EC433D6;
        Mon, 15 Aug 2022 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589327;
        bh=k0u/vGeggDbZwt1WBxF9FGs6XocuAMYXyNIzJIgT5zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwkJ/MjsuIQXQQMoNXPBeYW5Gy/V/2cPWsyzAKTuqbqTVERVAs9H8qlFsBns19vVP
         VmbjDtgmFTHc5/gCij2oTNcXtrgvi0XCfoZrhmfL11hmPzuGIw0jPLyVYnIRN/6L2P
         RXFlsDcJCGrkYrt3VujVS9rvsygtvGkaM7iQoZmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.15 683/779] x86/kprobes: Update kcb status flag after singlestepping
Date:   Mon, 15 Aug 2022 20:05:27 +0200
Message-Id: <20220815180406.548277051@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit dec8784c9088b131a1523f582c2194cfc8107dc0 upstream.

Fix kprobes to update kcb (kprobes control block) status flag to
KPROBE_HIT_SSDONE even if the kp->post_handler is not set.

This bug may cause a kernel panic if another INT3 user runs right
after kprobes because kprobe_int3_handler() misunderstands the
INT3 is kprobe's single stepping INT3.

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Reported-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Daniel Müller <deso@posteo.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20220727210136.jjgc3lpqeq42yr3m@muellerd-fedora-PC2BDTX9
Link: https://lore.kernel.org/r/165942025658.342061.12452378391879093249.stgit@devnote2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -816,16 +816,20 @@ NOKPROBE_SYMBOL(arch_prepare_kretprobe);
 static void kprobe_post_process(struct kprobe *cur, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
 	/* Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER)
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		/* This will restore both kcb and current_kprobe */
 		restore_previous_kprobe(kcb);
-	else
+	} else {
+		/*
+		 * Always update the kcb status because
+		 * reset_curent_kprobe() doesn't update kcb.
+		 */
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		if (cur->post_handler)
+			cur->post_handler(cur, regs, 0);
 		reset_current_kprobe();
+	}
 }
 NOKPROBE_SYMBOL(kprobe_post_process);
 


