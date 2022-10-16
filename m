Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E4460014B
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJPQ1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 12:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJPQ1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 12:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BEF9D
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1608560C36
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AC4C433D6;
        Sun, 16 Oct 2022 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665937589;
        bh=9Wa/BvxHuUh95GZp+RMGrb5X8Z672GxPoxCeKX0NqK8=;
        h=Subject:To:Cc:From:Date:From;
        b=xxZRpA2zD/NsnzPCvc/V/uVy7ZaJNXuSqjpxbrlnxuQRl4LFbGW9fpI3Ax9QASCPU
         h7h8U3/pG93r/pCzWIhNk3rm9kYQ+NgzRPAviq8pmtQkISBRgx2UDDs7ZJ1vQnLRZ6
         LPM9lUCVK3DpxhQLlj7mRtRe1ieC9otgrz5s3tuo=
Subject: FAILED: patch "[PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev() call" failed to apply to 5.19-stable tree
To:     jgg@ziepe.ca, alex.williamson@redhat.com, hch@lst.de,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 18:26:40 +0200
Message-ID: <16659376001082@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f423fa1bc9fe ("drm/i915/gvt: Add missing vfio_unregister_group_dev() call")
a5ddd2a99a7a ("drm/i915/gvt: Use the new device life cycle helpers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f423fa1bc9fe1978e6b9f54927411b62cb43eb04 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Thu, 29 Sep 2022 14:48:35 -0300
Subject: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev() call

When converting to directly create the vfio_device the mdev driver has to
put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
vfio_unregister_group_dev() in the remove.

This was missed for gvt, add it.

Cc: stable@vger.kernel.org
Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 41bba40feef8..9003145adb5a 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1615,6 +1615,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
 
+	vfio_unregister_group_dev(&vgpu->vfio_device);
 	vfio_put_device(&vgpu->vfio_device);
 }
 

