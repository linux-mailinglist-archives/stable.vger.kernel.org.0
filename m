Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B73582E83
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbiG0RNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241578AbiG0RMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460757644C;
        Wed, 27 Jul 2022 09:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2847560D3B;
        Wed, 27 Jul 2022 16:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367F5C433C1;
        Wed, 27 Jul 2022 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940124;
        bh=4ErHXwOhPcEPwMUnQeYwhJKbusd/k1X5rqkKC/8iioU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsrXCQwd8PkjBOnihqLPPLaqb8f/Xph2B1P0bcejRdl8legb/No6TKxZeF8ilo3jN
         54FwqPAGnuMqnC6fVwj2+2M6tgq2m1o2MyMOGKw72dZV8YEJTNXYd3lHsdW10pDjz4
         IHTQwdL8zRoNkhUUz4l6QtmATcjc0MvSLk5d+zRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/201] net: dsa: vitesse-vsc73xx: silent spi_device_id warnings
Date:   Wed, 27 Jul 2022 18:10:18 +0200
Message-Id: <20220727161032.483840946@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 1774559f07993e1cac33c2406e99049d4bdea6c8 ]

Add spi_device_id entries to silent SPI warnings.

Fixes: 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT compatible")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220717135831.2492844-2-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-spi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index 645398901e05..922ae22fad66 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -207,10 +207,20 @@ static const struct of_device_id vsc73xx_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
 
+static const struct spi_device_id vsc73xx_spi_ids[] = {
+	{ "vsc7385" },
+	{ "vsc7388" },
+	{ "vsc7395" },
+	{ "vsc7398" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, vsc73xx_spi_ids);
+
 static struct spi_driver vsc73xx_spi_driver = {
 	.probe = vsc73xx_spi_probe,
 	.remove = vsc73xx_spi_remove,
 	.shutdown = vsc73xx_spi_shutdown,
+	.id_table = vsc73xx_spi_ids,
 	.driver = {
 		.name = "vsc73xx-spi",
 		.of_match_table = vsc73xx_of_match,
-- 
2.35.1



