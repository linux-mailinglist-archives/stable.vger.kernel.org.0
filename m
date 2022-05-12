Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4365252A6
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 18:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbiELQeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 12:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356300AbiELQeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 12:34:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BDF2044C1
        for <stable@vger.kernel.org>; Thu, 12 May 2022 09:34:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B9AEB829EF
        for <stable@vger.kernel.org>; Thu, 12 May 2022 16:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1AAC34100;
        Thu, 12 May 2022 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652373280;
        bh=XqU6k0aWWhXk8gWGSLFsPcveNUCWjSXiKOarW1NSXsg=;
        h=Subject:To:From:Date:From;
        b=CbdgMEfWaoxFDlFyn1f0+WXdWhrbxFO6N6p7LkYZb07XoIhCGe5mBUxmUWPeae+mC
         hXhMFKddVhsk/nRHfLTdKacubw8ncYJ0m6FNGEVkCaWFfk9aXLfU94NG9R+azCcVLO
         1Y8s6wpj+kcfvUg5WdR5ZvC48OBDkZ6qFQ4bnvz0=
Subject: patch "usb: typec: tcpci_mt6360: Update for BMC PHY setting" added to usb-linus
To:     cy_huang@richtek.com, fparent@baylibre.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        linux@roeck-us.net, macpaul.lin@mediatek.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 May 2022 18:34:37 +0200
Message-ID: <1652373277464@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpci_mt6360: Update for BMC PHY setting

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 191e3b73f7ff5f3e6262e15477b68a0876ad63fa Mon Sep 17 00:00:00 2001
From: ChiYuan Huang <cy_huang@richtek.com>
Date: Tue, 10 May 2022 13:13:00 +0800
Subject: usb: typec: tcpci_mt6360: Update for BMC PHY setting

Update MT6360 BMC PHY Tx/Rx setting for the compatibility.

Macpaul reported this CtoDP cable attention message cannot be received from
MT6360 TCPC. But actually, attention message really sent from UFP_D
device.

After RD's comment, there may be BMC PHY Tx/Rx setting causes this issue.

Below's the detailed TCPM log and DP attention message didn't received from 6360
TCPCI.
[ 1206.367775] Identity: 0000:0000.0000
[ 1206.416570] Alternate mode 0: SVID 0xff01, VDO 1: 0x00000405
[ 1206.447378] AMS DFP_TO_UFP_ENTER_MODE start
[ 1206.447383] PD TX, header: 0x1d6f
[ 1206.449393] PD TX complete, status: 0
[ 1206.454110] PD RX, header: 0x184f [1]
[ 1206.456867] Rx VDM cmd 0xff018144 type 1 cmd 4 len 1
[ 1206.456872] AMS DFP_TO_UFP_ENTER_MODE finished
[ 1206.456873] cc:=4
[ 1206.473100] AMS STRUCTURED_VDMS start
[ 1206.473103] PD TX, header: 0x2f6f
[ 1206.475397] PD TX complete, status: 0
[ 1206.480442] PD RX, header: 0x2a4f [1]
[ 1206.483145] Rx VDM cmd 0xff018150 type 1 cmd 16 len 2
[ 1206.483150] AMS STRUCTURED_VDMS finished
[ 1206.483151] cc:=4
[ 1206.505643] AMS STRUCTURED_VDMS start
[ 1206.505646] PD TX, header: 0x216f
[ 1206.507933] PD TX complete, status: 0
[ 1206.512664] PD RX, header: 0x1c4f [1]
[ 1206.515456] Rx VDM cmd 0xff018151 type 1 cmd 17 len 1
[ 1206.515460] AMS STRUCTURED_VDMS finished
[ 1206.515461] cc:=4

Fixes: e1aefcdd394fd ("usb typec: mt6360: Add support for mt6360 Type-C driver")
Cc: stable <stable@vger.kernel.org>
Reported-by: Macpaul Lin <macpaul.lin@mediatek.com>
Tested-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Link: https://lore.kernel.org/r/1652159580-30959-1-git-send-email-u0084500@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_mt6360.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpci_mt6360.c b/drivers/usb/typec/tcpm/tcpci_mt6360.c
index f1bd9e09bc87..8a952eaf9016 100644
--- a/drivers/usb/typec/tcpm/tcpci_mt6360.c
+++ b/drivers/usb/typec/tcpm/tcpci_mt6360.c
@@ -15,6 +15,9 @@
 
 #include "tcpci.h"
 
+#define MT6360_REG_PHYCTRL1	0x80
+#define MT6360_REG_PHYCTRL3	0x82
+#define MT6360_REG_PHYCTRL7	0x86
 #define MT6360_REG_VCONNCTRL1	0x8C
 #define MT6360_REG_MODECTRL2	0x8F
 #define MT6360_REG_SWRESET	0xA0
@@ -22,6 +25,8 @@
 #define MT6360_REG_DRPCTRL1	0xA2
 #define MT6360_REG_DRPCTRL2	0xA3
 #define MT6360_REG_I2CTORST	0xBF
+#define MT6360_REG_PHYCTRL11	0xCA
+#define MT6360_REG_RXCTRL1	0xCE
 #define MT6360_REG_RXCTRL2	0xCF
 #define MT6360_REG_CTDCTRL2	0xEC
 
@@ -106,6 +111,27 @@ static int mt6360_tcpc_init(struct tcpci *tcpci, struct tcpci_data *tdata)
 	if (ret)
 		return ret;
 
+	/* BMC PHY */
+	ret = mt6360_tcpc_write16(regmap, MT6360_REG_PHYCTRL1, 0x3A70);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, MT6360_REG_PHYCTRL3,  0x82);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, MT6360_REG_PHYCTRL7, 0x36);
+	if (ret)
+		return ret;
+
+	ret = mt6360_tcpc_write16(regmap, MT6360_REG_PHYCTRL11, 0x3C60);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, MT6360_REG_RXCTRL1, 0xE8);
+	if (ret)
+		return ret;
+
 	/* Set shipping mode off, AUTOIDLE on */
 	return regmap_write(regmap, MT6360_REG_MODECTRL2, 0x7A);
 }
-- 
2.36.1


