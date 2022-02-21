Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB84BDC5A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347044AbiBUJEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347878AbiBUJCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF829CB6;
        Mon, 21 Feb 2022 00:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14387B80EAA;
        Mon, 21 Feb 2022 08:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA16C340E9;
        Mon, 21 Feb 2022 08:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433830;
        bh=MEFTC5FcKMnjdyhYIKnb/Xreiz4e59Hn0kyWFSiiYoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJvIo0BcFEawudPapShFD7PuxlfD6GvYta3m9EYPxfHuzmcyCG57iqwnykTNc0pDf
         1Cui7Q9EUJx6ZYVw0AWoBPM4U8JvDvgvm7Cyn3LQ8jDX6z5zjtHIu2GNFYJAGTngi4
         JXt1DJ7Zl9klE5gXH9V7/M2jKCr0n6gWQu2hBbiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fianelil <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 25/58] net: dsa: lan9303: fix reset on probe
Date:   Mon, 21 Feb 2022 09:49:18 +0100
Message-Id: <20220221084912.693218858@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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
@@ -1307,7 +1307,7 @@ static int lan9303_probe_reset_gpio(stru
 				     struct device_node *np)
 {
 	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
-						   GPIOD_OUT_LOW);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(chip->reset_gpio))
 		return PTR_ERR(chip->reset_gpio);
 


