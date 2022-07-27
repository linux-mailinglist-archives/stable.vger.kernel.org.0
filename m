Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B9158251D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 13:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiG0LFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 07:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 07:05:23 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC11B62DC;
        Wed, 27 Jul 2022 04:05:21 -0700 (PDT)
X-UUID: bf3bd924e80d4d0a88c6beabc9c47aee-20220727
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:c2ffb9cc-1000-4b1b-b495-16daaa3da22a,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:90
X-CID-INFO: VERSION:1.1.8,REQID:c2ffb9cc-1000-4b1b-b495-16daaa3da22a,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:90
X-CID-META: VersionHash:0f94e32,CLOUDID:c39af4cb-7c9b-4dbc-a9d4-00659d6b7a90,C
        OID:6b8dddc57071,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: bf3bd924e80d4d0a88c6beabc9c47aee-20220727
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 780585816; Wed, 27 Jul 2022 19:05:18 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 27 Jul 2022 19:05:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 27 Jul 2022 19:05:17 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles
Date:   Wed, 27 Jul 2022 19:05:03 +0800
Message-ID: <20220727110503.5260-1-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Sun <pablo.sun@mediatek.com>

From: Pablo Sun <pablo.sun@mediatek.com>

Fix incorrect pin assignment values when connecting to a monitor with
Type-C receptacle instead of a plug.

According to specification, an UFP_D receptacle's pin assignment
should came from the UFP_D pin assignments field (bit 23:16), while
an UFP_D plug's assignments are described in the DFP_D pin assignments
(bit 15:8) during Mode Discovery.

For example the LG 27 UL850-W is a monitor with Type-C receptacle.
The monitor responds to MODE DISCOVERY command with following
DisplayPort Capability flag:

        dp->alt->vdo=0x140045

The existing logic only take cares of UPF_D plug case,
and would take the bit 15:8 for this 0x140045 case.

This results in an non-existing pin assignment 0x0 in
dp_altmode_configure.

To fix this problem a new set of macros are introduced
to take plug/receptacle differences into consideration.

Co-developed-by: Pablo Sun <pablo.sun@mediatek.com>
Signed-off-by: Pablo Sun <pablo.sun@mediatek.com>
Co-developed-by: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Guillaume Ranquet <granquet@baylibre.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/typec/altmodes/displayport.c | 4 ++--
 include/linux/usb/typec_dp.h             | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 9360ca177c7d..8dd0e505ef99 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -98,8 +98,8 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
 	case DP_STATUS_CON_UFP_D:
 	case DP_STATUS_CON_BOTH: /* NOTE: First acting as DP source */
 		conf |= DP_CONF_UFP_U_AS_UFP_D;
-		pin_assign = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo) &
-			     DP_CAP_UFP_D_PIN_ASSIGN(dp->port->vdo);
+		pin_assign = DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo) &
+				 DP_CAP_PIN_ASSIGN_DFP_D(dp->port->vdo);
 		break;
 	default:
 		break;
diff --git a/include/linux/usb/typec_dp.h b/include/linux/usb/typec_dp.h
index cfb916cccd31..8d09c2f0a9b8 100644
--- a/include/linux/usb/typec_dp.h
+++ b/include/linux/usb/typec_dp.h
@@ -73,6 +73,11 @@ enum {
 #define DP_CAP_USB			BIT(7)
 #define DP_CAP_DFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(15, 8)) >> 8)
 #define DP_CAP_UFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(23, 16)) >> 16)
+/* Get pin assignment taking plug & receptacle into consideration */
+#define DP_CAP_PIN_ASSIGN_UFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
+			DP_CAP_UFP_D_PIN_ASSIGN(_cap_) : DP_CAP_DFP_D_PIN_ASSIGN(_cap_))
+#define DP_CAP_PIN_ASSIGN_DFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
+			DP_CAP_DFP_D_PIN_ASSIGN(_cap_) : DP_CAP_UFP_D_PIN_ASSIGN(_cap_))
 
 /* DisplayPort Status Update VDO bits */
 #define DP_STATUS_CONNECTION(_status_)	((_status_) & 3)
-- 
2.18.0

