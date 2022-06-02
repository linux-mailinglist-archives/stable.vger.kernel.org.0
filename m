Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88C53C105
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 00:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbiFBWrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 18:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbiFBWrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 18:47:11 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jun 2022 15:47:09 PDT
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [139.138.35.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F2DBCAA
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 15:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654210029; x=1685746029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=muyxEwkNSN+Avf2jkJXMqhDnz9pMPkJ+tE8jAaGuVzY=;
  b=IItV4nk9rBJzD9umn/N25tkxhPRXBe8Vn25H0nZ/0WNAZ6FkQ30E2n1p
   yx4tpw7Fey+uPq+ShXsM4WzEhhrqCTs9dGTW3hip0Cq593QW/f9+Hl2Wa
   m4HyfQ1HpuEH82TVyS3FIaGYgEyzTVHjnq10tgYykEOATnVWyRZPghvjU
   Y=;
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 15:46:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2YFFsdH3HX0JoWliPwyCDYrbrDjIGiVYW1LJVKrU+c2JyShnY9lMlrZkFON0P+g9GtUoR0KSjuYIxHTfIvtevEUu4sD7Oc3S0FrhVevrJ1BoZf077r6KGiCto7sOBOo6SBwOrglg+0pSRuJZmCpTzieKD8v9j0RpuctNQ5/sCjhrWtWxFT1eYCX5ID1n744MtcU5wyjdGJMGHpAb8WsmszC3TkEIq9/fLbcC4/mj2AiDqnR3yaHM6g4m0kKM8zgC9cbgFBEqpHQltUXsjfZan0p6PKQrExz3xcm6DuV/8a6MygNsNnQ5FqPGIq8JzZqGYCYtx0lMzTEDT1UPOgenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riWZ6nEuSByJY96cBLYzGJ5F10XOG4LeLE3CGdr1LP0=;
 b=I5bPOyAvINP2E7q5mxIFlvwyVrhgCNG9ugJOCb0Uw2duJHWwz8cYpxAyWEv7Wo93M2JVuuiN/rHJqr36DM9ch9tezs2NjERTOxlHrBpa8Q3MMtgmFrXjNCf0f4WOX9LHF6MBG5be3xPz0IMbhniSAfDb5x2Bjbek1NHdWdpSgkUISmP/Ef6hcNDfqqRcCuf4CLMg7vPqamcU+QPyL1p/PD1o/68sawIfDr64yJLiYeaqwQP9SQVSu1hDyC3W27MBX8hnaojEYGFmZiLkhfco506UTbm8EykAmaNAcWcs2clmWgYhomMqFSoiuCuc01sioPZoUE1Ddoo+nutvDLICZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.51) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riWZ6nEuSByJY96cBLYzGJ5F10XOG4LeLE3CGdr1LP0=;
 b=GF9AS79Hs5zl/oGcfmCDq1XTtOwNMRI/6qhRUORbt96+uXGnWVN1i4Dnc6bsQ9FB2rSLGekrO4D5H7KaOnlFYx/ZdVUujQOZMiDuU4Mfx1FUyyJLrJBFHG6rkwD8X1p3hWjLD4uqPcCKtIo/gdHIeT0JgoOkuI0+Qwlyw2h2zko=
Received: from DM6PR02CA0132.namprd02.prod.outlook.com (2603:10b6:5:1b4::34)
 by BN6PR20MB1235.namprd20.prod.outlook.com (2603:10b6:404:8a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 22:46:00 +0000
Received: from DM6NAM10FT031.eop-nam10.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::1c) by DM6PR02CA0132.outlook.office365.com
 (2603:10b6:5:1b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15 via Frontend
 Transport; Thu, 2 Jun 2022 22:45:59 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.51)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa002.seagate.com (192.55.16.51) by
 DM6NAM10FT031.mail.protection.outlook.com (10.13.152.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 22:45:58 +0000
Received: from sgspiesaa002.seagate.com ([10.4.144.53])
  by sgspzesaa002.seagate.com with ESMTP; 02 Jun 2022 15:48:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="62195114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO tyler-ubuntu.colo.seagate.com) ([10.4.50.15])
  by sgspiesaa002.seagate.com with ESMTP; 02 Jun 2022 15:33:29 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] libata: fix reading concurrent positioning ranges log
Date:   Thu,  2 Jun 2022 16:51:11 -0600
Message-Id: <20220602225113.10218-2-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220602225113.10218-1-tyler.erickson@seagate.com>
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c1c1db09-a83a-4390-2ef3-08da44e9aa29
X-MS-TrafficTypeDiagnostic: BN6PR20MB1235:EE_
X-Microsoft-Antispam-PRVS: <BN6PR20MB12359A0498355CA65EAF4FA489DE9@BN6PR20MB1235.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4CsJHUIcfRmXZyYfTerS2g4CUdRsLlHllofcapETRq/d8ETsIJ1Ok0v72HrSgCNxn7TK50Ei9HIArx8kY9tp32o3syrB1y0tmhdF6bod9Xe/4ri8Tb1b4m3XKUXohltq1KDVufYvzm0AhpFVfhOuwGkXPPvXtTrTI28NoUvY4ayultCACrLz/IIESKXiDnXnggGNUgMRqoNLclw+lpI/TbsVgNvM519bX8qEf5WYw+s9uQJBMtb3TRF5YjX580wrlTLKWAHcEuCEyt5KNowz+d+9GQxMH14BaUiYCG67sXT/QUk+V+fSmOqQEYuoocJd6iuaazuOf7ghnM4l6yKhM+OCAduqMc0nq9W3ShBtnyaKGVcY1OtUIvDp2H7iZ+jvZJbre/cuyrkfmCFQAnFubNCSWIPcfhN26stFkAOlvUa68OoYJLpUrVulw4HDc8kE1RExzQq/5KF2Z9tuMPizvteM5iYcV1YcBTKRNHw0F+zkh30tvRfuP5D7sxzqH8pNsf/wLedOybch10IFGZrX0BdkPJOvwvNSxlRZfnM462idZvrsq5Y2aZZ1sqbUNeX421m7112/shQQgSu8PqZODbM3xOesi9EjVDxqDP4JAkF5Cd59sphszdNHlFuXT2/AgdRFUqdd9+/DPkj3Icns0Po4wwCP2T3UT/X/oX8k9x2qHndEsOTeusLtFb2X/GkGEE5OuxkKxyKCv5++vwYUEg==
X-Forefront-Antispam-Report: CIP:192.55.16.51;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa002.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(40470700004)(36840700001)(46966006)(47076005)(82310400005)(1076003)(426003)(336012)(2616005)(40460700003)(356005)(316002)(26005)(70206006)(81166007)(36860700001)(2906002)(186003)(86362001)(7696005)(36756003)(83380400001)(6666004)(44832011)(508600001)(8936002)(8676002)(4326008)(450100002)(5660300002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 22:45:58.7054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c1db09-a83a-4390-2ef3-08da44e9aa29
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.51];Helo=[sgspzesaa002.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT031.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR20MB1235
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The concurrent positioning ranges log is not a fixed size and may depend
on how many ranges are supported by the device. This patch uses the size
reported in the GPL directory to determine the number of pages supported
by the device before attempting to read this log page.

This resolves this error from the dmesg output:
    ata6.00: Read log 0x47 page 0x00 failed, Emask 0x1

Cc: stable@vger.kernel.org
Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>
---
 drivers/ata/libata-core.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 40e816419f48..3ea10f72cb70 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2010,16 +2010,16 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 	return err_mask;
 }
 
-static bool ata_log_supported(struct ata_device *dev, u8 log)
+static int ata_log_supported(struct ata_device *dev, u8 log)
 {
 	struct ata_port *ap = dev->link->ap;
 
 	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
-		return false;
+		return 0;
 
 	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
-		return false;
-	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
+		return 0;
+	return get_unaligned_le16(&ap->sector_buf[log * 2]);
 }
 
 static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
@@ -2455,15 +2455,20 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 	struct ata_cpr_log *cpr_log = NULL;
 	u8 *desc, *buf = NULL;
 
-	if (ata_id_major_version(dev->id) < 11 ||
-	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+	if (ata_id_major_version(dev->id) < 11)
+		goto out;
+
+	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
+	if (buf_len == 0)
 		goto out;
 
 	/*
 	 * Read the concurrent positioning ranges log (0x47). We can have at
-	 * most 255 32B range descriptors plus a 64B header.
+	 * most 255 32B range descriptors plus a 64B header. This log varies in
+	 * size, so use the size reported in the GPL directory. Reading beyond
+	 * the supported length will result in an error.
 	 */
-	buf_len = (64 + 255 * 32 + 511) & ~511;
+	buf_len <<= 9;
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		goto out;
-- 
2.17.1

