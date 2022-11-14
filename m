Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE8A627F95
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbiKNNAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbiKNNAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC0128706
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B42E61154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39497C433C1;
        Mon, 14 Nov 2022 13:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430834;
        bh=aVObdXlgRr1dGfhokV0cmM9KrKjXES3RKywx0o4U5WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AephgfrjD1NwhVu7VPRb8FVY5JvlvmTlvLKSr9xGuq/nzcxxTG2M+mMFL9KRqb3fy
         sZ7mY2EFcHjQ8VykFjJMC7TDF8LCF7zWshZeiTMQHROJ20WRiKluoDxduHxTydn9lL
         2UQoDTAjCbVrXGuX8/b85vJiS5xO30ITjf6ykNtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.0 002/190] drm/i915/gvt: Add missing vfio_unregister_group_dev() call
Date:   Mon, 14 Nov 2022 13:43:46 +0100
Message-Id: <20221114124458.911937352@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit f423fa1bc9fe1978e6b9f54927411b62cb43eb04 upstream.

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
Reviewed-by: Kevin Tian <kevin.tian@intel.com> # v6.0 backport
Signed-off-by: Alex Williamson <alex.williamson@redhat.com> # v6.0 backport
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1595,6 +1595,9 @@ static void intel_vgpu_remove(struct mde
 
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
+
+	vfio_unregister_group_dev(&vgpu->vfio_device);
+	vfio_uninit_group_dev(&vgpu->vfio_device);
 	intel_gvt_destroy_vgpu(vgpu);
 }
 


