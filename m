Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE590498D27
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348214AbiAXT2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:28:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53838 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351195AbiAXT0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2C9E60BB9;
        Mon, 24 Jan 2022 19:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B38C340E5;
        Mon, 24 Jan 2022 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052368;
        bh=DU3CIw3p50KSKQOPg73wZG2FU2DsWzcnpkARL7xOBgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLsZQQBrFp/dTzspCjDI3uyxslHknsdGV9FbJhmZdRRCq+hgrE3wTyG8KFHFaLGfC
         xuJ/r/AV/CdChrQ+YnVwFCxbeOD3Yq+oPOt1ZeD1U0kD1TamkzrU9M9McbdEXmiTfP
         HmsX2IoLQqK8jvbWfyU8Zk03R3im5PjHKhdi3yGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/320] drm/rockchip: dsi: Fix unbalanced clock on probe error
Date:   Mon, 24 Jan 2022 19:40:20 +0100
Message-Id: <20220124183954.978288662@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 251888398753924059f3bb247a44153a2853137f ]

Our probe() function never enabled this clock, so we shouldn't disable
it if we fail to probe the bridge.

Noted by inspection.

Fixes: 2d4f7bdafd70 ("drm/rockchip: dsi: migrate to use dw-mipi-dsi bridge driver")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210928143413.v3.3.Ie8ceefb51ab6065a1151869b6fcda41a467d4d2c@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1023,14 +1023,10 @@ static int dw_mipi_dsi_rockchip_probe(st
 		if (ret != -EPROBE_DEFER)
 			DRM_DEV_ERROR(dev,
 				      "Failed to probe dw_mipi_dsi: %d\n", ret);
-		goto err_clkdisable;
+		return ret;
 	}
 
 	return 0;
-
-err_clkdisable:
-	clk_disable_unprepare(dsi->pllref_clk);
-	return ret;
 }
 
 static int dw_mipi_dsi_rockchip_remove(struct platform_device *pdev)


