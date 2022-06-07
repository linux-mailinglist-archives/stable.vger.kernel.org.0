Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D596541109
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355359AbiFGTcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356428AbiFGTbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C212A26A;
        Tue,  7 Jun 2022 11:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF3C61680;
        Tue,  7 Jun 2022 18:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFC2C385A2;
        Tue,  7 Jun 2022 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625529;
        bh=Or3I5ax0ScbqY3kyukUfX18+lUDyd51bRsv7lWoyVrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwNF97Hf+4RWKtBktZWN/Dh6LKE+ruWoL/dkchPMQYZJYb8K0QPmM84c3Ig3I2j/H
         uHKsz3Ba9q8xtvCiZErgyQ6W3H+xexbJCZ+om8DFyDyhOevSjTPy379F/NibyOHtCr
         grBKzkgub6o/2/dFP2JUwngFiNO767tvcks/RUkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.17 034/772] x86/MCE/AMD: Fix memory leak when threshold_create_bank() fails
Date:   Tue,  7 Jun 2022 18:53:46 +0200
Message-Id: <20220607164950.028823976@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

commit e5f28623ceb103e13fc3d7bd45edf9818b227fd0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1293,10 +1293,23 @@ out_free:
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
@@ -1307,13 +1320,7 @@ int mce_threshold_remove_device(unsigned
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
 
@@ -1350,15 +1357,14 @@ int mce_threshold_create_device(unsigned
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


