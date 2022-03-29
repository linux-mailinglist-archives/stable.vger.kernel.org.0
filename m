Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F8D4EAB9D
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 12:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiC2KtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 06:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiC2KtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 06:49:16 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519C32493FE;
        Tue, 29 Mar 2022 03:47:30 -0700 (PDT)
Received: from integral2.. (unknown [182.2.70.161])
        by gnuweeb.org (Postfix) with ESMTPSA id 95FDE7E730;
        Tue, 29 Mar 2022 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648550849;
        bh=xQLROf1mQKyJFxRsJjuQiVAUI8GU+Wo/R6YJPVHiVwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSnV1KwmemuCBpfphq4rfWvdgDUS8kpsXg+KnxzX4XEVkDkXAKI73cIc+aclqdjDl
         m2ybsuFLrXfciYGO9JkkBUEGcQP/hD3iennfYyPtLjSdYCtnA63SVAkKtJoGw6FYhz
         /LKOV4G42N6rH53wrNSWdQaSQD0QESHkCVIBO4ZAPEKiXklvSaIhNrz/iIkgu8S5ZS
         kdwuwP5vQqEow49tZADiIXZAPNxP1wJdXyhT5qmiZieTYZ0gMhqGJzkFesGX0vcoA0
         moIy78du6kGSn6MMUqTdJIooT2BGbtyWJbixyuWtGjFVrO0EiJ++m8dKl4BJNQ8f/W
         sMGXPj1QdAjww==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>
Subject: [PATCH v6 2/2] x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails
Date:   Tue, 29 Mar 2022 17:47:05 +0700
Message-Id: <20220329104705.65256-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In mce_threshold_create_device(), if threshold_create_bank() fails, the
@bp will be leaked, because the call to mce_threshold_remove_device()
will not free the @bp. mce_threshold_remove_device() frees
@threshold_banks. At that point, the @bp has not been written to
@threshold_banks, @threshold_banks is NULL, so the call is just a nop.

Fix this by extracting the cleanup part into a new static function
__threshold_remove_device(), then call it from create/remove device
functions.

Also, eliminate the "goto out_err", just early return inside the loop
if the creation fails.

Cc: stable@vger.kernel.org # v5.8+
Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
Co-developed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-developed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

   v6:
     - Change the helper function name to __threshold_remove_device().

---
 arch/x86/kernel/cpu/mce/amd.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1940d305db1c..d293ae088d6b 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1294,10 +1294,23 @@ static void threshold_remove_bank(struct threshold_bank *bank)
 	kfree(bank);
 }
 
+static void __threshold_remove_device(struct threshold_bank **bp,
+				       unsigned int numbanks)
+{
+	unsigned int bank;
+
+	for (bank = 0; bank < numbanks; bank++) {
+		if (bp[bank]) {
+			threshold_remove_bank(bp[bank]);
+			bp[bank] = NULL;
+		}
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
+	__threshold_remove_device(bp, this_cpu_read(mce_num_banks));
 	return 0;
 }
 
@@ -1351,15 +1358,14 @@ int mce_threshold_create_device(unsigned int cpu)
 		if (!(this_cpu_read(bank_map) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(bp, cpu, bank);
-		if (err)
-			goto out_err;
+		if (err) {
+			__threshold_remove_device(bp, numbanks);
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
-- 
Ammar Faizi

