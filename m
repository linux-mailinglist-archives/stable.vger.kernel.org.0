Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051E026B3AA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgIOXHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbgIOOlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AAF4223D6;
        Tue, 15 Sep 2020 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179526;
        bh=Qswulpes5DUoBnzJqKLp4v9g2oQHTiIbMJVvN4WdC/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3xDhouqFl8TD1f62p9mk/FCwLNdMCMMk3dmlPGpT5NZHOxHKmrOYOSi3CbSxJ71v
         p4vfNLHcyfz0eOwp0Vhl3eW+aYnWjuzQyJUGi45Z2aeVT7LfF8b2pEMUo8sLVBJHRZ
         o4ug7B34RDKHNIdrWnt6MTpLw6cRfGcubnsTibDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/132] drm/sun4i: Fix dsi dcs long write function
Date:   Tue, 15 Sep 2020 16:11:58 +0200
Message-Id: <20200915140644.887450119@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit fd90e3808fd2c207560270c39b86b71af2231aa1 ]

It's writing too much data. regmap_bulk_write expects number of
register sized chunks to write, not a byte sized length of the
bounce buffer. Bounce buffer needs to be padded too, so that
regmap_bulk_write will not read past the end of the buffer.

Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200828125032.937148-1-megous@megous.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 4f944ace665d5..f2b288037b909 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -867,7 +867,7 @@ static int sun6i_dsi_dcs_write_long(struct sun6i_dsi *dsi,
 	regmap_write(dsi->regs, SUN6I_DSI_CMD_TX_REG(0),
 		     sun6i_dsi_dcs_build_pkt_hdr(dsi, msg));
 
-	bounce = kzalloc(msg->tx_len + sizeof(crc), GFP_KERNEL);
+	bounce = kzalloc(ALIGN(msg->tx_len + sizeof(crc), 4), GFP_KERNEL);
 	if (!bounce)
 		return -ENOMEM;
 
@@ -878,7 +878,7 @@ static int sun6i_dsi_dcs_write_long(struct sun6i_dsi *dsi,
 	memcpy((u8 *)bounce + msg->tx_len, &crc, sizeof(crc));
 	len += sizeof(crc);
 
-	regmap_bulk_write(dsi->regs, SUN6I_DSI_CMD_TX_REG(1), bounce, len);
+	regmap_bulk_write(dsi->regs, SUN6I_DSI_CMD_TX_REG(1), bounce, DIV_ROUND_UP(len, 4));
 	regmap_write(dsi->regs, SUN6I_DSI_CMD_CTL_REG, len + 4 - 1);
 	kfree(bounce);
 
-- 
2.25.1



