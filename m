Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABB54D842C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiCNMXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241974AbiCNMSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606E53B54F;
        Mon, 14 Mar 2022 05:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99F0D604F5;
        Mon, 14 Mar 2022 12:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42FCC340E9;
        Mon, 14 Mar 2022 12:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259997;
        bh=lGPb0eTPAC6Pfa3pqaF5GqG7LBkpa0wzfQC8LFD6BxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCO3mXDt3Lbet3J8iT3i4tkFKng7f8iqTupIu0WUYS8Y5GoqgG8mnJXOOXspVp/LN
         Asv6mU+RG6kilB9ARxmUKTLkZ9iySE0vj6q/QNPKDYYKvJNmYGkh98TYtDfpUD2iyl
         yB/XwWT8BMA/fBQ74lkAAe1tjlnJbqVbn8o1os0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Min <zhang.min9@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 020/121] vdpa: fix use-after-free on vp_vdpa_remove
Date:   Mon, 14 Mar 2022 12:53:23 +0100
Message-Id: <20220314112744.692628352@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Min <zhang.min9@zte.com.cn>

[ Upstream commit eb057b44dbe35ae14527830236a92f51de8f9184 ]

When vp_vdpa driver is unbind, vp_vdpa is freed in vdpa_unregister_device
and then vp_vdpa->mdev.pci_dev is dereferenced in vp_modern_remove,
triggering use-after-free.

Call Trace of unbinding driver free vp_vdpa :
do_syscall_64
  vfs_write
    kernfs_fop_write_iter
      device_release_driver_internal
        pci_device_remove
          vp_vdpa_remove
            vdpa_unregister_device
              kobject_release
                device_release
                  kfree

Call Trace of dereference vp_vdpa->mdev.pci_dev:
vp_modern_remove
  pci_release_selected_regions
    pci_release_region
      pci_resource_len
        pci_resource_end
          (dev)->resource[(bar)].end

Signed-off-by: Zhang Min <zhang.min9@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Link: https://lore.kernel.org/r/20220301091059.46869-1-wang.yi59@zte.com.cn
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 64b9f64f80a6 ("vdpa: introduce virtio pci driver")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index e3ff7875e123..fab161961160 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -525,8 +525,8 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
 {
 	struct vp_vdpa *vp_vdpa = pci_get_drvdata(pdev);
 
-	vdpa_unregister_device(&vp_vdpa->vdpa);
 	vp_modern_remove(&vp_vdpa->mdev);
+	vdpa_unregister_device(&vp_vdpa->vdpa);
 }
 
 static struct pci_driver vp_vdpa_driver = {
-- 
2.34.1



