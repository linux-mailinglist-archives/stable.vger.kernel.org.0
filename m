Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DC34996C0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347255AbiAXVGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346556AbiAXU6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 407FDB810A8;
        Mon, 24 Jan 2022 20:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E345C340EE;
        Mon, 24 Jan 2022 20:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057878;
        bh=WZDVIQIpgDa0TPO+WKGnuxZv7obQrPN87x3ZN3QYyIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d72mdtIr5n1dGfy8MlLOp0cLrohAZ4biD8qNDJGmIK3ugpMhsVuhDWeQCYDt6AGtb
         cdpfYLMle4mD8TXK+pAWY0sR8aNB5XJF9QJzbOrOUOsEjIuyEfqBZwCn9QT3r3HnmH
         kw7UH8k4AiRBfITXvWJBEwezqIWTY7NApH2i61cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0108/1039] drm/vc4: hdmi: Enable the scrambler on reconnection
Date:   Mon, 24 Jan 2022 19:31:37 +0100
Message-Id: <20220124184128.776595374@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit b7551457c5d0b3505b0be247d47919c1ee30506d ]

If we have a state already and disconnect/reconnect the display, the
SCDC messages won't be sent again since we didn't go through a disable /
enable cycle.

In order to fix this, let's call the vc4_hdmi_enable_scrambling function
in the detect callback if there is a mode and it needs the scrambler to
be enabled.

Fixes: c85695a2016e ("drm/vc4: hdmi: Enable the scrambler")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20211025152903.1088803-10-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 05fd54fbb773e..c000946996edb 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -162,6 +162,8 @@ static void vc4_hdmi_cec_update_clk_div(struct vc4_hdmi *vc4_hdmi)
 static void vc4_hdmi_cec_update_clk_div(struct vc4_hdmi *vc4_hdmi) {}
 #endif
 
+static void vc4_hdmi_enable_scrambling(struct drm_encoder *encoder);
+
 static enum drm_connector_status
 vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 {
@@ -190,6 +192,7 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 			}
 		}
 
+		vc4_hdmi_enable_scrambling(&vc4_hdmi->encoder.base.base);
 		pm_runtime_put(&vc4_hdmi->pdev->dev);
 		return connector_status_connected;
 	}
-- 
2.34.1



