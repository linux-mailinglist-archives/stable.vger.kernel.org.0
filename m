Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA193EA567
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 15:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbhHLNW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 09:22:27 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:49702 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237346AbhHLNTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 09:19:09 -0400
X-UUID: 4ba14b39419b40f4a982dff6b7b928f4-20210812
X-UUID: 4ba14b39419b40f4a982dff6b7b928f4-20210812
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 223306628; Thu, 12 Aug 2021 21:18:38 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 12 Aug 2021 21:18:37 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 12 Aug 2021 21:18:35 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>
CC:     Pawel Laszczak <pawell@cadence.com>,
        Al Cooper <alcooperx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 1/7] usb: mtu3: restore HS function when set SS/SSP
Date:   Thu, 12 Aug 2021 21:17:57 +0800
Message-ID: <1628774283-475-1-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Due to HS function is disabled when set as FS, need restore
it when set as SS/SSP.

Fixes: dc4c1aa7eae9 ("usb: mtu3: add ->udc_set_speed()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
v2: no changes
---
 drivers/usb/mtu3/mtu3_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index 562f4357831e..6403f01947b2 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -227,11 +227,13 @@ static void mtu3_set_speed(struct mtu3 *mtu, enum usb_device_speed speed)
 		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
 		break;
 	case USB_SPEED_SUPER:
+		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
 		mtu3_clrbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
 			     SSUSB_U3_PORT_SSP_SPEED);
 		break;
 	case USB_SPEED_SUPER_PLUS:
-			mtu3_setbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
+		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
+		mtu3_setbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
 			     SSUSB_U3_PORT_SSP_SPEED);
 		break;
 	default:
-- 
2.18.0

