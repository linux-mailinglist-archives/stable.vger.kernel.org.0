Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E36E6ABCF5
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCFKdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCFKdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:33:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D26993CC;
        Mon,  6 Mar 2023 02:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFF1A60DDD;
        Mon,  6 Mar 2023 10:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D54C433D2;
        Mon,  6 Mar 2023 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678098777;
        bh=s2fnw6i03aDUOVRceqTeJE5GhIX+8kNWvjFzOfwDk4s=;
        h=From:To:Cc:Subject:Date:From;
        b=jiNOsXJjsaI2JlLF30jApPis06JPgizoX1wFUIyWw21iPDa61V3wQ2GP36JhldSTx
         bTkJVFUAwDtaJYoUDNbDyW9RoSWiWNmRBRwM5D6Ofb2IHFidkM+dFp0RL4IXwbO5Ad
         1PS3FDGXFW/SxYoXnJAA4yCQ4gd3n0N9LZXjCeiauPvrFiHfYDln6E0Xd3g4k9ttuF
         MGLf8Q2wsHlc8eJHiX31wUAZ5WZkT+0Lev32PJJm+urVpV6F743MqNh2JQzj9ISpm5
         s0SSFUDdbBrEIOMxgsF2dLx4MkEjTqp8bpiv9xbNaUL+xSrwIg2ZlwqQE4thA4QByr
         8aU+IWpQp7WMA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ89w-0001Fr-MP; Mon, 06 Mar 2023 11:33:37 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>
Cc:     David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] drm/sun4i: fix missing component unbind on bind errors
Date:   Mon,  6 Mar 2023 11:32:42 +0100
Message-Id: <20230306103242.4775-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Cc: stable@vger.kernel.org      # 4.7
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---

Note that this one has only been compile tested.

Johan


 drivers/gpu/drm/sun4i/sun4i_drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index cc94efbbf2d4..d6c741716167 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -95,12 +95,12 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	/* Remove early framebuffers (ie. simplefb) */
 	ret = drm_aperture_remove_framebuffers(false, &sun4i_drv_driver);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	sun4i_framebuffer_init(drm);
 
@@ -119,6 +119,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);
-- 
2.39.2

