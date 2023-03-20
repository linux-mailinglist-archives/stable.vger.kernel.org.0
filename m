Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD8F6C183E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjCTPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjCTPWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ACD2A6C5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D2EC6157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A052C433D2;
        Mon, 20 Mar 2023 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325317;
        bh=dTqqnBtIoFk9VceyZ0w0v7RtRo8JyQSF6PysbcSkc5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvGenS9oKjUDT+pcAT5vWyA84RIZoR4ixfk5tolwsklmyzXh/Z2VTmHdXcDR5sfmG
         iS1/Dn7yrv8sBCslsAVDkje4H+zJXYFAKYgAYvWQN3YG4fkreS8+e8eWxNLgDmSLZh
         saME0CoZiFmWuwyt5XlARBGNMj8XKGOfBst0W0VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 5.15 090/115] drm/shmem-helper: Remove another errant put in error path
Date:   Mon, 20 Mar 2023 15:55:02 +0100
Message-Id: <20230320145453.189399602@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
@@ -591,11 +591,14 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
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
 
 	ret = drm_gem_shmem_get_pages(shmem);


