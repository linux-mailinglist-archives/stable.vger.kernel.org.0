Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0F8608656
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiJVHsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiJVHrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E11645F5;
        Sat, 22 Oct 2022 00:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8072460B1F;
        Sat, 22 Oct 2022 07:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90437C433D6;
        Sat, 22 Oct 2022 07:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424310;
        bh=ZizTAglFEXVj37CKMUyIA+z7OphHdSQB1tjv3W2T0vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq2lKnRvqHF7ZQBEfgizfMakPYBy3aw873pMpdlP2KZ94JWuWuCmrhlWs7Yv2nByy
         CR4VWitAMrORgHSg5xcw3fkxed5z0j9oIEGyFyVoRSSO5dElW8D/pxTQBkRdAbG8LC
         aiLy3UPaHPURfhCiLU2ieOoEeq+En1Iw3FJLuRh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emil Velikov <emil.l.velikov@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.19 068/717] drm/virtio: Unlock reservations on virtio_gpu_object_shmem_init() error
Date:   Sat, 22 Oct 2022 09:19:07 +0200
Message-Id: <20221022072427.171090730@linuxfoundation.org>
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
@@ -248,6 +248,8 @@ int virtio_gpu_object_create(struct virt
 
 	ret = virtio_gpu_object_shmem_init(vgdev, bo, &ents, &nents);
 	if (ret != 0) {
+		if (fence)
+			virtio_gpu_array_unlock_resv(objs);
 		virtio_gpu_array_put_free(objs);
 		virtio_gpu_free_object(&shmem_obj->base);
 		return ret;


