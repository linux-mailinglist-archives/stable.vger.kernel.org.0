Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270BA2A5808
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbgKCVr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbgKCUvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31D7520719;
        Tue,  3 Nov 2020 20:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436671;
        bh=wy10irmcQSAMQddqzmPHl+tca+hIUrh+n/muGSdINOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXmiWDa6ZVkC+rgEf9LF9AhqIC9sarAolVihTneI1jnApPrc5AFoc9pwQNNMBakYt
         YcO1BJcpw7N/y9qWrRmARoHNDcIW18m3o26YPTruHi6ZoU8ewgUE4XQY9/qlhmg7Z0
         cnOZFv6F4Hfek6V/Wus7v7+DZB0/od5Ki2vUysPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matias Zuniga <matias.nicolas.zc@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.9 353/391] memory: tegra: Remove GPU from DRM IOMMU group
Date:   Tue,  3 Nov 2020 21:36:44 +0100
Message-Id: <20201103203410.956450253@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit ea90f66f2a8629dde07328df0b8314aae5e54a47 upstream.

Commit 63a613fdb16c ("memory: tegra: Add gr2d and gr3d to DRM IOMMU
group") added the GPU to the DRM IOMMU group, which doesn't make any
sense. This causes problems when Nouveau tries to attach to the SMMU
and causes it to fall back to using the DMA API.

Remove the GPU from the DRM groups to restore the old behaviour. The
GPU should always have its own IOMMU domain to make sure it can map
buffers into contiguous chunks (for big page support) without getting
in the way of mappings from the DRM group.

Cc: <stable@vger.kernel.org>
Fixes: 63a613fdb16c ("memory: tegra: Add gr2d and gr3d to DRM IOMMU group")
Reported-by: Matias Zuniga <matias.nicolas.zc@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200901153248.1831263-1-thierry.reding@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/tegra/tegra124.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/memory/tegra/tegra124.c
+++ b/drivers/memory/tegra/tegra124.c
@@ -957,7 +957,6 @@ static const struct tegra_smmu_swgroup t
 static const unsigned int tegra124_group_drm[] = {
 	TEGRA_SWGROUP_DC,
 	TEGRA_SWGROUP_DCB,
-	TEGRA_SWGROUP_GPU,
 	TEGRA_SWGROUP_VIC,
 };
 


