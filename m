Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB062377A
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 00:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKIXcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 18:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiKIXcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 18:32:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F3FDFAD
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 15:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668036710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VKb0yqlHuuiqnjOM8t/MVYtySveXtep2J/zhrccl5po=;
        b=MCOosD4AfkCPMRtvvyvSE+0mFzVYF9G8uib28hPrxZ3kgwWUM1Jcbi1LM+PFckJVAVdv28
        7YdD2Jgk0UHAzcUAr/xvYbfdntsB5i6JHWWEuATq5NWcTFIqwYEbspGZNwo6LKSSV053c4
        mLURhURaMWLSTfLFd60tXjKaNp22ASs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-10Xv09NBOUCItqQF88WyhQ-1; Wed, 09 Nov 2022 18:31:46 -0500
X-MC-Unique: 10Xv09NBOUCItqQF88WyhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32120101246B;
        Wed,  9 Nov 2022 23:31:46 +0000 (UTC)
Received: from [172.30.42.193] (unknown [10.22.17.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B0F540C83AA;
        Wed,  9 Nov 2022 23:31:45 +0000 (UTC)
Subject: [PATCH 6.0] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
From:   Alex Williamson <alex.williamson@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com, hch@lst.de, sashal@kernel.org
Date:   Wed, 09 Nov 2022 16:31:45 -0700
Message-ID: <166803668167.3399708.615075636176057580.stgit@omen>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit  f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]

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
---
 drivers/gpu/drm/i915/gvt/kvmgt.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e3cd58946477..de89946c4817 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1595,6 +1595,9 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
+
+	vfio_unregister_group_dev(&vgpu->vfio_device);
+	vfio_uninit_group_dev(&vgpu->vfio_device);
 	intel_gvt_destroy_vgpu(vgpu);
 }
 


