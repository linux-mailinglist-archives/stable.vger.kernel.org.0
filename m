Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D71A43A334
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhJYT5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235497AbhJYTzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08F2F610A6;
        Mon, 25 Oct 2021 19:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191132;
        bh=IIrpcUVTztwdklgZWMopXjqbhWQ1Nlwy6rmpCXx5ZZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEI5zUtpi4zMjUMyiDF/2vg7yUgyS/frFPjFqJx7+IjLJfbPvIU05ZwT5MPwTpTpX
         33TR2Hzus+Oaus/6CWNQDt221amW/S4/y7nATRk8kK4/8x0o9lk3RY/6GNvGWsev6y
         NCTtFKier2IPf3tdXPXvEyUvNOfH8wSW6PSd8+jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Daniel Abrecht <public@danielabrecht.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Stefan Agner <stefan@agner.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.14 122/169] drm: mxsfb: Fix NULL pointer dereference crash on unload
Date:   Mon, 25 Oct 2021 21:15:03 +0200
Message-Id: <20211025191033.309049783@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 3cfc183052c3dbf8eae57b6c1685dab00ed3db4a upstream.

The mxsfb->crtc.funcs may already be NULL when unloading the driver,
in which case calling mxsfb_irq_disable() via drm_irq_uninstall() from
mxsfb_unload() leads to NULL pointer dereference.

Since all we care about is masking the IRQ and mxsfb->base is still
valid, just use that to clear and mask the IRQ.

Fixes: ae1ed00932819 ("drm: mxsfb: Stop using DRM simple display pipeline helper")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Daniel Abrecht <public@danielabrecht.ch>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefan Agner <stefan@agner.ch>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211016210446.171616-1-marex@denx.de
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_drv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
@@ -268,7 +268,11 @@ static void mxsfb_irq_disable(struct drm
 	struct mxsfb_drm_private *mxsfb = drm->dev_private;
 
 	mxsfb_enable_axi_clk(mxsfb);
-	mxsfb->crtc.funcs->disable_vblank(&mxsfb->crtc);
+
+	/* Disable and clear VBLANK IRQ */
+	writel(CTRL1_CUR_FRAME_DONE_IRQ_EN, mxsfb->base + LCDC_CTRL1 + REG_CLR);
+	writel(CTRL1_CUR_FRAME_DONE_IRQ, mxsfb->base + LCDC_CTRL1 + REG_CLR);
+
 	mxsfb_disable_axi_clk(mxsfb);
 }
 


