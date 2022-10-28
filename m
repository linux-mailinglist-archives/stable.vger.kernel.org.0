Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4595D611085
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJ1MG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJ1MGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:06:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3289D9C7D0
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF401B829BF
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2277CC433D6;
        Fri, 28 Oct 2022 12:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958778;
        bh=Fw8uxSB1Fg+ST5RDpcE3ajbLx88KQnXUiyQkxCzappo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guM5JuKLHIBL2btspw2uW/fbVCJr/i3gyv0ZRFZSzN/0/gKqncvjRFIMBnnzfuU4D
         wTKcPCRcdUKwgWyV8X1s0vi2zMef0fGla9Hx4JadMsZh1FryS2r8lW+XhiYuePIJg2
         MBnSu82YR0pHzZyBHByHMPV8y6gnzqxtqbTqYJlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/73] drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()
Date:   Fri, 28 Oct 2022 14:03:46 +0200
Message-Id: <20221028120234.508089333@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 4656b3a26a9e9fe5f04bfd2ab55b066266ba7f4d ]

Make virtio_gpu_plane_cleanup_fb() to clean the state which DRM core
wants to clean up and not the current plane's state. Normally the older
atomic state is cleaned up, but the newer state could also be cleaned up
in case of aborted commits.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-6-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_plane.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_plane.c b/drivers/gpu/drm/virtio/virtgpu_plane.c
index 6a311cd93440..e6de62734269 100644
--- a/drivers/gpu/drm/virtio/virtgpu_plane.c
+++ b/drivers/gpu/drm/virtio/virtgpu_plane.c
@@ -213,14 +213,14 @@ static int virtio_gpu_cursor_prepare_fb(struct drm_plane *plane,
 }
 
 static void virtio_gpu_cursor_cleanup_fb(struct drm_plane *plane,
-					 struct drm_plane_state *old_state)
+					struct drm_plane_state *state)
 {
 	struct virtio_gpu_framebuffer *vgfb;
 
-	if (!plane->state->fb)
+	if (!state->fb)
 		return;
 
-	vgfb = to_virtio_gpu_framebuffer(plane->state->fb);
+	vgfb = to_virtio_gpu_framebuffer(state->fb);
 	if (vgfb->fence) {
 		dma_fence_put(&vgfb->fence->f);
 		vgfb->fence = NULL;
-- 
2.35.1



