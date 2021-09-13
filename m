Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8755408EFD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbhIMNia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241896AbhIMNgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F78610CC;
        Mon, 13 Sep 2021 13:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539666;
        bh=PVex8fCMaRtC1qcYDJnSUMp3qED/h2jG5k4Z5O2w71o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q04Cv+3SICLheKjgrivrKTWo7SbjOJAZYcQYKDm3syFMXlV2RhY01kl3jil2nRNyH
         H7wtxXXwt+k6lgsdlUkmUu39zqsbK476BWiJ7/UhyvmBCgBboqp2zy2N6JuYycf3Dw
         ssH5ewPZ7KbShYiPz6q4jWu3QQuHNkC0XTYmHlfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Daniel Abrecht <public@danielabrecht.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/236] drm: mxsfb: Clear FIFO_CLEAR bit
Date:   Mon, 13 Sep 2021 15:13:38 +0200
Message-Id: <20210913131104.183068252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5e23c98178eb1a2cdb7c4fee9a39baf8cabf282d ]

Make sure the FIFO_CLEAR bit is latched in when configuring the
controller, so that the FIFO is really cleared. And then clear
the FIFO_CLEAR bit, since it is not self-clearing.

Fixes: 45d59d704080 ("drm: Add new driver for MXSFB controller")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Daniel Abrecht <public@danielabrecht.ch>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Stefan Agner <stefan@agner.ch>
Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
Tested-by: Jagan Teki <jagan@amarulasolutions.com> # i.Core MX8MM
Acked-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210620224946.189524-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 007ea29abfcc..b535621f4f78 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -243,6 +243,9 @@ static void mxsfb_crtc_mode_set_nofb(struct mxsfb_drm_private *mxsfb)
 
 	/* Clear the FIFOs */
 	writel(CTRL1_FIFO_CLEAR, mxsfb->base + LCDC_CTRL1 + REG_SET);
+	readl(mxsfb->base + LCDC_CTRL1);
+	writel(CTRL1_FIFO_CLEAR, mxsfb->base + LCDC_CTRL1 + REG_CLR);
+	readl(mxsfb->base + LCDC_CTRL1);
 
 	if (mxsfb->devdata->has_overlay)
 		writel(0, mxsfb->base + LCDC_AS_CTRL);
-- 
2.30.2



