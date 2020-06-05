Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD151EF5D2
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgFEKyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 06:54:32 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:6026
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726853AbgFEKyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 06:54:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bK8+NBgOwCcUDsBK0CtLLko0Z7hvSVzB0NPlo6N57TvgPho5PFVZ6cWpLUr8/CMl488Sgni54Z8sVdgrmNvOizJZ3bYCw0vy3znWBNWm3iqCXQofNBhZz1q+onp0863mCmta9rZqYrOKoZYRLT2KtUy4ME4kpDIXBvcit2AT483fFQOIJaS2O48rBMloJPQb/upWZZ8OshwNhcnMp/l1f6FuR1fKCqrkkUwGBG2zl75e8Yih88XMj3SJDUDtG28pRPPxbTNYeW1fMPoDhOvyP3hnEc83KV8rEMwATRz46Fz3W8tphUSjHIu74mxeqvOL515fo5h/QdrqvNGLvJAsjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ro910B0BwxAQ6kA98pvyav8dKTYUiznbFA2lbC3lbU=;
 b=kRzSngmtqyqzcraRvSCfpJg28LTtIP+LaL2lyM4akAKm3GonHwO2DplzK3Cg8Q1gE1UGI3mmGHHohiPq6X9XYhlO+IjKDkiFw9EuHpU+sK950RXd4hXIY3FKNwtwTISCfj8E19rSKTXT1+E0xu2fUkUqajiRnelnJl0MNMj9TnNrshPd/mrVg6oadcdXJlqDZ6gyGX1iG/SFe1fNsY6WZFQVa6n2BHkES28omvoMWAD2tuX/CKz++QUEqyIM3GTrbW+00guAHZpLFSvOtucfz9yvomnhXenAE2nVofkmodZ2GIv5pL9A9paLSkyRZ425kvozm4bLgTtuVs4YsePVdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ro910B0BwxAQ6kA98pvyav8dKTYUiznbFA2lbC3lbU=;
 b=jRui6CHWRKb8CPrxFAJ4y1P2OQL1y3L6xH1++gQTSMc1hkZHvojD87Y6Qt9N2ODT3lwikyH5HY61XDugWjhhccFSQpRHi82rlAfUVp5uQLav0TMIuyNCJTvgCLVQeSzYRyADNfsWDyCMA59Xi/swfxoMDZNcnWuopX68O1m7Wrw=
Received: from DM5PR19CA0019.namprd19.prod.outlook.com (2603:10b6:3:151::29)
 by DM5PR1001MB2314.namprd10.prod.outlook.com (2603:10b6:4:2f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Fri, 5 Jun
 2020 10:54:28 +0000
Received: from DM3NAM03FT033.eop-NAM03.prod.protection.outlook.com
 (2603:10b6:3:151:cafe::37) by DM5PR19CA0019.outlook.office365.com
 (2603:10b6:3:151::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend
 Transport; Fri, 5 Jun 2020 10:54:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 DM3NAM03FT033.mail.protection.outlook.com (10.152.82.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3066.18 via Frontend Transport; Fri, 5 Jun 2020 10:54:28 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 5 Jun 2020 03:54:27 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.1847.3 via Frontend Transport; Fri, 5 Jun 2020 03:54:27 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 5 Jun 2020 03:54:26 -0700
Received: from gentoo-jocke.infinera.com (unknown [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id AA07D2C06CBD;
        Fri,  5 Jun 2020 12:54:26 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id A37AC83AD; Fri,  5 Jun 2020 12:54:26 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-usb@vger.kernel.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip
Date:   Fri, 5 Jun 2020 12:54:18 +0200
Message-ID: <20200605105418.22263-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jun 2020 10:54:27.0403 (UTC) FILETIME=[AEA831B0:01D63B27]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966005)(336012)(86362001)(26005)(83380400001)(426003)(6916009)(47076004)(6266002)(4744005)(5660300002)(1076003)(54906003)(82740400003)(81166007)(36756003)(70586007)(356005)(478600001)(2906002)(6666004)(186003)(4326008)(316002)(42186006)(70206006)(36906005)(8936002)(44832011)(82310400002)(2616005)(450100002)(8676002);DIR:OUT;SFP:1101;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bcb1975-ffb3-4848-7117-08d8093ed1b7
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2314:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB231450CB5B4349F25121D896F4860@DM5PR1001MB2314.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:381;
X-Forefront-PRVS: 0425A67DEF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5YuQQtfIEBQWJKR3dm+NDUFffcN4TCGCIwMnEIVv4SGVpp0HaDTvWThbNe1vw28hnSLfnxToB96tS+8+iFkEQ/2JmVY1X1oXsRcBROGxJFt+t1jRIqMbno9Ki9HhFmUlpnBXi996FspMU0uc0Usa3AMtxpcoSsKfx5SrrlCMGU9VlvNteyo2T85WRKTGrV9PimOviUrSlJ4KEjecjA7EBqasA2EJb7He3AVSO/HvW2Ilh0nua0b0u8oRz8e3Rc8nEGq4l7mjh37Q/mFsMzEdztR7fPMHjwqnIHaWxfILNH5PlDqcbRiIdzc8ErhZd9GmWkjup+AxmhIpRVe8Yxy/nfhLaoNhqCGXUpLDSMbd1COLSM1trMKyeJXISu1L0pz2LIJ+HwK76Oo56g651B8Jw==
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2020 10:54:28.2935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bcb1975-ffb3-4848-7117-08d8093ed1b7
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2314
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB_DEVICE(0x0424, 0x274e) can send data before cdc_acm is ready,
causing garbage chars on the TTY causing stray input to the shell
and/or login prompt.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/class/cdc-acm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ded8d93834ca..d579b05a2c2b 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1689,6 +1689,8 @@ static int acm_pre_reset(struct usb_interface *intf)
 
 static const struct usb_device_id acm_ids[] = {
 	/* quirky and broken devices */
+	{ USB_DEVICE(0x0424, 0x274e), /* Microchip Technology, Inc. (formerly SMSC) */
+	  .driver_info = DISABLE_ECHO, }, /* DISABLE ECHO in termios flag */
 	{ USB_DEVICE(0x076d, 0x0006), /* Denso Cradle CU-321 */
 	.driver_info = NO_UNION_NORMAL, },/* has no union descriptor */
 	{ USB_DEVICE(0x17ef, 0x7000), /* Lenovo USB modem */
-- 
2.26.2

