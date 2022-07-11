Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B756056FD9C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiGKJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiGKJ50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:57:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5467FB4BF8;
        Mon, 11 Jul 2022 02:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98159B80E93;
        Mon, 11 Jul 2022 09:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D78C341C0;
        Mon, 11 Jul 2022 09:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531612;
        bh=YqtQP35jXWYBrQLN/cToll7pQXBag6WgH9ZCEqVLZqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDcPASoI4017RjWKxApzpGY3hszY4O4+P8FioF3BeXNI0FhfYbUkMxXDI3ZUACiHM
         UwUegjZly1P9Hat7yhFFu/AzrfxWez9JLC+hwpTWSYedgRCf+oI8RDIOCPWVH6vMN2
         l097QVscXcCwDwN3s/SVfoxtBSoDsf8ZcuzE/+Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 167/230] net: dsa: qca8k: reset cpu port on MTU change
Date:   Mon, 11 Jul 2022 11:07:03 +0200
Message-Id: <20220711090608.797548765@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
@@ -1599,7 +1599,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
+	int ret, i, mtu = 0;
 
 	priv->port_mtu[port] = new_mtu;
 
@@ -1607,8 +1607,27 @@ qca8k_port_change_mtu(struct dsa_switch
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


