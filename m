Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883446C186A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbjCTPYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjCTPXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B6634029
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97FB3B80E6F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F77CC433A0;
        Mon, 20 Mar 2023 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325416;
        bh=fKwRQx3/9sCFxAbi+E9QknKmOWeqSWL9Rq9UYTcIkNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHpU0X6wG9IPVAjucNPlcqDrjv6pdCaNEd+xJqD7xq1zdxe2nIEhEwxOp+rcF0YAY
         Z7U3CdFs+hBtbc/T0cCY9nWsybBFU6PU9wT1cpyz8U0wZJZtaNRcurAgyo3lc+Ku0v
         hsMMdjgYbgqxfiVQf5H5Xh5fXgEcl7bBx4PCOv7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gautam Dawar <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 041/211] vhost-vdpa: free iommu domain after last use during cleanup
Date:   Mon, 20 Mar 2023 15:52:56 +0100
Message-Id: <20230320145514.955523740@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautam Dawar <gautam.dawar@amd.com>

[ Upstream commit 5a522150093a0eabae9470a70a37a6e436bfad08 ]

Currently vhost_vdpa_cleanup() unmaps the DMA mappings by calling
`iommu_unmap(v->domain, map->start, map->size);`
from vhost_vdpa_general_unmap() when the parent vDPA driver doesn't
provide DMA config operations.

However, the IOMMU domain referred to by `v->domain` is freed in
vhost_vdpa_free_domain() before vhost_vdpa_cleanup() in
vhost_vdpa_release() which results in NULL pointer de-reference.
Accordingly, moving the call to vhost_vdpa_free_domain() in
vhost_vdpa_cleanup() would makes sense. This will also help
detaching the dma device in error handling of vhost_vdpa_alloc_domain().

This issue was observed on terminating QEMU with SIGQUIT.

Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
Message-Id: <20230301163203.29883-1-gautam.dawar@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f785dfdec..b7657984dd8df 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1134,6 +1134,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 
 err_attach:
 	iommu_domain_free(v->domain);
+	v->domain = NULL;
 	return ret;
 }
 
@@ -1178,6 +1179,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 			vhost_vdpa_remove_as(v, asid);
 	}
 
+	vhost_vdpa_free_domain(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 }
@@ -1250,7 +1252,6 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
-- 
2.39.2



