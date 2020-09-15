Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC226B778
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgIOOUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgIOOTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:19:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B78422224;
        Tue, 15 Sep 2020 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179374;
        bh=VMRScTNZjqcuxBSNlIcKXYNZRhstNmmeSh2GLH+N330=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9+ZFo6WJV99XpfcW/E096RTq96cAsLvbkG1nhoQX+xGWFqVjo5u/1m4PRvF1KMAk
         j8dhI5TZnzCVvXRvcMvbIixwbczEDpai9jrAGA0rs4FhD4lUSeZBR5Oa3IqGmRPz04
         PjLyRoG4/leU2LkB7NBizAggKi1Hp8aNVydcMtzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/78] drm/sun4i: Fix dsi dcs long write function
Date:   Tue, 15 Sep 2020 16:12:33 +0200
Message-Id: <20200915140633.952390220@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
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
index 79eb11cd185d1..9a5584efd5e78 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -761,7 +761,7 @@ static int sun6i_dsi_dcs_write_long(struct sun6i_dsi *dsi,
 	regmap_write(dsi->regs, SUN6I_DSI_CMD_TX_REG(0),
 		     sun6i_dsi_dcs_build_pkt_hdr(dsi, msg));
 
-	bounce = kzalloc(msg->tx_len + sizeof(crc), GFP_KERNEL);
+	bounce = kzalloc(ALIGN(msg->tx_len + sizeof(crc), 4), GFP_KERNEL);
 	if (!bounce)
 		return -ENOMEM;
 
@@ -772,7 +772,7 @@ static int sun6i_dsi_dcs_write_long(struct sun6i_dsi *dsi,
 	memcpy((u8 *)bounce + msg->tx_len, &crc, sizeof(crc));
 	len += sizeof(crc);
 
-	regmap_bulk_write(dsi->regs, SUN6I_DSI_CMD_TX_REG(1), bounce, len);
+	regmap_bulk_write(dsi->regs, SUN6I_DSI_CMD_TX_REG(1), bounce, DIV_ROUND_UP(len, 4));
 	regmap_write(dsi->regs, SUN6I_DSI_CMD_CTL_REG, len + 4 - 1);
 	kfree(bounce);
 
-- 
2.25.1



