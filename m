Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4D60B902
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiJXT77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiJXT7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53129172B54;
        Mon, 24 Oct 2022 11:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3112B81730;
        Mon, 24 Oct 2022 12:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC4AC433D6;
        Mon, 24 Oct 2022 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614920;
        bh=Sv1I4qRxsNAcOAYNJeyF0HrhTXqVyHtQl4EVlTTTgHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6TeQjSwfq1shbb/1M18uW+8i/Si8gm0p3fsB570tZZuL6yCUDLlrflLL1b8yCyKK
         E13eIlouSGqXGCNuzHzTFn3X/kUa4X2J42/rcs7AFS0W2dTk9HQMqXpKVIjZVI6c1l
         ZiuFKHX4xzD3c8/lhvrT6H8+NsC43hARBdyubMcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emil Velikov <emil.l.velikov@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.15 053/530] drm/virtio: Unlock reservations on virtio_gpu_object_shmem_init() error
Date:   Mon, 24 Oct 2022 13:26:37 +0200
Message-Id: <20221024113047.430780121@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

commit fdf0ff4d12cbcd76b53f27c96ce51ddca400884a upstream.

Unlock reservations in the error code path of virtio_gpu_object_create()
to silence debug warning splat produced by ww_mutex_destroy(&obj->lock)
when GEM is released with the held lock.

Cc: stable@vger.kernel.org
Fixes: 30172efbfb84 ("drm/virtio: blob prep: refactor getting pages and attaching backing")
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-4-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -247,6 +247,8 @@ int virtio_gpu_object_create(struct virt
 
 	ret = virtio_gpu_object_shmem_init(vgdev, bo, &ents, &nents);
 	if (ret != 0) {
+		if (fence)
+			virtio_gpu_array_unlock_resv(objs);
 		virtio_gpu_array_put_free(objs);
 		virtio_gpu_free_object(&shmem_obj->base);
 		return ret;


