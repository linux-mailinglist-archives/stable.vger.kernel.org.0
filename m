Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F62473B8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389119AbgHQTAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730849AbgHQPsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:48:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18DC92075B;
        Mon, 17 Aug 2020 15:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679295;
        bh=Ev2MKrV3RTdHkwWtyN15qSAmclYuXz3Qy4/2nqB5rpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcfqzE2GQ0WSExMMMq7uCOMmNHVmGJlFbyrG3Q+os0hz7JYf3cZJ7Ps/2c8yjIavi
         SrG0Rf5ofrhIm8VQ9JdSzcTw31nIbae6vewRzmlT5/Vn/YwAR35lUaf+/vnYNM54sV
         Vy0mqcpLk9EJ9qL5psgeDXf8i94v3h9ZtwKy8pyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Chiras <robert.chiras@nxp.com>,
        Vinay Simha BN <simhavcs@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 163/393] drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline
Date:   Mon, 17 Aug 2020 17:13:33 +0200
Message-Id: <20200817143827.524032519@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Velikov <emil.velikov@collabora.com>

[ Upstream commit 7a05c3b6d24b8460b3cec436cf1d33fac43c8450 ]

The helper uses the MIPI_DCS_SET_TEAR_SCANLINE, although it's currently
using the generic write. This does not look right.

Perhaps some platforms don't distinguish between the two writers?

Cc: Robert Chiras <robert.chiras@nxp.com>
Cc: Vinay Simha BN <simhavcs@gmail.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Thierry Reding <treding@nvidia.com>
Fixes: e83950816367 ("drm/dsi: Implement set tear scanline")
Signed-off-by: Emil Velikov <emil.velikov@collabora.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200505160329.2976059-3-emil.l.velikov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 55531895dde6d..37b03fefbdf6f 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -1082,11 +1082,11 @@ EXPORT_SYMBOL(mipi_dsi_dcs_set_pixel_format);
  */
 int mipi_dsi_dcs_set_tear_scanline(struct mipi_dsi_device *dsi, u16 scanline)
 {
-	u8 payload[3] = { MIPI_DCS_SET_TEAR_SCANLINE, scanline >> 8,
-			  scanline & 0xff };
+	u8 payload[2] = { scanline >> 8, scanline & 0xff };
 	ssize_t err;
 
-	err = mipi_dsi_generic_write(dsi, payload, sizeof(payload));
+	err = mipi_dsi_dcs_write(dsi, MIPI_DCS_SET_TEAR_SCANLINE, payload,
+				 sizeof(payload));
 	if (err < 0)
 		return err;
 
-- 
2.25.1



