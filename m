Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7784C7520
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbiB1Rvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbiB1RvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:51:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED9A8F639;
        Mon, 28 Feb 2022 09:39:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07237CE17CB;
        Mon, 28 Feb 2022 17:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296DEC340F4;
        Mon, 28 Feb 2022 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069951;
        bh=x3Ks4l3oF8qlXekP7bV+zF2mkX7O9rC2XCw9cam+juA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePZ7Gyi1vTg0a0aK5WO/5fPR4QWc/UT6FVzPMzXRO4h7Jhc3HpVbtluiA2YuJVyKX
         m/ra5/frP1uZG8Ubr54vz9aAnB7pGSmkab33XtY2fwk1Py5Uk1aSOELjN5dm5S9HSx
         2tWSgYm1JndmnRNXDzYqOJRxu9OZCTo6kYGGBRNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch.siach@siklu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 071/139] net: mdio-ipq4019: add delay after clock enable
Date:   Mon, 28 Feb 2022 18:24:05 +0100
Message-Id: <20220228172355.210584515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

commit b6ad6261d27708567b309fdb3102b12c42a070cc upstream.

Experimentation shows that PHY detect might fail when the code attempts
MDIO bus read immediately after clock enable. Add delay to stabilize the
clock before bus access.

PHY detect failure started to show after commit 7590fc6f80ac ("net:
mdio: Demote probed message to debug print") that removed coincidental
delay between clock enable and bus access.

10ms is meant to match the time it take to send the probed message over
UART at 115200 bps. This might be a far overshoot.

Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mdio/mdio-ipq4019.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -200,7 +200,11 @@ static int ipq_mdio_reset(struct mii_bus
 	if (ret)
 		return ret;
 
-	return clk_prepare_enable(priv->mdio_clk);
+	ret = clk_prepare_enable(priv->mdio_clk);
+	if (ret == 0)
+		mdelay(10);
+
+	return ret;
 }
 
 static int ipq4019_mdio_probe(struct platform_device *pdev)


