Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F04329142
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243180AbhCAUXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242693AbhCAUQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F36C653D1;
        Mon,  1 Mar 2021 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621737;
        bh=6zMXgh+XFJzQ6CWYEERvnVhuU4zxjGkCbpqSM0+CbG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUaMpiHi1gOPHDbz4VrGVqECBjHkTRKpxxmXLzKPfKIUgZRr1tlxwSl48rKWlD1Zx
         +LUCmZ0/c7fHowREsBiffyRaHuSk4ctwFqeA3+32CF8ECJBToIGUYwRF0INRKLBGrD
         1OtBT7WozJXjpp9DHRtgQTffxDvvU7waIzoehJKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Christopher Morgan <macromorgan@hotmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.11 624/775] drm/panel: kd35t133: allow using non-continuous dsi clock
Date:   Mon,  1 Mar 2021 17:13:12 +0100
Message-Id: <20210301161232.232504699@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>

commit d922d58fedcd98ba625e89b625a98e222b090b10 upstream.

The panel is able to work when dsi clock is non-continuous, thus
the system power consumption can be reduced using such feature.

Add MIPI_DSI_CLOCK_NON_CONTINUOUS to panel's mode_flags.

Also the flag actually becomes necessary after
commit c6d94e37bdbb ("drm/bridge/synopsys: dsi: add support for non-continuous HS clock")
and without it the panel only emits stripes instead of output.

Fixes: c6d94e37bdbb ("drm/bridge/synopsys: dsi: add support for non-continuous HS clock")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Christopher Morgan <macromorgan@hotmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210206135020.1991820-1-heiko@sntech.de
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-elida-kd35t133.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panel/panel-elida-kd35t133.c
+++ b/drivers/gpu/drm/panel/panel-elida-kd35t133.c
@@ -265,7 +265,8 @@ static int kd35t133_probe(struct mipi_ds
 	dsi->lanes = 1;
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
-			  MIPI_DSI_MODE_LPM | MIPI_DSI_MODE_EOT_PACKET;
+			  MIPI_DSI_MODE_LPM | MIPI_DSI_MODE_EOT_PACKET |
+			  MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
 	drm_panel_init(&ctx->panel, &dsi->dev, &kd35t133_funcs,
 		       DRM_MODE_CONNECTOR_DSI);


