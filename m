Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282F45941BE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiHOU7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245616AbiHOU5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F78CC0E70;
        Mon, 15 Aug 2022 12:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61E8960ED3;
        Mon, 15 Aug 2022 19:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582FAC433D6;
        Mon, 15 Aug 2022 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590748;
        bh=8wmv2mpi8sUIIu/K8J/rRbiyFnvYWdh1DOEZEe1g1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y81LozF5T9LYLXNL91gSztuxk/cASvtFHEpXXY/1vBcMqjsJPpIuzi5gKsiRn9xOg
         g4YpGR5J3I46apOv6o1w0gsoU1aDB7k0Mm5rtCjn/p1hwBdI/u3ssspD/3OwYaNHbh
         NS8KWJBLvFMI71pZCSQ9G+Jh4f+QMnpHeh6jea9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0331/1095] drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init
Date:   Mon, 15 Aug 2022 19:55:30 +0200
Message-Id: <20220815180443.479575554@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c24968734abfed81c8f93dc5f44a7b7a9aecadfa ]

Since drm_prime_pages_to_sg() function return error pointers.
The drm_gem_shmem_get_sg_table() function returns error pointers too.
Using IS_ERR() to check the return value to fix this.

Fixes: 2f2aa13724d5 ("drm/virtio: move virtio_gpu_mem_entry initialization to new function")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220602104223.54527-1-linmq006@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index f293e6ad52da..1cc8f3fc8e4b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -168,9 +168,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	 * since virtio_gpu doesn't support dma-buf import from other devices.
 	 */
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
-	if (!shmem->pages) {
+	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base);
-		return -EINVAL;
+		return PTR_ERR(shmem->pages);
 	}
 
 	if (use_dma_api) {
-- 
2.35.1



