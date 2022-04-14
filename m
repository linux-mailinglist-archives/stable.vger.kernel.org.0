Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481CF501507
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbiDNNm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344669AbiDNNdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:33:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A2622298;
        Thu, 14 Apr 2022 06:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E92B82985;
        Thu, 14 Apr 2022 13:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F4C385A5;
        Thu, 14 Apr 2022 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943040;
        bh=FIT3wawucFWfzyjni/wMaQn1OA4tnDnV0gudXsZTwlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yezxHuw4U6F+kQnYazV6DNgbVGoLtQH57k7Q/3q7ZJbJtEtUj8TJD0Bj5LvLlvY6S
         HSOxUecoNrbPLAJoFb/ZBuezqFgQZX7oslWLSE8xHRP4UR1rowwMSmNwVTHz2fCRM0
         TQ0PrPG8dMdeWtXme3A1WvtC9JiuKRJYD65LBGlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/475] net: dsa: microchip: add spi_device_id tables
Date:   Thu, 14 Apr 2022 15:06:39 +0200
Message-Id: <20220414110855.551878370@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit e981bc74aefc6a177b50c16cfa7023599799cf74 ]

Add spi_device_id tables to avoid logs like "SPI driver ksz9477-switch
has no spi_device_id".

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795_spi.c | 11 +++++++++++
 drivers/net/dsa/microchip/ksz9477_spi.c | 12 ++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 8b00f8e6c02f..5639c5c59e25 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -86,12 +86,23 @@ static const struct of_device_id ksz8795_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
 
+static const struct spi_device_id ksz8795_spi_ids[] = {
+	{ "ksz8765" },
+	{ "ksz8794" },
+	{ "ksz8795" },
+	{ "ksz8863" },
+	{ "ksz8873" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ksz8795_spi_ids);
+
 static struct spi_driver ksz8795_spi_driver = {
 	.driver = {
 		.name	= "ksz8795-switch",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(ksz8795_dt_ids),
 	},
+	.id_table = ksz8795_spi_ids,
 	.probe	= ksz8795_spi_probe,
 	.remove	= ksz8795_spi_remove,
 	.shutdown = ksz8795_spi_shutdown,
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 1142768969c2..9bda83d063e8 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -88,12 +88,24 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
 
+static const struct spi_device_id ksz9477_spi_ids[] = {
+	{ "ksz9477" },
+	{ "ksz9897" },
+	{ "ksz9893" },
+	{ "ksz9563" },
+	{ "ksz8563" },
+	{ "ksz9567" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ksz9477_spi_ids);
+
 static struct spi_driver ksz9477_spi_driver = {
 	.driver = {
 		.name	= "ksz9477-switch",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(ksz9477_dt_ids),
 	},
+	.id_table = ksz9477_spi_ids,
 	.probe	= ksz9477_spi_probe,
 	.remove	= ksz9477_spi_remove,
 	.shutdown = ksz9477_spi_shutdown,
-- 
2.34.1



