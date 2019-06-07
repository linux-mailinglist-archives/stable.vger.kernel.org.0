Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7833913C
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbfFGPm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbfFGPm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:42:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB0292146E;
        Fri,  7 Jun 2019 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922175;
        bh=3de85AOfx0eQ4s/eIx9LLJEkQ43wcwNNs3tYwmb0X9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSgtU2zz0WdvKopZ/mkAWLzliWUBOpGyHgGXF95FbBMVqOFyqskDrFdk0CeEorqQs
         AjEEKO95lfx64XMi8bbwjR4WxrtzDpketwJUIuGtkGqgad755U+RWkuXMOgsgmbdYN
         M9SofejRrfCEhOhadFt1o0KPst8tzsexbZS23FfI=
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
Subject: [PATCH 4.14 63/69] drm/rockchip: shutdown drm subsystem on shutdown
Date:   Fri,  7 Jun 2019 17:39:44 +0200
Message-Id: <20190607153855.738108376@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
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
@@ -425,6 +425,14 @@ static int rockchip_drm_platform_remove(
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
@@ -434,6 +442,7 @@ MODULE_DEVICE_TABLE(of, rockchip_drm_dt_
 static struct platform_driver rockchip_drm_platform_driver = {
 	.probe = rockchip_drm_platform_probe,
 	.remove = rockchip_drm_platform_remove,
+	.shutdown = rockchip_drm_platform_shutdown,
 	.driver = {
 		.name = "rockchip-drm",
 		.of_match_table = rockchip_drm_dt_ids,


