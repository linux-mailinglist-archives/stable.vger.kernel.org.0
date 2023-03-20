Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6DB6C19B7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjCTPhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjCTPgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:36:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54902E836
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A5CDCE12C5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE4DC433EF;
        Mon, 20 Mar 2023 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326112;
        bh=LpRtXfs3aHQRr8gx0vmr/Po8E1+0VB63pxPkhZZiZN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoeqhsyyuf1eQhzmxENE/M7wHEsc2qrBYyR5+BrBnBul/GFjthPuWjJIHZEdmIyAw
         VctVJYhUfL9+fT+l5UXz93yCGNr1oCfiJ1HSPptSvTzqUT9AyglBtBWakavgqyyatr
         49E+yNX/7gaypTHKcaHiUTAABukGVUanbdfKXAfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxime Ripard <mripard@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 6.2 163/211] drm/sun4i: fix missing component unbind on bind errors
Date:   Mon, 20 Mar 2023 15:54:58 +0100
Message-Id: <20230320145520.270970327@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f upstream.

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Cc: stable@vger.kernel.org      # 4.7
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103242.4775-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -95,12 +95,12 @@ static int sun4i_drv_bind(struct device
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
 
@@ -119,6 +119,8 @@ static int sun4i_drv_bind(struct device
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);


