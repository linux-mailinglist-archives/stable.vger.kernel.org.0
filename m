Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F75143A1A4
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhJYTkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236999AbhJYTic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEF28604AC;
        Mon, 25 Oct 2021 19:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190481;
        bh=IIrpcUVTztwdklgZWMopXjqbhWQ1Nlwy6rmpCXx5ZZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DouhhhqgGrxUaBzrZtp4miDTUUFEMZ+5EteWNWXSYVsa7JaaZUKPXFACzhKfkWEBC
         3G0eTHxK5RQMKGd9sg4t4bCdp3JyDjLAPAIRzve9XY7z3uTgNZy6uxtcQx77Q2hSWb
         lgnoqFyyKTyTSLSpPrUajYIqrl9VdI0dxkeZD2Ik=
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
Subject: [PATCH 5.10 68/95] drm: mxsfb: Fix NULL pointer dereference crash on unload
Date:   Mon, 25 Oct 2021 21:15:05 +0200
Message-Id: <20211025191006.780906328@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
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
 


