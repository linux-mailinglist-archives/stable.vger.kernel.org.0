Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6702A5170
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgKCUky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgKCUkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9B8822226;
        Tue,  3 Nov 2020 20:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436052;
        bh=UU+4GilsOClfcA6ht0z1Ji4GBivAUTKH0T4WbJFuobQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEd+2J7q1TxoaVBQ62j9DrLENScvbkwXJIxyTEWbCFAKQbv44hmUkUdIb/i/D6Aml
         wbHRdaBBT+s1I4/mp586i2C9ow4sjhvmV2u4kTXV4hDu7OfZEhSou9JxJ4kPGNvgSN
         5VnEJBQGvPawwHIeUiaKWC9kMw6v48zC9dmHgYfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Bilal Wasim <bwasim.lkml@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 082/391] drm/bridge_connector: Set default status connected for eDP connectors
Date:   Tue,  3 Nov 2020 21:32:13 +0100
Message-Id: <20201103203352.612565862@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0



