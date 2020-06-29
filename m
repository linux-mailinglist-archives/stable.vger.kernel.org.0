Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F820D9FE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388322AbgF2Twh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387698AbgF2Tk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1CD824A5F;
        Mon, 29 Jun 2020 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444489;
        bh=ECpNuCKOfz0HzoYh34np1515OWgjGGHUOBjKTdc3O4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jdTblEtYyK0T6+GLjzoKuEbYnPUOdAyxFT0njnDpveT3c5J7HCGL5ZAGsVqh37BN
         XqnnejR02bnjyPYeqL+gtUyhW4zmLJ0BA0erVKD0U1mSxBnddta+Qdruyc8EmyZbC6
         dhIcPz2+hYMlXqAlT2CQR1GYP0PJ3ph6Wh+Wxkt0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Gomez <dagmcr@gmail.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 166/178] drm: rcar-du: Fix build error
Date:   Mon, 29 Jun 2020 11:25:11 -0400
Message-Id: <20200629152523.2494198-167-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gomez <dagmcr@gmail.com>

commit 5f9af404eec82981c4345c9943be48422234e7ab upstream.

Select DRM_KMS_HELPER dependency.

Build error when DRM_KMS_HELPER is not selected:

drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xd48): undefined reference to `drm_atomic_helper_bridge_duplicate_state'
drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xd50): undefined reference to `drm_atomic_helper_bridge_destroy_state'
drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xd70): undefined reference to `drm_atomic_helper_bridge_reset'
drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xdc8): undefined reference to `drm_atomic_helper_connector_reset'
drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xde0): undefined reference to `drm_helper_probe_single_connector_modes'
drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xe08): undefined reference to `drm_atomic_helper_connector_duplicate_state'
drivers/gpu/drm/rcar-du/rcar_lvds.o:(.rodata+0xe10): undefined reference to `drm_atomic_helper_connector_destroy_state'

Fixes: c6a27fa41fab ("drm: rcar-du: Convert LVDS encoder code to bridge driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Daniel Gomez <dagmcr@gmail.com>
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rcar-du/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index 1529849e217e9..7cdba77b1420c 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -23,6 +23,7 @@ config DRM_RCAR_DW_HDMI
 config DRM_RCAR_LVDS
 	tristate "R-Car DU LVDS Encoder Support"
 	depends on DRM && DRM_BRIDGE && OF
+	select DRM_KMS_HELPER
 	select DRM_PANEL
 	select OF_FLATTREE
 	select OF_OVERLAY
-- 
2.25.1

