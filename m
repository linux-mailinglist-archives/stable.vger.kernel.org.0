Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EDF64361E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 21:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbiLEUx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 15:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiLEUx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 15:53:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE48B1FD;
        Mon,  5 Dec 2022 12:53:25 -0800 (PST)
Date:   Mon, 05 Dec 2022 20:53:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670273603;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CmsGGjpzr0dBe6axNex6kpBFOEjvbolY0Nmn4TPRCvc=;
        b=JMAgtz+xhtBoishR8oGm3vgwgwuOoQb+DlLCKFJZB0lHHt88mZTH/xoHVSHO/EFBgkOjO2
        LWr6PgPEm/BBqYTA42St/ZGKfBSJqFdvLSlVkju84Q2EqyKNsCcr1oPpUEPEl1fVOgeyBN
        R2N0sJUYg9jQHSwwNzJo/CBe/kV4Lgn4fnHFuR+ew/zrwgceAr+mgtIjtfvhLWWdpl75Vu
        GlttJUThATB1buCJpF0o4j7bHtYQZHhn7bk9fKG4bzBJHz53NnIpj7P1/3b8o1oNp24aZK
        TgISUl/2p82DkFVzwQiY+MrPVk1uFBpF2a3U+Dl8qJFojOg3l9Z5wTJ01eKUzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670273603;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CmsGGjpzr0dBe6axNex6kpBFOEjvbolY0Nmn4TPRCvc=;
        b=eZF06C9aemDd9Np90Kk0EQVhbC0Drqzoj+mOTbK+IKQy+qsMBjxJBXW6a8NvS6+N0rD2Qt
        cK6hMdYbqNO4C1DQ==
From:   "tip-bot2 for Ashok Raj" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/microcode] x86/microcode/intel: Do not retry microcode
 reloading on the APs
Cc:     Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221129210832.107850-3-ashok.raj@intel.com>
References: <20221129210832.107850-3-ashok.raj@intel.com>
MIME-Version: 1.0
Message-ID: <167027360301.4906.8791952647948114025.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/microcode branch of tip:

Commit-ID:     be1b670f61443aa5d0d01782e9b8ea0ee825d018
Gitweb:        https://git.kernel.org/tip/be1b670f61443aa5d0d01782e9b8ea0ee825d018
Author:        Ashok Raj <ashok.raj@intel.com>
AuthorDate:    Tue, 29 Nov 2022 13:08:27 -08:00
Committer:     Borislav Petkov (AMD) <bp@alien8.de>
CommitterDate: Mon, 05 Dec 2022 21:22:21 +01:00

x86/microcode/intel: Do not retry microcode reloading on the APs

The retries in load_ucode_intel_ap() were in place to support systems
with mixed steppings. Mixed steppings are no longer supported and there is
only one microcode image at a time. Any retries will simply reattempt to
apply the same image over and over without making progress.

  [ bp: Zap the circumstantial reasoning from the commit message. ]

Fixes: 06b8534cb728 ("x86/microcode: Rework microcode loading")
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221129210832.107850-3-ashok.raj@intel.com
---
 arch/x86/kernel/cpu/microcode/intel.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 4f93875..2dba4b5 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -495,7 +495,6 @@ void load_ucode_intel_ap(void)
 	else
 		iup = &intel_ucode_patch;
 
-reget:
 	if (!*iup) {
 		patch = __load_ucode_intel(&uci);
 		if (!patch)
@@ -506,12 +505,7 @@ reget:
 
 	uci.mc = *iup;
 
-	if (apply_microcode_early(&uci, true)) {
-		/* Mixed-silicon system? Try to refetch the proper patch: */
-		*iup = NULL;
-
-		goto reget;
-	}
+	apply_microcode_early(&uci, true);
 }
 
 static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)
