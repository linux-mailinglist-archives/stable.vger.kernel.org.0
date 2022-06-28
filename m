Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8F55E6A7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346441AbiF1OjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 10:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346535AbiF1OjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 10:39:08 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E882A268
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 07:39:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d2so14482723ejy.1
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 07:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OJYIiYum3/XOuG7sgsJmU+mV2BxwbF/UGdk1oXFmoHQ=;
        b=QO2Sis3vkYn5Nhq5Yi9gjKY/K+ldiloBsX2+GaOUQTMkieIcte17h/2drpHec3JFC8
         zzcAK9dqCt1kk/DMr0A6yF4AQRyaW0wuo+xHwvDutKNtjgii8iSwQKYJEurQchgpbxRm
         FxLTJB+u4vtPea4fm9K5SScmhcAqD8cxvx+kcgmT5SAZL3rRiMmsHRX2CwBQ/UY2ExKE
         o/OCIvMsWfR/NqjyNrSxxBxEKsJogK5PJyHAW6Mb68Z0otyfpJoW8CjnqIkW2zmtMD+1
         HO92EX3p/ZrqBud78O3Lq/T4KRU/ouklPS9pxzbTEiUNsUUtSsSMavksIKx/6ymiXEPB
         kL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OJYIiYum3/XOuG7sgsJmU+mV2BxwbF/UGdk1oXFmoHQ=;
        b=Vs03Uwf/7/4WIwyJjl89o97qC9IukrhV39BjzKQ60TfNiCfuYwrR5og3prZPAOzZm+
         ivErqVAM7axrSXTc9YvInySd9Sljl305HpFbzm1+qD3tdInaiZr0GMAE4CfdcAmkvrMW
         N1XQBUkLir1PAbc17n+t9mHKXatenz3UgmwE1+G+523F9yzx6+X9ic5Qmxa6X5lr2NVZ
         dNv0ItfMxYj0gG/rOWIDai2zWTRC4JbPnepwRboArgCN+UaF3sHDsXpMJ52DeZL/pqzS
         JCdBULuL9gAkpiBbnGdMeRFaUqzZK5xU3iX58WwYx5bGqHeel88zf3fxr5PV8HmiE6GD
         wMUA==
X-Gm-Message-State: AJIora+0ImiqWLZRKSKWZqjaBc5rdfkqPjj7X4JCqBPalrsV+LVMIeU1
        zSZRJNENlPcS+Dvk1obnlpwyEjWUXSk=
X-Google-Smtp-Source: AGRyM1toK1STr0qZPC3SI5/4H8qfaQ+fwsEFa7fyp9AtouDdS8s0pzX5fK0T0PbaE6EsOulWwMO8dA==
X-Received: by 2002:a17:907:8a22:b0:722:e7cf:2665 with SMTP id sc34-20020a1709078a2200b00722e7cf2665mr18250598ejc.622.1656427145617;
        Tue, 28 Jun 2022 07:39:05 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id l4-20020aa7d944000000b00435b4775d94sm9728838eds.73.2022.06.28.07.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 07:39:05 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     stable@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: dsa: qca8k: reset cpu port on MTU change
Date:   Tue, 28 Jun 2022 16:30:10 +0200
Message-Id: <20220628143010.17526-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 386228c694bf1e7a7688e44412cb33500b0ac585 upstream.

It was discovered that the Documentation lacks of a fundamental detail
on how to correctly change the MAX_FRAME_SIZE of the switch.

In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
switch panics and cease to send any packet. This cause the mgmt ethernet
system to not receive any packet (the slow fallback still works) and
makes the device not reachable. To recover from this a switch reset is
required.

To correctly handle this, turn off the cpu ports before changing the
MAX_FRAME_SIZE and turn on again after the value is applied.

Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/20220621151122.10220-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ backport: fix conflict using the old port_sts struct instead of bitmap ]
---
 drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a984f06f6f04..67869c8cbeaa 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1599,7 +1599,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
+	int ret, i, mtu = 0;
 
 	priv->port_mtu[port] = new_mtu;
 
@@ -1607,8 +1607,27 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		if (priv->port_mtu[i] > mtu)
 			mtu = priv->port_mtu[i];
 
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_sts[0].enabled)
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_sts[6].enabled)
+		qca8k_port_set_status(priv, 6, 0);
+
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_sts[0].enabled)
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_sts[6].enabled)
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
 }
 
 static int
-- 
2.36.1

