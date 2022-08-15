Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9C594765
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbiHOXYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbiHOXWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:22:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC50148E83;
        Mon, 15 Aug 2022 13:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B0CEB810C5;
        Mon, 15 Aug 2022 20:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CF9C433C1;
        Mon, 15 Aug 2022 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593926;
        bh=8wmv2mpi8sUIIu/K8J/rRbiyFnvYWdh1DOEZEe1g1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVkWcV6pdTSl+Mxe0eL1ihUuJ4ZCVXN9uXuvXhIgsaIk9Slb4MYnY3Q4Fcd7DOwEU
         gdj4ERtTOdoocw6fkASQC6RH3S5uesIHdlZF52HITA1zSaS+SnfiHHlDYcasc4M7JR
         A3DrPirDVMiTWZb6LKuRoWkAxxq6Aj43qIAthTNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0349/1157] drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init
Date:   Mon, 15 Aug 2022 19:55:05 +0200
Message-Id: <20220815180453.676436520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



