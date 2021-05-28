Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48904394503
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhE1P23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 11:28:29 -0400
Received: from mail-sn1anam02on2046.outbound.protection.outlook.com ([40.107.96.46]:11847
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232852AbhE1P23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 11:28:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XA+d+t41bSo6domvWve8NskEbjGUNDB30Nz6q7UQHAUvxiuhy/WxjOiVBecyeAmlxrW5lc29r2xnDAuqxcw675dxBA4eUSpnlmhCKtKrWnOpMdol8bMOfNorUTtCdqB2zH5dNTrzfMllz92Z6iyPqvqvXrKDEtAEKIH1beFAjtrVuxzQxAyYwMKnpi82dKES3pMZZWf0t9J3P1YWd1yeJqn6MAVhiyNzAOcF9SiOgmY5NdG32vDXhjwLzNtjlUyStgkjL0ihTNBOagH3BGM7ImL0YPxcB8LSA7z2I74RexLTlqAaX/z0fWHTdHVHIsD3f6bZissBh94AoyTkCuqBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWzT2jstEZKB+kmuuxLxEiDpyMPhuAkSE86/KL57T7g=;
 b=fJlbwDh9xA8cU6QjOdqtGRdJDbYIbM9SlDUr276x6iyfAmv6LFpHbU9BALyFi8YEevpIVNwgVhSqf0pJvxJy1tnIPnGeRAYbkOO1+FyLie0+uppp8gGK3bunHb0enK1p2hrVtQHioqBeGYxq5EdidaFss5I2bGfT3ImlfnuTG8pyIzPBRofi0R8Rxnt7U7m86Ae7J91seqkhgJwKDVCuTJYfBbtqfxqduw+0mF96YnwWGilzUHMxd1jcGJpDN/v2bfLRJzy9IqFW7ZGNJQuL0mrc4zWqRoS9SJr4PawXQCDTA6D61fU3dafXsxqwwFK+Vljyth0djoGMgqib18hXWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWzT2jstEZKB+kmuuxLxEiDpyMPhuAkSE86/KL57T7g=;
 b=ReQlyrmSX1IMEY+gCMR71vFdwUS/lLFVJ9lzEtxSWFLM9TCPn3lB6QBcMxex8YcuqysUvPa/GTe7t4/bxDR+nN4VgD6WH/af8WDWiagF6cVYFv5fnFspe3VEuQ/xOJQvHmXKStDNkjdGjA9ThmhxuEfWDDC7pTKbaegrM1z+Cj0=
Received: from BN6PR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:405:15::13) by BN8PR10MB3476.namprd10.prod.outlook.com
 (2603:10b6:408:ae::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 15:26:52 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::2) by BN6PR1701CA0003.outlook.office365.com
 (2603:10b6:405:15::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend
 Transport; Fri, 28 May 2021 15:26:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 15:26:52 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 08:26:51 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 08:26:51 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 28 May 2021 08:26:51 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 0F15C2A973D3;
        Fri, 28 May 2021 17:26:51 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 0D3D720003CA; Fri, 28 May 2021 17:26:51 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-bluetooth@vger.kernel.org>, <stable@vger.kernel.org>
CC:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Subject: [PATCH 2/2] Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device.
Date:   Fri, 28 May 2021 17:26:45 +0200
Message-ID: <20210528152645.25577-2-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
References: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2021 15:26:51.0934 (UTC) FILETIME=[E23A73E0:01D753D5]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 570eaa2a-ea6c-4c6a-0284-08d921ed053d
X-MS-TrafficTypeDiagnostic: BN8PR10MB3476:
X-Microsoft-Antispam-PRVS: <BN8PR10MB3476865B2B6E0466D79B1216F4229@BN8PR10MB3476.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:312;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kfb2qKf2iSB0uX9eND7p98ZSAdyZWYncrqXh0sZ/FRjywICnajuEFUONkA5POsoDsY/CZYFCGUBO9LnJdez8gZo2BRE7KBxIEKl2wsAdt6MxRCFubAmVqPjtLjIQ/WwvLe/78MRiNwxE0oFJMv76jPlAipsa3hLsqSlYV8oP8DcrZKatIjB/mkiueXFg3qCukcHpuRSahJDj3PFMPdxlWbtieUGlNMS4Pu+xjYs3guf4pJkclV0J/1464EJ8MCExIg+gcY+0jKN00eF6KvER68sKbclKW3Jngap71mZHsamj0m92nca/VrjELDPhBEKQ8Rtj31V2qcp1PLAq418yQ/P8kt4aIXY1hSH4SD7R+fzU/OtZWTBU4XnCRNaPFnnML9J3Op6hV6GR2EZB6I2UTG693x07OMq1vU64Tk7HNSJV+4LTin/XhGNkQaScVOcjstonKRvV5GwSAuwQ42G1W0g10uGZ2HUP88BiKHLLQjzmi5WPK/NrsFDRj6lZ3E3Nkp5pFfP6c7vmK2t7Iqyq0Cr0LDDa6AeKDOCll7reSCqU+TXLU35ILQObr8EXvLGysI2ixDmvSuyNMkb1h5EMg1vrIbDpaGIW2sbJ6hRbUFZtwSlspi9ZsbFbcY9nqAsdVeeqpcnGY54YG4z/yQcOe3AQKRMsRUJMMQNOGPCTp49/3xJDS2IDJh35yprfOXQH
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(346002)(396003)(36840700001)(46966006)(110136005)(36860700001)(2616005)(26005)(8676002)(478600001)(42186006)(82740400003)(107886003)(82310400003)(1076003)(5660300002)(186003)(8936002)(70586007)(36756003)(336012)(86362001)(4326008)(426003)(6266002)(6666004)(70206006)(356005)(44832011)(81166007)(36906005)(2906002)(47076005)(316002)(450100002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 15:26:52.6916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 570eaa2a-ea6c-4c6a-0284-08d921ed053d
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3476
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>

T:  Bus=01 Lev=01 Prnt=01 Port=08 Cnt=04 Dev#= 18 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0b05 ProdID=190e Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=ASUS USB-BT500
S:  SerialNumber=xxxxxxxx
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5d603ef39bad..628f4b22cf69 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -425,6 +425,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
+	/* Additional Realtek 8761BU Bluetooth devices */
+	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
+	  					     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
-- 
2.31.1

