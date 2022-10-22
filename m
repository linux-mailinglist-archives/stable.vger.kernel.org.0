Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAC3608788
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiJVIDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiJVIBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:01:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4035628B1A4;
        Sat, 22 Oct 2022 00:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 390A060B49;
        Sat, 22 Oct 2022 07:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48354C433C1;
        Sat, 22 Oct 2022 07:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424916;
        bh=ZgKxMsG8k59NViVoefO54z2B9yZQpBZLWjXNfWIvuok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvCFikQTdkONowiA9cqeyuvqFlNx6ynYfiFh9U0V/MM2rreuUXySOooy/dnxW1SqW
         B4gzROSqv4jFhgq4a18gEQcvdkPcVn+83OVwmq+FVt0VBAlqlAoAZUQF0jwgaNYcK1
         kUf0ZdwZg3z6HGE2U46k0dXpn1wS897qg4XjeuFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shao-Chuan Lee <shaochuan@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 323/717] drm/virtio: set fb_modifiers_not_supported
Date:   Sat, 22 Oct 2022 09:23:22 +0200
Message-Id: <20221022072508.789883172@linuxfoundation.org>
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

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 85faca8ca0f659263b5fb2385e4c231cc075bd84 ]

Without this, the drm core advertises LINEAR modifier which is
incorrect.

Also userspace virgl does not support modifiers.  For example, it causes
chrome on ozone/drm to fail with "Failed to create scanout buffer".

Fixes: 2af104290da5 ("drm: introduce fb_modifiers_not_supported flag in mode_config")
Suggested-by: Shao-Chuan Lee <shaochuan@chromium.org>
Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220831190601.1295129-1-olvaffe@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index f73352e7b832..96e71813864a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -348,6 +348,8 @@ int virtio_gpu_modeset_init(struct virtio_gpu_device *vgdev)
 	vgdev->ddev->mode_config.max_width = XRES_MAX;
 	vgdev->ddev->mode_config.max_height = YRES_MAX;
 
+	vgdev->ddev->mode_config.fb_modifiers_not_supported = true;
+
 	for (i = 0 ; i < vgdev->num_scanouts; ++i)
 		vgdev_output_init(vgdev, i);
 
-- 
2.35.1



