Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A316604863
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiJSN4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbiJSNyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DC816551B;
        Wed, 19 Oct 2022 06:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC667B82419;
        Wed, 19 Oct 2022 08:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A82C433B5;
        Wed, 19 Oct 2022 08:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169805;
        bh=nvtaYVSKFDDYUb6/1fBbU9SEqDqsjhxHoNRXYfa+jfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjGzP9x5i0SA3Opuad1SSF0HeGbI50iuAMAftq9MRJRLNmz7GK7FQbxqPPEDA55Au
         rkzbhyzIIDsYLxj0lTecpc+YyKUiBTejPm4CymSg8DQ+i1nr0Rj79zOAlghN8Mnae9
         TUEmZfwDZNjFDiwZdy/R21bmu4ZbfaPuOTyL2P8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shao-Chuan Lee <shaochuan@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 383/862] drm/virtio: set fb_modifiers_not_supported
Date:   Wed, 19 Oct 2022 10:27:50 +0200
Message-Id: <20221019083306.878330786@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5c7f198c0712..9ea7611a9e0f 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -349,6 +349,8 @@ int virtio_gpu_modeset_init(struct virtio_gpu_device *vgdev)
 	vgdev->ddev->mode_config.max_width = XRES_MAX;
 	vgdev->ddev->mode_config.max_height = YRES_MAX;
 
+	vgdev->ddev->mode_config.fb_modifiers_not_supported = true;
+
 	for (i = 0 ; i < vgdev->num_scanouts; ++i)
 		vgdev_output_init(vgdev, i);
 
-- 
2.35.1



