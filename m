Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4D56FB50
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiGKJ2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiGKJ2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:28:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A22166AF1;
        Mon, 11 Jul 2022 02:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C600FCE1260;
        Mon, 11 Jul 2022 09:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75CDC34115;
        Mon, 11 Jul 2022 09:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530952;
        bh=/sbOSX3Pnsxhpi+1YjZXiP7EM8K6cK3NsOE1FwYeRFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaxrDC+BrL36d47/jbDs+ajZ3SSgeCtpAxmOsv5D/XVui+7Yow35ffNB9wcrb2fYm
         6ovIl5UIcleIAnBs703pFpZ8Dd6RiwFbHDoHvXzvbnfBag5nnTNRFpaon6nJVzl+mF
         vdYQJS/zXee0m5uZP8Cy2vx+3SAJVK1FXBZ++yPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 044/112] net: dsa: qca8k: reset cpu port on MTU change
Date:   Mon, 11 Jul 2022 11:06:44 +0200
Message-Id: <20220711090550.823175937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca8k.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2372,7 +2372,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
+	int ret, i, mtu = 0;
 
 	priv->port_mtu[port] = new_mtu;
 
@@ -2380,8 +2380,27 @@ qca8k_port_change_mtu(struct dsa_switch
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


