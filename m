Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E3528F9B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiEPUEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351047AbiEPUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8347F473AF;
        Mon, 16 May 2022 12:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 386F1B81611;
        Mon, 16 May 2022 19:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D9BC385AA;
        Mon, 16 May 2022 19:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731039;
        bh=nHCPrEtDuSjJ96w8i2Zd8GckMSt702jjQBW4XUFJnXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyA9+4/BjTzCswFdnWJM32W9ncjD7V0tOX9gZM9XAsK5cSBBVNRj/ymciflIHpI+f
         O3Mps53ymQHjBKRjJ40rTqeSnEcqKxBDIfqzwyUga72kEeL3EOiyDwmxNMBfche99l
         kKz//I47+/uyGtx/gQ0hWS8wnDbfg1VjM2qi30ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Macpaul Lin <macpaul.lin@mediatek.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Fabien Parent <fparent@baylibre.com>
Subject: [PATCH 5.17 082/114] usb: typec: tcpci_mt6360: Update for BMC PHY setting
Date:   Mon, 16 May 2022 21:36:56 +0200
Message-Id: <20220516193627.838870506@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

commit 4031cd95cba70c72e4cadc2d46624bcd31e5a6c0 upstream.

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
 drivers/usb/typec/tcpm/tcpci_mt6360.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

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
 
@@ -106,6 +111,27 @@ static int mt6360_tcpc_init(struct tcpci
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


