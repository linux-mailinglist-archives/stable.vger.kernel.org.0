Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A57520D27
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 07:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiEJFRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 01:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiEJFRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 01:17:05 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FCA2A83F8;
        Mon,  9 May 2022 22:13:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so1110855pju.2;
        Mon, 09 May 2022 22:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=KtIfa3pXmMCsw1ndxle9kWD29wJ61e87LoCR/dA6Zjw=;
        b=kZW03ctlltheN0OFN/VkaKZZjiRbkxHbA+M5QOhanQ8yuV5j8bdMzH1H0QKexpeosq
         g2DJXM9XZWLIdStomhoFvXgczz9PmpOWcFTpIDgO3CVLxu+0CBUPBh2gvfwLx04EyRBr
         UekTXgxA383iF17n3gPiGDYihgfi1F+5yJxxPdFQ2N+KuSpnRa7U/Ifc+THA2FIK1cyG
         Rfl5i79ThLIs0mA6P7QCdD3ea8WATGPe4cqoFEyQ9LlP5ZR36bFTIJIGsZAGkDtiXm6h
         T7AbJR+ETbrhHUZX5yt/cVSUz+f5UnINlxLLBHg/HGqRNBZ7Xyrf4PiOewtal4Gc4Wpc
         HdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KtIfa3pXmMCsw1ndxle9kWD29wJ61e87LoCR/dA6Zjw=;
        b=tt/2b9qfKihD8+2LISukg/weihSP4ExfMmuH/zViEycssjWZ1LOAfgbem4D1oRDXmI
         FGY1WrbFQ7rK0oUivyHrwPwzlltr9YbAtmVQADfJQBfDembk//3XqXO5YEyrrpLAnK/4
         xVfzaWy9gdmZYNtiBXaIhsSc/mJMNXQygLpnvP64I/9jMgGNgFQ0Pf2owmXQ4MscozwX
         wA+qSgLQFE+m8io4jx1vjRXqNrCss8iU0lnmWl/l2rpVCq6gCf+ySwhEWyZqIeTtxmta
         4DWnJNFSH40cfsCS8C10c/0ga03Bq3IgsS9XpBpw5jrCAldTYT4mS7JOaNd1N4ygb1Bi
         GoEA==
X-Gm-Message-State: AOAM531CjH9iSZOPWDc2LkAXlofiHNYn6uquuW5veBu3MaBo95MaW6DR
        Un5cW6o0c8RH/FkYQHcpSrk=
X-Google-Smtp-Source: ABdhPJzcRUiMEzDnGQApgkNDSwOqgx5S/RaxVfDYfmLnMKr+k+v2y5OZWM0Ycjcy40ZkESNiAe0Umg==
X-Received: by 2002:a17:90b:4d12:b0:1dc:741f:c6af with SMTP id mw18-20020a17090b4d1200b001dc741fc6afmr28760672pjb.91.1652159588742;
        Mon, 09 May 2022 22:13:08 -0700 (PDT)
Received: from localhost.localdomain ([2402:7500:477:5568:d4ca:c13b:4cc5:5a2f])
        by smtp.gmail.com with ESMTPSA id a4-20020a17090aa50400b001cd4989feecsm687649pjq.56.2022.05.09.22.13.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 May 2022 22:13:08 -0700 (PDT)
From:   cy_huang <u0084500@gmail.com>
To:     linux@roeck-us.net, heikki.krogerus@linux.intel.com,
        gregkh@linuxfoundation.org, matthias.bgg@gmail.com
Cc:     cy_huang@richtek.com, bryan_huang@richtek.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2] usb: typec: tcpci_mt6360: Update for BMC PHY setting
Date:   Tue, 10 May 2022 13:13:00 +0800
Message-Id: <1652159580-30959-1-git-send-email-u0084500@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

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
Reported-by: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_mt6360.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpci_mt6360.c b/drivers/usb/typec/tcpm/tcpci_mt6360.c
index f1bd9e0..8a952ea 100644
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
2.7.4

