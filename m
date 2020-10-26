Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416DE29A039
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438830AbgJ0A2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409889AbgJZXwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820CA218AC;
        Mon, 26 Oct 2020 23:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756370;
        bh=iWq+kWKnrKXiGx+p27rK1ZDgY1h1EZj7pDFxBn7JNGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Itfvs7/NMiHmlnPY+QL2C5NdZhvwsGWXO7cM03Ff5nf65FViZqSXjWmSLIgaqMeFm
         Lc6T0mviFw9nhlss5juCEG4oV4OUkRYplp4WjMRWopHXtIuiaw6KlNG3QS4Ls18ptt
         JqkMSjBHLiIoJiglbEoGPx+HWzbb5ixdMXp35bDY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Bilal Wasim <bwasim.lkml@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 037/132] drm/bridge_connector: Set default status connected for eDP connectors
Date:   Mon, 26 Oct 2020 19:50:29 -0400
Message-Id: <20201026235205.1023962-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit c5589b39549d1875bb506da473bf4580c959db8c ]

In an eDP application, HPD is not required and on most bridge chips
useless. If HPD is not used, we need to set initial status as connected,
otherwise the connector created by the drm_bridge_connector API remains
in an unknown state.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Bilal Wasim <bwasim.lkml@gmail.com>
Tested-by: Bilal Wasim <bwasim.lkml@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200826081526.674866-2-enric.balletbo@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge_connector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_bridge_connector.c b/drivers/gpu/drm/drm_bridge_connector.c
index c6994fe673f31..a58cbde59c34a 100644
--- a/drivers/gpu/drm/drm_bridge_connector.c
+++ b/drivers/gpu/drm/drm_bridge_connector.c
@@ -187,6 +187,7 @@ drm_bridge_connector_detect(struct drm_connector *connector, bool force)
 		case DRM_MODE_CONNECTOR_DPI:
 		case DRM_MODE_CONNECTOR_LVDS:
 		case DRM_MODE_CONNECTOR_DSI:
+		case DRM_MODE_CONNECTOR_eDP:
 			status = connector_status_connected;
 			break;
 		default:
-- 
2.25.1

