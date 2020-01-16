Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C413FFD9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390789AbgAPXVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389488AbgAPXVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F85F2072B;
        Thu, 16 Jan 2020 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216875;
        bh=OJr/ByO9TRbCM9xgvCxyO58tS8jx1apSCf0bS3fx80w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLgBwiULRTiBv0MYfwQiilXs79t29C1de+YxvK8xA1miMW1116+GGrZU493kjcA7C
         bnqwyzZjfm9ZGmvI5psbynaaEc4sOp5enXxh4QU7Echw08YlucTRpOrAEEWwrNBbVQ
         cHSX1duwovQegvgVHKB8c0s6W3dmFhSmJ4bqLpdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH 5.4 029/203] drm/tegra: Fix ordering of cleanup code
Date:   Fri, 17 Jan 2020 00:15:46 +0100
Message-Id: <20200116231746.894208763@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit 051172e8c1ceef8749f19faacc1d3bef65d20d8d upstream.

Commit Fixes: b9f8b09ce256 ("drm/tegra: Setup shared IOMMU domain after
initialization") changed the initialization order of the IOMMU related
bits but didn't update the cleanup path accordingly. This asymmetry can
cause failures during error recovery.

Fixes: b9f8b09ce256 ("drm/tegra: Setup shared IOMMU domain after initialization")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tegra/drm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -201,19 +201,19 @@ hub:
 	if (tegra->hub)
 		tegra_display_hub_cleanup(tegra->hub);
 device:
-	host1x_device_exit(device);
-fbdev:
-	drm_kms_helper_poll_fini(drm);
-	tegra_drm_fb_free(drm);
-config:
-	drm_mode_config_cleanup(drm);
-
 	if (tegra->domain) {
 		mutex_destroy(&tegra->mm_lock);
 		drm_mm_takedown(&tegra->mm);
 		put_iova_domain(&tegra->carveout.domain);
 		iova_cache_put();
 	}
+
+	host1x_device_exit(device);
+fbdev:
+	drm_kms_helper_poll_fini(drm);
+	tegra_drm_fb_free(drm);
+config:
+	drm_mode_config_cleanup(drm);
 domain:
 	if (tegra->domain)
 		iommu_domain_free(tegra->domain);


