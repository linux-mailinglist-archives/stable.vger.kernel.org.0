Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642344F5435
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiDFEp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441972AbiDEWKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 18:10:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D614A93A;
        Tue,  5 Apr 2022 13:56:19 -0700 (PDT)
Date:   Tue, 05 Apr 2022 20:56:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649192178;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVZNz50m5hLuQdgDd7OhfwNRqA0q9OGnmrTCKGq56TA=;
        b=GMNxM4ZKIQqboBm5Vu3ycSDfyRnDudvMpc2g63+HDqry/GJ0xJ403Q5+1Q2lz28Weg1np7
        Rjk2rDPZ3zBEY6rcE1X6f2gGlbz0tF5DBG2VRcv0oTdbsK9PrGEM2sChoQ4hMdCRqp7Miv
        dXtaeERY+zXcKGsuEn+mHbN2dOE6zEJfSS0x+ywnrpor2sooFOLPFLbSh9YmwsP/Rs7vMl
        vu9pXXjSqDM2/oldI+nppcfafN3XTj2G3NO0/Hevt4ejKyLULNO3FzOEQw6vZJuI1SIIJ8
        KpAlmEJz9J0Uz4P1p4S1FeGg4jrYtgrsZrWfPrEYpn5wktubRqoOnd1gmwnC3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649192178;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVZNz50m5hLuQdgDd7OhfwNRqA0q9OGnmrTCKGq56TA=;
        b=b3xdYyspc0pGjEDAnw+4PHgXW7jrO4QBKXK4X7D2b1gr8Np+L3q6ilTjgeuv0M8z6XNcUY
        tnPXQ+ZeubH6mEBA==
From:   "tip-bot2 for Ammar Faizi" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/core] x86/MCE/AMD: Fix memory leak when
 threshold_create_bank() fails
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220329104705.65256-3-ammarfaizi2@gnuweeb.org>
References: <20220329104705.65256-3-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Message-ID: <164919217670.389.1735790360584795071.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/core branch of tip:

Commit-ID:     e5f28623ceb103e13fc3d7bd45edf9818b227fd0
Gitweb:        https://git.kernel.org/tip/e5f28623ceb103e13fc3d7bd45edf9818b227fd0
Author:        Ammar Faizi <ammarfaizi2@gnuweeb.org>
AuthorDate:    Tue, 29 Mar 2022 17:47:05 +07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 05 Apr 2022 21:24:37 +02:00

x86/MCE/AMD: Fix memory leak when threshold_create_bank() fails

In mce_threshold_create_device(), if threshold_create_bank() fails, the
previously allocated threshold banks array @bp will be leaked because
the call to mce_threshold_remove_device() will not free it.

This happens because mce_threshold_remove_device() fetches the pointer
through the threshold_banks per-CPU variable but bp is written there
only after the bank creation is successful, and not before, when
threshold_create_bank() fails.

Add a helper which unwinds all the bank creation work previously done
and pass into it the previously allocated threshold banks array for
freeing.

  [ bp: Massage. ]

Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
Co-developed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-developed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220329104705.65256-3-ammarfaizi2@gnuweeb.org
---
 arch/x86/kernel/cpu/mce/amd.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1940d30..1c87501 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1294,10 +1294,23 @@ out_free:
 	kfree(bank);
 }
 
+static void __threshold_remove_device(struct threshold_bank **bp)
+{
+	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
+
+	for (bank = 0; bank < numbanks; bank++) {
+		if (!bp[bank])
+			continue;
+
+		threshold_remove_bank(bp[bank]);
+		bp[bank] = NULL;
+	}
+	kfree(bp);
+}
+
 int mce_threshold_remove_device(unsigned int cpu)
 {
 	struct threshold_bank **bp = this_cpu_read(threshold_banks);
-	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
 
 	if (!bp)
 		return 0;
@@ -1308,13 +1321,7 @@ int mce_threshold_remove_device(unsigned int cpu)
 	 */
 	this_cpu_write(threshold_banks, NULL);
 
-	for (bank = 0; bank < numbanks; bank++) {
-		if (bp[bank]) {
-			threshold_remove_bank(bp[bank]);
-			bp[bank] = NULL;
-		}
-	}
-	kfree(bp);
+	__threshold_remove_device(bp);
 	return 0;
 }
 
@@ -1351,15 +1358,14 @@ int mce_threshold_create_device(unsigned int cpu)
 		if (!(this_cpu_read(bank_map) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(bp, cpu, bank);
-		if (err)
-			goto out_err;
+		if (err) {
+			__threshold_remove_device(bp);
+			return err;
+		}
 	}
 	this_cpu_write(threshold_banks, bp);
 
 	if (thresholding_irq_en)
 		mce_threshold_vector = amd_threshold_interrupt;
 	return 0;
-out_err:
-	mce_threshold_remove_device(cpu);
-	return err;
 }
