Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6C06C1763
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjCTPN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjCTPM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:12:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00C830184
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61EEAB80EBE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFD0C433A7;
        Mon, 20 Mar 2023 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324879;
        bh=ZhaUodvzaDk3q7HsrMkxCOwmfxIXplRMFxAl/Yr7aF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYVTIfx0N/WLd6uEixAnj6zSsUFaNxXxC3sdtb3XTaKqxghoPAvGbW+WZXeUYiaBR
         lKXBVDarRDNcAwP6FcaJC/OrgYEz6jORu3qvmP9si/oonnOE88ED9T795MKprjgFxI
         zLPJ5OkIxpQzXVihxhpiP3hd4CZe6Ihqs+VHW+pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 5.10 68/99] drm/shmem-helper: Remove another errant put in error path
Date:   Mon, 20 Mar 2023 15:54:46 +0100
Message-Id: <20230320145446.245023165@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit ee9adb7a45516cfa536ca92253d7ae59d56db9e4 upstream.

drm_gem_shmem_mmap() doesn't own reference in error code path, resulting
in the dma-buf shmem GEM object getting prematurely freed leading to a
later use-after-free.

Fixes: f49a51bfdc8e ("drm/shme-helpers: Fix dma_buf_mmap forwarding bug")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230108211311.3950107-1-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -614,11 +614,14 @@ int drm_gem_shmem_mmap(struct drm_gem_ob
 	int ret;
 
 	if (obj->import_attach) {
-		/* Drop the reference drm_gem_mmap_obj() acquired.*/
-		drm_gem_object_put(obj);
 		vma->vm_private_data = NULL;
+		ret = dma_buf_mmap(obj->dma_buf, vma, 0);
+
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		if (!ret)
+			drm_gem_object_put(obj);
 
-		return dma_buf_mmap(obj->dma_buf, vma, 0);
+		return ret;
 	}
 
 	shmem = to_drm_gem_shmem_obj(obj);


