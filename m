Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12326B4B10
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbjCJPaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbjCJP3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:29:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D159D9B2C3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:18:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83DC9B82319
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD086C4339E;
        Fri, 10 Mar 2023 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461445;
        bh=AvUKvCQs9KpHmnXHhCG0uNA02Idm89s59O/h1EIuD5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaNatbdNy3V42Y2qjq8lMejG+fh/s2a04buvcYL27bpmx9QrEF26b/tWcszHhMFpW
         m1rkJCCnNVea1wKqTyq2er5DYSD0lN8gLP+z0YXomMUqXP01UuINGfF2VcjoBQQNi1
         MBs0GXuYuPS6RnZCU1emcQzrMGtXETTvNQ7R5xfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "kraxel@redhat.com, linux-kernel@vger.kernel.org,
        emil.l.velikov@gmail.com, airlied@linux.ie, error27@gmail.com,
        darren.kenny@oracle.com, vegard.nossum@oracle.com, Harshit Mogalapalli" 
        <harshit.m.mogalapalli@oracle.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 130/136] drm/virtio: Fix error code in virtio_gpu_object_shmem_init()
Date:   Fri, 10 Mar 2023 14:44:12 +0100
Message-Id: <20230310133711.161611575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

In virtio_gpu_object_shmem_init() we are passing NULL to PTR_ERR, which
is returning 0/success.

Fix this by storing error value in 'ret' variable before assigning
shmem->pages to NULL.

Found using static analysis with Smatch.

Fixes: 64b88afbd92f ("drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -169,8 +169,9 @@ static int virtio_gpu_object_shmem_init(
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {


