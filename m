Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C13608627
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiJVHp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiJVHoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97D87295E;
        Sat, 22 Oct 2022 00:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCCA860ADC;
        Sat, 22 Oct 2022 07:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4329C433D6;
        Sat, 22 Oct 2022 07:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424316;
        bh=MbFzbGmRV9ls7pOfhD3dBXJvQ3BbcGXsMvn+R0z7rNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSXa5X+sC6JG99BML+aE0MkfItc7cR+lhpj4BcxmVhMQE2Y6FsdftGbJFmwAcP30B
         Kro6M+9QSD/o/cRmM9a6EmNn9YAhW1AvausC0mEUYfnKAk74ec4uljRphxP6noYE/P
         DnY3avWJpE5tftBZpBAAgxEHK0EQFgCOJtjtrWNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.19 070/717] drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()
Date:   Sat, 22 Oct 2022 09:19:09 +0200
Message-Id: <20221022072427.601481487@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 4656b3a26a9e9fe5f04bfd2ab55b066266ba7f4d upstream.

Make virtio_gpu_plane_cleanup_fb() to clean the state which DRM core
wants to clean up and not the current plane's state. Normally the older
atomic state is cleaned up, but the newer state could also be cleaned up
in case of aborted commits.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-6-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_plane.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_plane.c
+++ b/drivers/gpu/drm/virtio/virtgpu_plane.c
@@ -266,14 +266,14 @@ static int virtio_gpu_plane_prepare_fb(s
 }
 
 static void virtio_gpu_plane_cleanup_fb(struct drm_plane *plane,
-					struct drm_plane_state *old_state)
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


