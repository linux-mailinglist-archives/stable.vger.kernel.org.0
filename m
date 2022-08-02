Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B210587B41
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 13:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbiHBLDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 07:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiHBLDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 07:03:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43B45006B;
        Tue,  2 Aug 2022 04:03:10 -0700 (PDT)
Date:   Tue, 02 Aug 2022 11:03:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659438188;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=quj/DIYnqZXApkrdHkfR5Acc22JBv5Wfc2X2gChjjg4=;
        b=bIa86NKUD9QHxI3b3vHNYYHQd2DL+0lfw2tluWCPaoGn9K9BqXflJT4TAofF69VQI491SC
        XciKyYResPAHBT2dNqrk7GI6qJbXixhpRgETjCq8cjBsLq0J3Y0dztQl5zNG16uBnP8TAq
        nh+ULaW7AbrYFgb/nETgt9vtqoFUuy0O9CUnhohuey+KqoYZSAGTk6tSgB6avhQ5QhDjVh
        Sk5etpmNhsH5wLiM55Nzvq5tHiBB5C9UMFORyKsXAfpSMnDIS4Nlj9dnMi874ukOsyGZsK
        lKZlMsPaQej8KRnAW44dJzw4eSxsZPvl2dQMDBZb3qph9OCqNYX0lbeYo8BI4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659438188;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=quj/DIYnqZXApkrdHkfR5Acc22JBv5Wfc2X2gChjjg4=;
        b=8WfWDHfBERUUKIpq/jyzLcKxWTlUfoewKUQzaYxheBI0ZOs5ErkU+fvEAKln8OTlshzU1j
        Pfq0ujLg8z6uG7Dw==
From:   "tip-bot2 for Masami Hiramatsu (Google)" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] x86/kprobes: Update kcb status flag after singlestepping
Cc:     deso@posteo.net, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220727210136.jjgc3lpqeq42yr3m@muellerd-fedora-PC2BDTX9>
References: <20220727210136.jjgc3lpqeq42yr3m@muellerd-fedora-PC2BDTX9>
MIME-Version: 1.0
Message-ID: <165943818693.15455.252081735537091891.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     dec8784c9088b131a1523f582c2194cfc8107dc0
Gitweb:        https://git.kernel.org/tip/dec8784c9088b131a1523f582c2194cfc81=
07dc0
Author:        Masami Hiramatsu (Google) <mhiramat@kernel.org>
AuthorDate:    Tue, 02 Aug 2022 15:04:16 +09:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 02 Aug 2022 12:35:04 +02:00

x86/kprobes: Update kcb status flag after singlestepping

Fix kprobes to update kcb (kprobes control block) status flag to
KPROBE_HIT_SSDONE even if the kp->post_handler is not set.

This bug may cause a kernel panic if another INT3 user runs right
after kprobes because kprobe_int3_handler() misunderstands the
INT3 is kprobe's single stepping INT3.

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-=
step")
Reported-by: Daniel M=C3=BCller <deso@posteo.net>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Daniel M=C3=BCller <deso@posteo.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20220727210136.jjgc3lpqeq42yr3m@muellerd-fe=
dora-PC2BDTX9
Link: https://lore.kernel.org/r/165942025658.342061.12452378391879093249.stgi=
t@devnote2
---
 arch/x86/kernel/kprobes/core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7c4ab88..74167dc 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -814,16 +814,20 @@ set_current_kprobe(struct kprobe *p, struct pt_regs *re=
gs,
 static void kprobe_post_process(struct kprobe *cur, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
-	if ((kcb->kprobe_status !=3D KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status =3D KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
 	/* Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status =3D=3D KPROBE_REENTER)
+	if (kcb->kprobe_status =3D=3D KPROBE_REENTER) {
+		/* This will restore both kcb and current_kprobe */
 		restore_previous_kprobe(kcb);
-	else
+	} else {
+		/*
+		 * Always update the kcb status because
+		 * reset_curent_kprobe() doesn't update kcb.
+		 */
+		kcb->kprobe_status =3D KPROBE_HIT_SSDONE;
+		if (cur->post_handler)
+			cur->post_handler(cur, regs, 0);
 		reset_current_kprobe();
+	}
 }
 NOKPROBE_SYMBOL(kprobe_post_process);
=20
