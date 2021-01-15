Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725402F7AA9
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbhAOMfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732956AbhAOMfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F66E23356;
        Fri, 15 Jan 2021 12:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714078;
        bh=xxXoBY5nHnpv7/2YhjLVgSeywH1zqfCy2mWXgAox8TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZNHNU7EMC4ccrtqpBbB+qBWZTxNxuCelvZ5/U/9GRBSunsRJwYQPlnIwSFEAliYe
         hdIDgLpmWxNElhZtiZYLzXGipQBS0NDaw6qkKhTS7JJy37aq3GWkQeRUnz8P5msejy
         HvzIKErFTFRKPbUVF5gW/ykXrTndz5keJLo1D0eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 36/62] can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver
Date:   Fri, 15 Jan 2021 13:27:58 +0100
Message-Id: <20210115122000.140930399@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit aee2b3ccc8a63d1cd7da6a8a153d1f3712d40826 upstream.

According to the TCAN4550 datasheet "SLLSF91 - DECEMBER 2018" the tcan4x5x has
the same bittiming constants as a m_can revision 3.2.x/3.3.0.

The tcan4x5x chip I'm using identifies itself as m_can revision 3.2.1, so
remove the tcan4x5x specific bittiming values and rely on the values in the
m_can driver, which are selected according to core revision.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Cc: Dan Murphy <dmurphy@ti.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215103238.524029-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/m_can/tcan4x5x.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -126,30 +126,6 @@ struct tcan4x5x_priv {
 	int reg_offset;
 };
 
-static struct can_bittiming_const tcan4x5x_bittiming_const = {
-	.name = DEVICE_NAME,
-	.tseg1_min = 2,
-	.tseg1_max = 31,
-	.tseg2_min = 2,
-	.tseg2_max = 16,
-	.sjw_max = 16,
-	.brp_min = 1,
-	.brp_max = 32,
-	.brp_inc = 1,
-};
-
-static struct can_bittiming_const tcan4x5x_data_bittiming_const = {
-	.name = DEVICE_NAME,
-	.tseg1_min = 1,
-	.tseg1_max = 32,
-	.tseg2_min = 1,
-	.tseg2_max = 16,
-	.sjw_max = 16,
-	.brp_min = 1,
-	.brp_max = 32,
-	.brp_inc = 1,
-};
-
 static void tcan4x5x_check_wake(struct tcan4x5x_priv *priv)
 {
 	int wake_state = 0;
@@ -449,8 +425,6 @@ static int tcan4x5x_can_probe(struct spi
 	mcan_class->dev = &spi->dev;
 	mcan_class->ops = &tcan4x5x_ops;
 	mcan_class->is_peripheral = true;
-	mcan_class->bit_timing = &tcan4x5x_bittiming_const;
-	mcan_class->data_timing = &tcan4x5x_data_bittiming_const;
 	mcan_class->net->irq = spi->irq;
 
 	spi_set_drvdata(spi, priv);


