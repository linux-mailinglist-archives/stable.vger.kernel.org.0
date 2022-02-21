Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44174BE808
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352217AbiBUJyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:54:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352224AbiBUJxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:53:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FE936B66;
        Mon, 21 Feb 2022 01:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB257B80EB9;
        Mon, 21 Feb 2022 09:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CAFC340E9;
        Mon, 21 Feb 2022 09:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435403;
        bh=nkcQxGdJDoVl8oaSFTYORMJhIKjObWqU0wdGclgp29w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qd0pUMEN1CsKnN5Bs/2JqM1MZZ6q9t8K8g1C/0zGpTlpc+nejwTkpvUvQ3eH+6wPr
         kVLEi6OQTazEToATz2dqnyajz5CHbSlFKrgHG0wXtJsRwJFL3gn1E3WVFegY7sfXb5
         zUFikcRsuyNWgP7+7nS7mO92ONZhJZDMYYzLjUJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fianelil <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 109/227] net: dsa: lan9303: fix reset on probe
Date:   Mon, 21 Feb 2022 09:48:48 +0100
Message-Id: <20220221084938.489786570@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

commit 6bb9681a43f34f2cab4aad6e2a02da4ce54d13c5 upstream.

The reset input to the LAN9303 chip is active low, and devicetree
gpio handles reflect this.  Therefore, the gpio should be requested
with an initial state of high in order for the reset signal to be
asserted.  Other uses of the gpio already use the correct polarity.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fianelil <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220209145454.19749-1-mans@mansr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lan9303-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1309,7 +1309,7 @@ static int lan9303_probe_reset_gpio(stru
 				     struct device_node *np)
 {
 	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
-						   GPIOD_OUT_LOW);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(chip->reset_gpio))
 		return PTR_ERR(chip->reset_gpio);
 


