Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D38B60875E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiJVIA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiJVH7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:59:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA52355AF;
        Sat, 22 Oct 2022 00:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87CB5B82DF6;
        Sat, 22 Oct 2022 07:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA82CC433D7;
        Sat, 22 Oct 2022 07:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424944;
        bh=t9a02up3UmCRf+tLpcInPigc4BFh75HEwd8CGe1RyE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMr/FNl+tB74Vh21bXjSBPWVIUMaUxmO9/qjBq3Qr4Bp6+irnrRf7e7AY89Q25f17
         BZQ9kCxBX2UAt40FOKs00J3RX6Wu5UzXsFoQIGf8NHSWbvoCSjjSSHg7RVX57qgR96
         aloK2LaGJ2alRmF0D8/nl+oxvWpvGLImz4PiIbik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chia-I Wu <olvaffe@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 335/717] virtio-gpu: fix shift wrapping bug in virtio_gpu_fence_event_create()
Date:   Sat, 22 Oct 2022 09:23:34 +0200
Message-Id: <20221022072510.011098256@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 37a78445763a5921bb54e9bad01937d0dfa521c1 ]

The ->ring_idx_mask variable is a u64 so static checkers, Smatch in
this case, complain if the BIT() is not also a u64.

drivers/gpu/drm/virtio/virtgpu_ioctl.c:50 virtio_gpu_fence_event_create()
warn: should '(1 << ring_idx)' be a 64 bit type?

Fixes: cd7f5ca33585 ("drm/virtio: implement context init: add virtio_gpu_fence_event")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/YygN7jY0GdUSQSy0@kili
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 3b1701607aae..5d05093014ac 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -47,7 +47,7 @@ static int virtio_gpu_fence_event_create(struct drm_device *dev,
 	struct virtio_gpu_fence_event *e = NULL;
 	int ret;
 
-	if (!(vfpriv->ring_idx_mask & (1 << ring_idx)))
+	if (!(vfpriv->ring_idx_mask & BIT_ULL(ring_idx)))
 		return 0;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
-- 
2.35.1



