Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE4603D6A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiJSJB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiJSJAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:00:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1ED6B67F;
        Wed, 19 Oct 2022 01:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1218A617EC;
        Wed, 19 Oct 2022 08:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211B3C433D6;
        Wed, 19 Oct 2022 08:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169640;
        bh=EEbUB2+t3mQjhUpvR8BIh6PyoINtwoaI6t93TceIrNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2xY8hWvskFnNNIu6U8YF7NJtHb9Zt89RJ95eWHoTLLxGdQbuNnExZ4ejLSt/93rh
         b8e1KENBRlKin1pxP7r7UXJMLsDKCN8yqhTzMEAmzk83Rt9N4UAInMX7jv0WPraH1W
         C2gUE5tNW3PvrOqvoD7dKY+Oq88NRNBuld3d4D1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emil Velikov <emil.l.velikov@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 353/862] drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling
Date:   Wed, 19 Oct 2022 10:27:20 +0200
Message-Id: <20221019083305.639563564@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 64b88afbd92fbf434759d1896a7cf705e1c00e79 ]

Previous commit fixed checking of the ERR_PTR value returned by
drm_gem_shmem_get_sg_table(), but it missed to zero out the shmem->pages,
which will crash virtio_gpu_cleanup_object(). Add the missing zeroing of
the shmem->pages.

Fixes: c24968734abf ("drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init")
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-2-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index b38c338211aa..75a159df0af6 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -170,6 +170,7 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base);
+		shmem->pages = NULL;
 		return PTR_ERR(shmem->pages);
 	}
 
-- 
2.35.1



