Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBA8602850
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJRJ0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJRJ0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:26:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749C8AE848;
        Tue, 18 Oct 2022 02:26:20 -0700 (PDT)
Date:   Tue, 18 Oct 2022 09:26:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666085177;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=k1t2QP68OmE6u2uzMGPoB8a7JOZ2kIqcFRyJqlQqc6A=;
        b=jj3zOxKigIdkl2IAmy9jJF1vl1x266TiYq5fuLJonxzG0p7ESzH7issoXhbtk8NrdQKLJj
        h4t5GEX6a63Dnwrn8LUItSme2k6SWWMvGczSFX+07ogardio19cJG54qmvphl8pgCiEMFX
        2Iks4dkUDNuLBvue7Sf8ZLA60sd88UcTpLXmGIhrze7I7Ku9Wzh1pheoAsR5WBeztF7stn
        B1/oqaiNYYtCP+eKcYTNwQptRl7B53pF9EPkDyFeZ4jarWBHWIYikHC8scBBzrb4hOaNci
        gfKQxn07NA8graJHDFETfxRBSHuqdWEwlsaKQvW/5F/sTiM0cQI7gxG/ldHJCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666085177;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=k1t2QP68OmE6u2uzMGPoB8a7JOZ2kIqcFRyJqlQqc6A=;
        b=iROsh7ZwVQwCQDQeJ5cTvUee+3mqOin302YkbQ489/mj5xLqqfX32DPRo87t+PicTW/QGk
        M2fgoScgqfpWA0Dg==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/microcode/AMD: Apply the patch early on every
 logical thread
Cc:     stefantalpalaru@yahoo.com, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <166608517523.401.12312055863747452497.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e7ad18d1169c62e6c78c01ff693fd362d9d65278
Gitweb:        https://git.kernel.org/tip/e7ad18d1169c62e6c78c01ff693fd362d9d=
65278
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 05 Oct 2022 12:00:08 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 18 Oct 2022 11:03:27 +02:00

x86/microcode/AMD: Apply the patch early on every logical thread

Currently, the patch application logic checks whether the revision
needs to be applied on each logical CPU (SMT thread). Therefore, on SMT
designs where the microcode engine is shared between the two threads,
the application happens only on one of them as that is enough to update
the shared microcode engine.

However, there are microcode patches which do per-thread modification,
see Link tag below.

Therefore, drop the revision check and try applying on each thread. This
is what the BIOS does too so this method is very much tested.

Btw, change only the early paths. On the late loading paths, there's no
point in doing per-thread modification because if is it some case like
in the bugzilla below - removing a CPUID flag - the kernel cannot go and
un-use features it has detected are there early. For that, one should
use early loading anyway.

  [ bp: Fixes does not contain the oldest commit which did check for
    equality but that is good enough. ]

Fixes: 8801b3fcb574 ("x86/microcode/AMD: Rework container parsing")
Reported-by:  =C8=98tefan Talpalaru <stefantalpalaru@yahoo.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by:  =C8=98tefan Talpalaru <stefantalpalaru@yahoo.com>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216211
---
 arch/x86/kernel/cpu/microcode/amd.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microc=
ode/amd.c
index e7410e9..3a35dec 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -440,7 +440,13 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, =
size_t size, bool save_p
 		return ret;
=20
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev >=3D mc->hdr.patch_id)
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (rev > mc->hdr.patch_id)
 		return ret;
=20
 	if (!__apply_microcode_amd(mc)) {
@@ -528,8 +534,12 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
=20
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
=20
-	/* Check whether we have saved a new patch already: */
-	if (*new_rev && rev < mc->hdr.patch_id) {
+	/*
+	 * Check whether a new patch has been saved already. Also, allow applicatio=
n of
+	 * the same revision in order to pick up SMT-thread-specific configuration =
even
+	 * if the sibling SMT thread already has an up-to-date revision.
+	 */
+	if (*new_rev && rev <=3D mc->hdr.patch_id) {
 		if (!__apply_microcode_amd(mc)) {
 			*new_rev =3D mc->hdr.patch_id;
 			return;
