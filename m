Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF48272F3B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgIUQze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgIUQpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9F12076B;
        Mon, 21 Sep 2020 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706745;
        bh=01FOSVUIKtoPwtawvW+LsvkhTRWitElIkyvsuL3mOto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJ/9O5MT2TJToGSHMEf+2GIQjPMH2JztgdXIOBf9tBaZO42efFo51LkbbqU7V4XHu
         dHWpMiP4lItWT72XzFpE1ZxDi0xfH9YCbSMlp1cW+fd+gtmBh9zdP2TCgewG+At5MC
         QXotQIggzdXvO35NNV9iWPMmw5LtCVymU2buWJJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Fabio Estevam <festevam@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 077/118] i2c: mxs: use MXS_DMA_CTRL_WAIT4END instead of DMA_CTRL_ACK
Date:   Mon, 21 Sep 2020 18:28:09 +0200
Message-Id: <20200921162039.912352609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 6eb158ec0a45dbfd98bc6971c461b7d4d5bf61b3 ]

The driver-specific usage of the DMA_CTRL_ACK flag was replaced with a
custom flag in commit ceeeb99cd821 ("dmaengine: mxs: rename custom flag"),
but i2c-mxs was not updated to use the new flag, completely breaking I2C
transactions using DMA.

Fixes: ceeeb99cd821 ("dmaengine: mxs: rename custom flag")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 9587347447f0f..c4b08a9244614 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -25,6 +25,7 @@
 #include <linux/of_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
+#include <linux/dma/mxs-dma.h>
 
 #define DRIVER_NAME "mxs-i2c"
 
@@ -200,7 +201,8 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		dma_map_sg(i2c->dev, &i2c->sg_io[0], 1, DMA_TO_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, &i2c->sg_io[0], 1,
 					DMA_MEM_TO_DEV,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT |
+					MXS_DMA_CTRL_WAIT4END);
 		if (!desc) {
 			dev_err(i2c->dev,
 				"Failed to get DMA data write descriptor.\n");
@@ -228,7 +230,8 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		dma_map_sg(i2c->dev, &i2c->sg_io[1], 1, DMA_FROM_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, &i2c->sg_io[1], 1,
 					DMA_DEV_TO_MEM,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT |
+					MXS_DMA_CTRL_WAIT4END);
 		if (!desc) {
 			dev_err(i2c->dev,
 				"Failed to get DMA data write descriptor.\n");
@@ -260,7 +263,8 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		dma_map_sg(i2c->dev, i2c->sg_io, 2, DMA_TO_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, i2c->sg_io, 2,
 					DMA_MEM_TO_DEV,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT |
+					MXS_DMA_CTRL_WAIT4END);
 		if (!desc) {
 			dev_err(i2c->dev,
 				"Failed to get DMA data write descriptor.\n");
-- 
2.25.1



