Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36E854085A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347729AbiFGR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348485AbiFGR5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:57:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAE23139D;
        Tue,  7 Jun 2022 10:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 360376146F;
        Tue,  7 Jun 2022 17:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45429C385A5;
        Tue,  7 Jun 2022 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623626;
        bh=U6/EdSuc+660T/vtz96Q2XA9sTuGkSssNogEEj+9RrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV5oOCP62re1cFkge9HwwcpsupilpkentZyhGcrRPKfLOKzffWNmpIJ+g5C1BcDPS
         z1uN1Tfhus45kXKD47syfDRMAF7Dbmxrn7X7M/ADQFYzIDI5YDez0iKBpON8O5dgi+
         qWM9tsXSDMHGjDE7upT67lKC65mxd3wp6WkLpKW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 032/667] x86/MCE/AMD: Fix memory leak when threshold_create_bank() fails
Date:   Tue,  7 Jun 2022 18:54:57 +0200
Message-Id: <20220607164935.759519492@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
@@ -1470,10 +1470,23 @@ out_free:
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
@@ -1484,13 +1497,7 @@ int mce_threshold_remove_device(unsigned
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
 
@@ -1527,15 +1534,14 @@ int mce_threshold_create_device(unsigned
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


