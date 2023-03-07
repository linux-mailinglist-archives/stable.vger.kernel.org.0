Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A050C6AED77
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCGSE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCGSEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:04:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F733A4036
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:57:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AC40B819A6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46683C433D2;
        Tue,  7 Mar 2023 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211819;
        bh=A+L2d0s5qEvlJy5SZd8aXbR52n2VR5daQ8naEPogjco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5DDUmGcgg6/wSBUDGih4KAoZoie9SNaIXsonhf/grkjGhb0j6T9kA/48D+xEKqFe
         UwU/pz6N0y8ExwghZoH5CH0GXl1YFOVQxgXP/MwvZNyWqYZOKZ0hdQBJaQ95X3DD0E
         YdkrYsnaqLlns0QT7aJmkMxTz8GA68IFvl3aVO6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.2 0987/1001] iommufd: Do not add the same hwpt to the ioas->hwpt_list twice
Date:   Tue,  7 Mar 2023 18:02:39 +0100
Message-Id: <20230307170105.077566205@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit b4ff830eca097df51af10a9be29e8cc817327919 upstream.

The hwpt is added to the hwpt_list only during its creation, it is never
added again. This hunk is some missed leftover from rework. Adding it
twice will corrupt the linked list in some cases.

It effects HWPT specific attachment, which is something the test suite
cannot cover until we can create a legitimate struct device with a
non-system iommu "driver" (ie we need the bus removed from the iommu code)

Cc: stable@vger.kernel.org
Fixes: e8d57210035b ("iommufd: Add kAPI toward external drivers for physical devices")
Link: https://lore.kernel.org/r/1-v1-4336b5cb2fe4+1d7-iommufd_hwpt_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -346,10 +346,6 @@ int iommufd_device_attach(struct iommufd
 		rc = iommufd_device_do_attach(idev, hwpt);
 		if (rc)
 			goto out_put_pt_obj;
-
-		mutex_lock(&hwpt->ioas->mutex);
-		list_add_tail(&hwpt->hwpt_item, &hwpt->ioas->hwpt_list);
-		mutex_unlock(&hwpt->ioas->mutex);
 		break;
 	}
 	case IOMMUFD_OBJ_IOAS: {


