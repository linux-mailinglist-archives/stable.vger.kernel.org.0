Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 854FE147F83
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgAXLCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgAXLCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:53 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26712087E;
        Fri, 24 Jan 2020 11:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863772;
        bh=wYZDHK1/ZAOMUPFBSYxV+QGRZSUzSL32vRfomsbvtSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa/VzcMh2o72a2LQKqhtwB5OtKjgSCfizq+BXkEFoR2BwM6dvgQyI4I1DUqBwMzVp
         vBsToU1b+G1LHNA5CEaenzSGDU0boXE8rkfCUe/qsgZEXfVcQqZMXs+kH0s2mA2VR0
         966ZbDCtZhuWiCTshASEL7TEaWdIL0FFaSTkl2rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/639] drm: rcar-du: Fix vblank initialization
Date:   Fri, 24 Jan 2020 10:24:01 +0100
Message-Id: <20200124093056.295269097@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 3d61fe5f59dd3e6f96fc0772156d257cb04dc656 ]

The drm_vblank_init() takes the total number of CRTCs as an argument,
but the rcar-du driver passes a bitmask of the CRTC indices. Fix it.

Fixes: 4bf8e1962f91 ("drm: Renesas R-Car Display Unit DRM driver")
Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 0386b454e2218..6a9578159c2b5 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -544,7 +544,7 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 	 * Initialize vertical blanking interrupts handling. Start with vblank
 	 * disabled for all CRTCs.
 	 */
-	ret = drm_vblank_init(dev, (1 << rcdu->num_crtcs) - 1);
+	ret = drm_vblank_init(dev, rcdu->num_crtcs);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1



