Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E764D3F02
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 02:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiCJBzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 20:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiCJBzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 20:55:00 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DDD12867A;
        Wed,  9 Mar 2022 17:53:59 -0800 (PST)
Received: from integral2.. (unknown [114.10.7.234])
        by gnuweeb.org (Postfix) with ESMTPSA id EAB117E2D8;
        Thu, 10 Mar 2022 01:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646877239;
        bh=4osDx3D9jfGqlsB1arjr7DzEz5HAJ5v/iZnmYw+BPBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQGnzPmMKyFHFuJ/jNwIAJeEyok84fmwQabK/6ysdrWtYoZQPGsxkyy15PdILcpjN
         nvqnSBOL/0jToYzWkwhFivuoIA1RT+P2atBwA6rlE+6x9fQtx7rgGib8BLboC29dS3
         6+R2BZD7o0hOJbPNsrM4vpHmr2Vjaqr6TQcwfQ76wYXiRRFJ4s6jgybyCU4Oc2d0Mx
         3fLSMbu0ZU62xkgu65PKAa8DUaBqp4GxxR+SejH+6ezT3SKQorXU3naJZLe0I+Jhd0
         KgxitHH71MOKNN8gt3wSs2HiAQM4FG+Xi3Ngb3ANViovcI/WaVnqdfS7M2YmR3e+B5
         CrFSv/B9NJNPQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org
Subject: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails
Date:   Thu, 10 Mar 2022 08:53:06 +0700
Message-Id: <20220310015306.445359-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
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
_mce_threshold_remove_device(), then call it from create/remove device
functions.

Also, eliminate the "goto out_err", just early return inside the loop
if the creation fails.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v5.8+
Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
Link: https://lore.kernel.org/lkml/9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-authored-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 arch/x86/kernel/cpu/mce/amd.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 9f4b508886dd..e492efab68a2 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1293,10 +1293,23 @@ static void threshold_remove_bank(struct threshold_bank *bank)
 	kfree(bank);
 }
 
+static void _mce_threshold_remove_device(struct threshold_bank **bp,
+					 unsigned int numbanks)
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
@@ -1307,13 +1320,7 @@ int mce_threshold_remove_device(unsigned int cpu)
 	 */
 	this_cpu_write(threshold_banks, NULL);
 
-	for (bank = 0; bank < numbanks; bank++) {
-		if (bp[bank]) {
-			threshold_remove_bank(bp[bank]);
-			bp[bank] = NULL;
-		}
-	}
-	kfree(bp);
+	_mce_threshold_remove_device(bp, this_cpu_read(mce_num_banks));
 	return 0;
 }
 
@@ -1350,15 +1357,14 @@ int mce_threshold_create_device(unsigned int cpu)
 		if (!(this_cpu_read(bank_map) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(bp, cpu, bank);
-		if (err)
-			goto out_err;
+		if (err) {
+			_mce_threshold_remove_device(bp, numbanks);
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
2.32.0

