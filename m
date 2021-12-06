Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10242469DEC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388606AbhLFPeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35080 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378286AbhLFP3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:29:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1506B81120;
        Mon,  6 Dec 2021 15:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2833CC34902;
        Mon,  6 Dec 2021 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804341;
        bh=7ChLCP/OKGry50Mf9RAvzQK8/j2BlcMeb4D9jk/YiVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFvjfohgHbuBwl08KLTjFBx3ucuYZhpmBpXg5oySXspiBMmeNqZ1c1y0kE0B1mJPV
         YFBm4dEEZzvLfDSFQDtvvYfm9eqwVyXHlm3Mcm6l/hZLlFmmJiDFJk7ipcDWvg/Wv6
         r48d5MNkOsBAjJouoOLYzWswP/okynqvF9LeFvF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 113/207] net: dsa: b53: Add SPI ID table
Date:   Mon,  6 Dec 2021 15:56:07 +0100
Message-Id: <20211206145614.162641551@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 88362ebfd7fb569c78d5cb507aa9d3c8fc203839 upstream.

Currently autoloading for SPI devices does not use the DT ID table, it
uses SPI modalises. Supporting OF modalises is going to be difficult if
not impractical, an attempt was made but has been reverted, so ensure
that module autoloading works for this driver by adding an id_table
listing the SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_spi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/dsa/b53/b53_spi.c
+++ b/drivers/net/dsa/b53/b53_spi.c
@@ -349,6 +349,19 @@ static const struct of_device_id b53_spi
 };
 MODULE_DEVICE_TABLE(of, b53_spi_of_match);
 
+static const struct spi_device_id b53_spi_ids[] = {
+	{ .name = "bcm5325" },
+	{ .name = "bcm5365" },
+	{ .name = "bcm5395" },
+	{ .name = "bcm5397" },
+	{ .name = "bcm5398" },
+	{ .name = "bcm53115" },
+	{ .name = "bcm53125" },
+	{ .name = "bcm53128" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(spi, b53_spi_ids);
+
 static struct spi_driver b53_spi_driver = {
 	.driver = {
 		.name	= "b53-switch",
@@ -357,6 +370,7 @@ static struct spi_driver b53_spi_driver
 	.probe	= b53_spi_probe,
 	.remove	= b53_spi_remove,
 	.shutdown = b53_spi_shutdown,
+	.id_table = b53_spi_ids,
 };
 
 module_spi_driver(b53_spi_driver);


