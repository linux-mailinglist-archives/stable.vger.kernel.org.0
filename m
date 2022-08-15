Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1DF594CE2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241854AbiHPAyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348421AbiHPAwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF3C19B727;
        Mon, 15 Aug 2022 13:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E865B8113E;
        Mon, 15 Aug 2022 20:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5009C433C1;
        Mon, 15 Aug 2022 20:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596446;
        bh=ufwO8vqLDDu71bVtWRi8o3m8JUyw8NsgBLtUn+/druI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCd+No0s3Md66P00O6xes+079qzFuRs0dg68l3tqJRkK9iveuWLM6uJDfJ1Z4sFAd
         XZPLnLkxKk7rq7/AIQj7Y+IvO0Z/hEg4ATILnAGg69OTtfRUEsqr9wj/yEo2BHhAQI
         BlPm7DDsHTFSPkp07+FcjGVQBR56afl0pEC3szXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.19 1048/1157] x86/kprobes: Update kcb status flag after singlestepping
Date:   Mon, 15 Aug 2022 20:06:44 +0200
Message-Id: <20220815180521.971463783@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
@@ -814,16 +814,20 @@ set_current_kprobe(struct kprobe *p, str
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
 


