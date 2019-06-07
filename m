Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912CA39043
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbfFGPu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732166AbfFGPu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5483214AF;
        Fri,  7 Jun 2019 15:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922626;
        bh=piMpxsdyosbMoTcpghHO1UMOOd98rdM1cYQC+N5Zhhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7C8VD2i7M2ZchmrWmcew2asdPK1E9k6XYFmMCc77WljJ/IW+OupsV5HvlE8vG+Ea
         VQ/qCExmwBGErbV/VknnQi+D4J0zLkNHA235D7tX7rgRWv3/6gGHy1s0ZUXWZdt+N7
         eNjSmFXH+VzH1HUttvngqmGNc0iAkesn4v/wwYNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffy Chen <jeffy.chen@rock-chips.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Brian Norris <briannorris@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vicente Bergas <vicencb@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.1 81/85] drm/rockchip: shutdown drm subsystem on shutdown
Date:   Fri,  7 Jun 2019 17:40:06 +0200
Message-Id: <20190607153857.871881883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vicente Bergas <vicencb@gmail.com>

commit b8f9d7f37b6af829c34c49d1a4f73ce6ed58e403 upstream.

As explained by Robin Murphy:
> the IOMMU shutdown disables paging, so if the VOP is still
> scanning out then that will result in whatever IOVAs it was using now going
> straight out onto the bus as physical addresses.

We had a more radical approach before in commit
7f3ef5dedb14 ("drm/rockchip: Allow driver to be shutdown on reboot/kexec")
but that resulted in new warnings and oopses on shutdown on rk3399
chromeos devices.

So second try is resurrecting Vicentes shutdown change which should
achieve the same result but in a less drastic way.

Fixes: 63238173b2fa ("Revert "drm/rockchip: Allow driver to be shutdown on reboot/kexec"")
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org
Suggested-by: JeffyChen <jeffy.chen@rock-chips.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vicente Bergas <vicencb@gmail.com>
[adapted commit message to explain the history]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Brian Norris <briannorris@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190402113753.10118-1-heiko@sntech.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -448,6 +448,14 @@ static int rockchip_drm_platform_remove(
 	return 0;
 }
 
+static void rockchip_drm_platform_shutdown(struct platform_device *pdev)
+{
+	struct drm_device *drm = platform_get_drvdata(pdev);
+
+	if (drm)
+		drm_atomic_helper_shutdown(drm);
+}
+
 static const struct of_device_id rockchip_drm_dt_ids[] = {
 	{ .compatible = "rockchip,display-subsystem", },
 	{ /* sentinel */ },
@@ -457,6 +465,7 @@ MODULE_DEVICE_TABLE(of, rockchip_drm_dt_
 static struct platform_driver rockchip_drm_platform_driver = {
 	.probe = rockchip_drm_platform_probe,
 	.remove = rockchip_drm_platform_remove,
+	.shutdown = rockchip_drm_platform_shutdown,
 	.driver = {
 		.name = "rockchip-drm",
 		.of_match_table = rockchip_drm_dt_ids,


