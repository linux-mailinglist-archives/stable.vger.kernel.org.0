Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE6462B027
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 01:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiKPAjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 19:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiKPAjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 19:39:15 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F402C660;
        Tue, 15 Nov 2022 16:39:11 -0800 (PST)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AG09sL0014656;
        Wed, 16 Nov 2022 00:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=1iS3lrEK+tv0cCqy+H0HiSOeS346CRjJ8p8wkeyh3RI=;
 b=K1Fw+0Bb/Bu0Pg7Rqlj3v7rM3u21n5liBVKlF2RBXevI/2PmBgiUwlEz6gllcMIToPAV
 Lk1U8FHZR60C5rMhPVOaxj0ybDMzRdQb3nWF4eivNySg397SPrM2sKdUwE2/FBxlr8xs
 eJZIR0BW7SgMRNiooFodn0Ro4T+urI+voHVJVjqH5zwuhaHKjYi+ZUhSnCM4TPcN5H8K
 p3eQmi65T5OF37Stx/eRaTbW/cyqS2umVVjhIQN/7B7iMCKHOgUTf7E4q9BA4ZwuHrUG
 vW18r+Qmozx7cZUDBTWNigtdldmaRaOzkQoPNTyIeH4duBMpjOcpw1PnmLdePV7Oa3Dv OA== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3kvn2u0qm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 00:38:46 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AG0bPo8011542;
        Tue, 15 Nov 2022 19:38:45 -0500
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint4.akamai.com (PPS) with ESMTP id 3kt7q44b6f-1;
        Tue, 15 Nov 2022 19:38:45 -0500
Received: from bos-lhv9ol.bos01.corp.akamai.com (bos-lhv9ol.bos01.corp.akamai.com [172.28.222.101])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id DFE0D60246;
        Wed, 16 Nov 2022 00:38:44 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     bp@alien8.de
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Shuai Xue <xueshuai@linux.alibaba.com>, stable@vger.kernel.org
Subject: [PATCH] EDAC/edac_module: order edac_init() before ghes_edac_register()
Date:   Tue, 15 Nov 2022 19:37:29 -0500
Message-Id: <20221116003729.194802-1-jbaron@akamai.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=990 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211160002
X-Proofpoint-GUID: h6FjdD_WwI_joBIgADWM-Ow_K8zJZBOr
X-Proofpoint-ORIG-GUID: h6FjdD_WwI_joBIgADWM-Ow_K8zJZBOr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 mlxlogscore=893 bulkscore=0
 clxscore=1011 spamscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211160001
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, ghes_edac_register() is called via ghes_init() from acpi_init()
at the subsys_initcall() level. However, edac_init() is also called from
the subsys_initcall(), leaving the ordering ambiguous.

If ghes_edac_register() is called first, then 'mc0' ends up at:
/sys/devices/mc0/, instead of the expected:
/sys/devices/system/edac/mc/mc0.

So while everything seems ok, other than the unexpected sysfs location, it
seems like 'edac_init()' should be called before any drivers start
registering. So have 'edac_init()' called earlier via arch_initcall().

However, this moves edac_pci_clear_parity_errors() up as well. Seems like
this wants to be called after pci bus scan, so keep
edac_pci_clear_parity_errors() at subsys_init(). That said, it seems like
pci bus scan happens at subsys_init() level, so really the parity clearing
should be moved later. But that can be left as a separate patch.

Fixes: dc4e8c07e9e2 ("ACPI: APEI: explicit init of HEST and GHES in apci_init()")
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>
Cc: Robert Richter <rric@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: stable@vger.kernel.org
---
 drivers/edac/edac_module.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 32a931d0cb71..407d4a5fce7a 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -109,15 +109,6 @@ static int __init edac_init(void)
 	if (err)
 		return err;
 
-	/*
-	 * Harvest and clear any boot/initialization PCI parity errors
-	 *
-	 * FIXME: This only clears errors logged by devices present at time of
-	 *      module initialization.  We should also do an initial clear
-	 *      of each newly hotplugged device.
-	 */
-	edac_pci_clear_parity_errors();
-
 	err = edac_mc_sysfs_init();
 	if (err)
 		goto err_sysfs;
@@ -157,12 +148,34 @@ static void __exit edac_exit(void)
 	edac_subsys_exit();
 }
 
+static void __init edac_init_clear_parity_errors(void)
+{
+	/*
+	 * Harvest and clear any boot/initialization PCI parity errors
+	 *
+	 * FIXME: This only clears errors logged by devices present at time of
+	 *      module initialization.  We should also do an initial clear
+	 *      of each newly hotplugged device.
+	 */
+	edac_pci_clear_parity_errors();
+
+	return 0;
+}
+
 /*
  * Inform the kernel of our entry and exit points
+ *
+ * ghes_edac_register() is call via acpi_init() -> ghes_init()
+ * at the subsys_initcall level so edac_init() must come first
  */
-subsys_initcall(edac_init);
+arch_initcall(edac_init);
 module_exit(edac_exit);
 
+/*
+ * Clear parity errors after PCI subsys is initialized
+ */
+subsys_initcall(edac_init_clear_parity_errors);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Doug Thompson www.softwarebitmaker.com, et al");
 MODULE_DESCRIPTION("Core library routines for EDAC reporting");
-- 
2.17.1

