Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927CB64A273
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiLLNyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiLLNyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:54:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81481CC7
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE9BFCE0F42
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53667C433D2;
        Mon, 12 Dec 2022 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853245;
        bh=yC9GFXn/MWfoAyTdcSdcdiuiQJoUBVaPqUb3tQmBfU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYxv1L80iMsXhdMKmNNmYG5pP37/lawOnQOcPH6Gx3ojUWWYbypdKepIutT1ROgUN
         AYtHtI8yeFbgox2KqugmUh3z2pN7HJujRASgW1+uvrawzwoElS+FaJC+SfbV9hANtj
         4vihaqYP2B3VaYK5YdJJmwzbrC1PA0lU26cdSC/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Valentina Goncharenko <goncharenko.vp@ispras.ru>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/38] net: encx24j600: Add parentheses to fix precedence
Date:   Mon, 12 Dec 2022 14:19:27 +0100
Message-Id: <20221212130913.406373115@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentina Goncharenko <goncharenko.vp@ispras.ru>

[ Upstream commit 167b3f2dcc62c271f3555b33df17e361bb1fa0ee ]

In functions regmap_encx24j600_phy_reg_read() and
regmap_encx24j600_phy_reg_write() in the conditions of the waiting
cycles for filling the variable 'ret' it is necessary to add parentheses
to prevent wrong assignment due to logical operations precedence.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70e53262f5c ("net: Microchip encx24j600 driver")
Signed-off-by: Valentina Goncharenko <goncharenko.vp@ispras.ru>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 46181559d1f1..4a3c0870c8e4 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -367,7 +367,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -405,7 +405,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.35.1



