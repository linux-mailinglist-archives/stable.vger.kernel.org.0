Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B93395D61
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhEaNpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231863AbhEaNnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4CE61483;
        Mon, 31 May 2021 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467721;
        bh=/AR6sw5pzaS0ed642hqWFyYDQ9w5U8GATj9I4hP0v1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZ15utYCJcgcv4W9y3AeRK95nYN1q06+5d7j0wRgqPANSu9fHI6El57whIUQ0MJ2v
         EfHj/y2sSqAcJMxywcPoIJumZFYqtLacUrgATxeJO4EOsSAengWrSM2tvfFcvVivgT
         wdygLm6pMB5hWQ30iaQYk1Xsu6tEMteRXfMOqja0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4.14 38/79] drm/meson: fix shutdown crash when component not probed
Date:   Mon, 31 May 2021 15:14:23 +0200
Message-Id: <20210531130637.235108218@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 7cfc4ea78fc103ea51ecbacd9236abb5b1c490d2 upstream.

When main component is not probed, by example when the dw-hdmi module is
not loaded yet or in probe defer, the following crash appears on shutdown:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000038
...
pc : meson_drv_shutdown+0x24/0x50
lr : platform_drv_shutdown+0x20/0x30
...
Call trace:
meson_drv_shutdown+0x24/0x50
platform_drv_shutdown+0x20/0x30
device_shutdown+0x158/0x360
kernel_restart_prepare+0x38/0x48
kernel_restart+0x18/0x68
__do_sys_reboot+0x224/0x250
__arm64_sys_reboot+0x24/0x30
...

Simply check if the priv struct has been allocated before using it.

Fixes: fa0c16caf3d7 ("drm: meson_drv add shutdown function")
Reported-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210430082744.3638743-1-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/meson/meson_drv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -364,11 +364,12 @@ static int meson_probe_remote(struct pla
 static void meson_drv_shutdown(struct platform_device *pdev)
 {
 	struct meson_drm *priv = dev_get_drvdata(&pdev->dev);
-	struct drm_device *drm = priv->drm;
 
-	DRM_DEBUG_DRIVER("\n");
-	drm_kms_helper_poll_fini(drm);
-	drm_atomic_helper_shutdown(drm);
+	if (!priv)
+		return;
+
+	drm_kms_helper_poll_fini(priv->drm);
+	drm_atomic_helper_shutdown(priv->drm);
 }
 
 static int meson_drv_probe(struct platform_device *pdev)


