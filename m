Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370E22961D6
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 17:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368711AbgJVPpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 11:45:14 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:36833
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S368712AbgJVPpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 11:45:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFpPZKe9nvrx2d9aD/86Fmu6WGWLU9lAzpHpKH6YsnzkWn5MqkJ2S+6pOP2pqE4WyThfRuOzj7JVfizdzqW2qHwE2BXvtuSXrFIUPU9GWnimQRVB04JHUK7Aezzs7X62tjwkU/yr826qED05q4st4985nfgsN1BXdgTOMB8jrEdTGlsrOHyJsOuPSWrHXh4J5KuNxEyNDHXsygXOjJPO3pdmwwGyTQprW0JEg++cYvkIIuba/7IDnJzV14ZM7xiJdbmshV+pbJzN2kH0pnX8E3u3SLAixp5PKtXFMpSNo6L3CbRwO5D8Tk1JogjghQnJ9JAe3UPKECScvMdr/h4ICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4QTmTFzjEU4Nrqgyh5ZO5DzF8pqrqakuJWgt6o/tpM=;
 b=mehKvOp0u2Bq5PqCmHzQ+l1m44hF7FN2lEOKQ3EkjQ9BtpEnhcPjdd3IydLK9Jvg2TazQFvQ1u+nsfv5bqBhHM10xtC3qfQ7waLILP8lqBr8/0+P1e2moL8c54RD7KnwwkVpXNSUMK1Dz37JYHO6ci3xWW5/+vYPC5xMbefG0LsB2HS0PP2RKEU4w2v0dRhNcKxQCqKRqhMBjAXnwRWOMTeFuyQvyB5f9bjOX8yn4ZF+W+/BD+znLvKFtrqT5hIL4GrJ4saVN/KwGgnXQsbhSgYiXOtmR9aGp1ovi2xKPfASjDrnJeCZEG/KIehjCF70rckwXVO6BV6yIAatQiH9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4QTmTFzjEU4Nrqgyh5ZO5DzF8pqrqakuJWgt6o/tpM=;
 b=f5DX8eY+KMn1oDJvL+zf07j53wWIjmb8j+3wHT/pM9fiZhyct8uTUFrNYM7fJKCyUlukXTsv28eysbQ7NG18d4dmxW8t9AaAuIag3Xi03iUixY8yWZsjLN8YbZax9luBrlkXg2w2hzSgW92IhaFcBeSvWaCpTfF+JX2EUlSmUWU=
Received: from DM5PR21CA0013.namprd21.prod.outlook.com (2603:10b6:3:ac::23) by
 DM6PR10MB4154.namprd10.prod.outlook.com (2603:10b6:5:21f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.28; Thu, 22 Oct 2020 15:45:11 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::fe) by DM5PR21CA0013.outlook.office365.com
 (2603:10b6:3:ac::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.17 via Frontend
 Transport; Thu, 22 Oct 2020 15:45:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3499.18 via Frontend Transport; Thu, 22 Oct 2020 15:45:10 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 22 Oct 2020 08:45:09 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.1847.3 via Frontend Transport; Thu, 22 Oct 2020 08:45:09 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Thu, 22 Oct 2020 08:45:09 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id B71D12C03206;
        Thu, 22 Oct 2020 17:45:08 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id B11401328F; Thu, 22 Oct 2020 17:45:08 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     "linux-mtd @ lists . infradead . org" <linux-mtd@lists.infradead.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Date:   Thu, 22 Oct 2020 17:45:06 +0200
Message-ID: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Oct 2020 15:45:09.0552 (UTC) FILETIME=[52682B00:01D6A88A]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c10f0a3-0863-4631-fdfd-08d876a175aa
X-MS-TrafficTypeDiagnostic: DM6PR10MB4154:
X-Microsoft-Antispam-PRVS: <DM6PR10MB4154312B37A9A6CC85E7777BF41D0@DM6PR10MB4154.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccWEhSPM3ZHnjDRWcO07sFWcFv3GKdKNF3hoGwlLoFJxDID98e5SGZO2IfeicsLjXcbosssh3qez/G5Eh1d+hiXQwO+IMzfgcJiUWRPimN0WMSg6+3qYBOd4pskhzcWw1OQkGASJusLbfWxTZ/2y+4gVwJWowDaa6sBwSOVhM0C2DtU5hbsEnaVVZZiRezXlwYnFr2LX0HxKGqPnWBTaxaQy3CCQRP/ikDybqgLFixU6KkbyGL42lAxDDaPd1RCFVhTlop6BfU8ojWPfAfpWRUQTOGXUukneGXJsCfOLdRDo6pyp2Xp4LZoQd4z0HM8XCY10I+Byn5PqWXKCQSoQJjh3mnNzc2fsCjdW5N2jSEAO4bxKmGoTIUnza0B9+tVyBrgLygumyqErjdvR7ic3ow==
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966005)(426003)(4326008)(70586007)(1076003)(83380400001)(336012)(186003)(44832011)(478600001)(81166007)(6266002)(42186006)(316002)(6862004)(47076004)(54906003)(82740400003)(36756003)(2616005)(8936002)(8676002)(356005)(70206006)(2906002)(86362001)(5660300002)(82310400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 15:45:10.7678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c10f0a3-0863-4631-fdfd-08d876a175aa
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4154
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit "mtd: cfi_cmdset_0002: Add support for polling status register"
added support for polling the status rather than using DQ polling.
However, status register is used only when DQ polling is missing.
Lets use status register when available as it is superior to DQ polling.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index a1f3e1031c3d..ee9b322e63bb 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -117,7 +117,7 @@ static struct mtd_chip_driver cfi_amdstd_chipdrv = {
 static int cfi_use_status_reg(struct cfi_private *cfi)
 {
 	struct cfi_pri_amdstd *extp = cfi->cmdset_priv;
-	u8 poll_mask = CFI_POLL_STATUS_REG | CFI_POLL_DQ;
+	u8 poll_mask = CFI_POLL_STATUS_REG;
 
 	return extp->MinorVersion >= '5' &&
 		(extp->SoftwareFeatures & poll_mask) == CFI_POLL_STATUS_REG;
-- 
2.26.2

