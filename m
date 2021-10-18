Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C7431E22
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhJRN56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhJRNz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B50DF61A0B;
        Mon, 18 Oct 2021 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564425;
        bh=Hsr8yR3apzln3frfbIipz2wD/w8DAgrCvd6kDWRWrEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xuj8NTNmDeKRVDL+0cgK9L4GP7X9m/CYkjUphOjpeP73qeCoZ/0k1rr1vvijtKpEs
         sfYeq63yNF39F/fUE6z+CSzjmdF5CshPGWCM+N3Vjm/Bv8Y8TE54J9YMEsdvPsefwN
         Q2bHbUXB9DVsDsYRxSHCGd0aMykoAxamcy944hvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.14 085/151] fpga: ice40-spi: Add SPI device ID table
Date:   Mon, 18 Oct 2021 15:24:24 +0200
Message-Id: <20211018132343.456508711@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 2a2a79577ddae7d5314b2f57ca86b44d794403d5 upstream.

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI ID table.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/ice40-spi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/fpga/ice40-spi.c
+++ b/drivers/fpga/ice40-spi.c
@@ -192,12 +192,19 @@ static const struct of_device_id ice40_f
 };
 MODULE_DEVICE_TABLE(of, ice40_fpga_of_match);
 
+static const struct spi_device_id ice40_fpga_spi_ids[] = {
+	{ .name = "ice40-fpga-mgr", },
+	{},
+};
+MODULE_DEVICE_TABLE(spi, ice40_fpga_spi_ids);
+
 static struct spi_driver ice40_fpga_driver = {
 	.probe = ice40_fpga_probe,
 	.driver = {
 		.name = "ice40spi",
 		.of_match_table = of_match_ptr(ice40_fpga_of_match),
 	},
+	.id_table = ice40_fpga_spi_ids,
 };
 
 module_spi_driver(ice40_fpga_driver);


