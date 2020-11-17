Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76722B5F16
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgKQM2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:28:16 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:9568
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728085AbgKQM2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:28:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjHGJFTUyI+uR5lU4mCPaLxTYbSRxmURFQHVTJ94Ss18jZZGbnAaDpO6wMa4nqlSllEkJzcXdxTiL0nbf+uX9b3LP6M9TknnAU18g1xMYhuLLDW2JWmcntFfpA4pIAxTC8o1B2UbEkMu7YDSAYGDMJc1WY/WlAoRl5NErLDO1Ce0BsyfOnB0mX5agtQ6HpFrH/R+3sbkzYG4sYi4TjnolosqE8v9t2iXxT3tANr86Gmk+O9BpBf5WE0spsvQ9ymWmicKYlpVEvkWfHVX5U/NJFcIzbFlyFZBMxDnAnWiDCbEI/Zfy7Gx+SkcHw1mHrubYZRhPu9sYMYCHzHzENhMAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS1Hpqdt/AZ/tDODWOjpu8hfGMwmTShq5Kb6i5jz5+0=;
 b=furu3LrSNR/lbsrmE7TJNnh7nC69xo13d1Q7zHpUXkMyE/Sr7oxWkSDkTQclXcSCT1pfx0WH1zmNTeevWeRMP8yR2bmPLmgvlGC9fil0RXlQGMO8hfP84BnUl1oCGVzJ2FJ1ba4VwYqtDC9YaAS0ONQ+rfQQgMCnpDJp4ozGnHnHZ71hPJBxHBRdVBgvRRe5/YwWSv5sDE+Yb40SdsyIABqGcY9sNqzcCo2jC4UjUOp4Lw53EZ+Jt8BoWqh/kiuhQDOjWjk65+wB65ufCljwTqn8yJLi9J9MVXk5Q9mB9K4ipxZ62Up8+MC9OgzKifnAQvfNP80zA6IUUj13r7yA6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS1Hpqdt/AZ/tDODWOjpu8hfGMwmTShq5Kb6i5jz5+0=;
 b=QDxbZb88a/bZHzRK7FpHxb5npl2bycHfuDPSLSVN4OvLtKadkPec73nhW2IqK9dv87tDneR6/I6BsMDTdMJibra5JlAEr1QYFnjhuzqD53QAUGZorUwCt5+VEQUE7qRV66isqV39dPiSqBikdrlwiGzktcc2NlLCbkrOAEEO+Zo=
Received: from DM5PR04CA0067.namprd04.prod.outlook.com (2603:10b6:3:ef::29) by
 BY5PR10MB4226.namprd10.prod.outlook.com (2603:10b6:a03:210::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Tue, 17 Nov
 2020 12:28:11 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::cb) by DM5PR04CA0067.outlook.office365.com
 (2603:10b6:3:ef::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend
 Transport; Tue, 17 Nov 2020 12:28:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 12:28:10 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Nov 2020 04:28:07 -0800
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.1847.3 via Frontend Transport; Tue, 17 Nov 2020 04:28:07 -0800
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Tue, 17 Nov 2020 04:28:07 -0800
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 8B1392C03201;
        Tue, 17 Nov 2020 13:28:06 +0100 (CET)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 7C17CC538; Tue, 17 Nov 2020 13:28:06 +0100 (CET)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     Jaroslav Kysela <perex@perex.cz>, <linux-usb@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB devices
Date:   Tue, 17 Nov 2020 13:28:03 +0100
Message-ID: <20201117122803.24310-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Nov 2020 12:28:07.0507 (UTC) FILETIME=[1AA8C230:01D6BCDD]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5291f1c9-5d4d-4f20-f5f6-08d88af43f48
X-MS-TrafficTypeDiagnostic: BY5PR10MB4226:
X-Microsoft-Antispam-PRVS: <BY5PR10MB42262A60D1901CE53E897758F4E20@BY5PR10MB4226.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iPTAsFU7tX5tHKC0XlsJYtdkRSpuzHLB+irPQkC1cq3CXApIgZ+9gOVXj1eGgUY7xMYTafshrh/2oWnIujYhjKdRFrkqFDdxrTcHKS6KVo1/jVmZHUpbZx4DpfaArQ7A4QvDOCyzfphGc172ZnduBUK5uE1xTwWOHpRE0vX85nnMgng5o2LlUqG/ElIUhWuFx+i+slYDDhymHx3FZsCTSyN7MEEO1K3OdKQZDx22iVjXkFn/WQYa9wMja8m4n+sqk3MN6ekHkjoOesCJJ2axD1LQb9/VjHYWVlxDyOZ4Z0net6rG2LrT194KzOet2IhQGVdiV8xYnoylWBPDreLT1lxyGopevpY3UbL2u/CegrTzcU5dzsNbowGVR3h0YLa/y8Vp+Z9pFUYe/siL2I9dCQ==
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(46966005)(26005)(36756003)(4326008)(82740400003)(110136005)(54906003)(478600001)(83380400001)(47076004)(316002)(8936002)(42186006)(356005)(450100002)(5660300002)(426003)(44832011)(36906005)(2616005)(6266002)(336012)(81166007)(86362001)(70206006)(70586007)(8676002)(82310400003)(1076003)(6666004)(186003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 12:28:10.9465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5291f1c9-5d4d-4f20-f5f6-08d88af43f48
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4226
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Found one more Logitech device, BCC950 ConferenceCam, which needs
the same delay here. This makes 3 out of 3 devices I have tried.

Therefore, add a delay for all Logitech devices as it does not hurt.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
CC: stable@vger.kernel.org (4.19, 5.4)

---
 sound/usb/quirks.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c989ad8052ae..c50be2f75f70 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1672,13 +1672,13 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
-	/* Zoom R16/24, Logitech H650e/H570e, Jabra 550a, Kingston HyperX
-	 *  needs a tiny delay here, otherwise requests like get/set
-	 *  frequency return as failed despite actually succeeding.
+	/* Zoom R16/24, many Logitech(at least H650e/H570e/BCC950),
+	 * Jabra 550a, Kingston HyperX needs a tiny delay here,
+	 * otherwise requests like get/set frequency return
+	 * as failed despite actually succeeding.
 	 */
 	if ((chip->usb_id == USB_ID(0x1686, 0x00dd) ||
-	     chip->usb_id == USB_ID(0x046d, 0x0a46) ||
-	     chip->usb_id == USB_ID(0x046d, 0x0a56) ||
+	     USB_ID_VENDOR(chip->usb_id) == 0x046d  || /* Logitech */
 	     chip->usb_id == USB_ID(0x0b0e, 0x0349) ||
 	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
-- 
2.26.2

