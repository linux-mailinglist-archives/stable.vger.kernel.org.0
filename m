Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD884F2D2C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245628AbiDEI4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241478AbiDEIdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71FFBD8;
        Tue,  5 Apr 2022 01:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E0BE60AFB;
        Tue,  5 Apr 2022 08:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E54AC385A1;
        Tue,  5 Apr 2022 08:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147511;
        bh=jmP3FPdm1hh5kPbcapZm2SdByBPDlY4fxfWaKWpCmCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHgqgk2XR15hEcz16iMbp7GfX0r6XugmS0WNH7mPnN6/bho8WPbNWlWowaqxUmMuD
         vd0PdrLBgvGJO5kNFxNIW+Ja+LkFHrXexYyWlxZHC1kvsvvpl74smlgnKT1tuxBaY0
         Vfo85FnftElezdOfbJo74WCSt3l6fQnGud78XRBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0022/1017] net: dsa: microchip: add spi_device_id tables
Date:   Tue,  5 Apr 2022 09:15:35 +0200
Message-Id: <20220405070354.833739780@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 866767b70d65..b0a7dee27ffc 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -124,12 +124,23 @@ static const struct of_device_id ksz8795_dt_ids[] = {
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
index e3cb0e6c9f6f..43addeabfc25 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -98,12 +98,24 @@ static const struct of_device_id ksz9477_dt_ids[] = {
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



