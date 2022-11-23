Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A3635D86
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiKWMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237540AbiKWMpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:45:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C475FEE;
        Wed, 23 Nov 2022 04:42:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06E55B81F3E;
        Wed, 23 Nov 2022 12:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7477FC433D7;
        Wed, 23 Nov 2022 12:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207349;
        bh=aCp8+W1vq+4bqUwPUMzZWAq6fNpuSN7uJOHHHGArPH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6/BsI4qa9OusF1c6NxM5QASGzPfB1JM1zL7H7FobsWj4iSwwX7IF7sz+4LnePkgi
         08SwHRZAitGaqfBBaTfkt/q4v9yxE8SKjblqfhK8J6m+cYM80uaPHsl6I8E8nhjUfF
         7VaV4+UZEmCoCOk0jl4ZcYzoYo/PUKDipwVaxSA+T8oEAuinBNa6Qld/LnFNcMc1Nq
         c1XGBqwNIM4QZkOLFLhDIQCEjR5/hrMF025lRyH8tcGfWrqKBx110GvZEahhF5Wewd
         Qytm6i/wFUep/kZoUYhBP5R7Cdy6zVjk7rKbt9b/cvxjOeuy92a8auiF/2fklyR5Rg
         1Shg1vVADECxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 42/44] gpu: host1x: Avoid trying to use GART on Tegra20
Date:   Wed, 23 Nov 2022 07:40:51 -0500
Message-Id: <20221123124057.264822-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit c2418f911a31a266af4fbaca998dc73d3676475a ]

Since commit c7e3ca515e78 ("iommu/tegra: gart: Do not register with
bus") quite some time ago, the GART driver has effectively disabled
itself to avoid issues with the GPU driver expecting it to work in ways
that it doesn't. As of commit 57365a04c921 ("iommu: Move bus setup to
IOMMU device registration") that bodge no longer works, but really the
GPU driver should be responsible for its own behaviour anyway. Make the
workaround explicit.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Suggested-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/drm.c | 4 ++++
 drivers/gpu/host1x/dev.c    | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 6748ec1e0005..a1f909dac89a 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1093,6 +1093,10 @@ static bool host1x_drm_wants_iommu(struct host1x_device *dev)
 	struct host1x *host1x = dev_get_drvdata(dev->dev.parent);
 	struct iommu_domain *domain;
 
+	/* Our IOMMU usage policy doesn't currently play well with GART */
+	if (of_machine_is_compatible("nvidia,tegra20"))
+		return false;
+
 	/*
 	 * If the Tegra DRM clients are backed by an IOMMU, push buffers are
 	 * likely to be allocated beyond the 32-bit boundary if sufficient
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 0cd3f97e7e49..f60ea24db0ec 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -292,6 +292,10 @@ static void host1x_setup_virtualization_tables(struct host1x *host)
 
 static bool host1x_wants_iommu(struct host1x *host1x)
 {
+	/* Our IOMMU usage policy doesn't currently play well with GART */
+	if (of_machine_is_compatible("nvidia,tegra20"))
+		return false;
+
 	/*
 	 * If we support addressing a maximum of 32 bits of physical memory
 	 * and if the host1x firewall is enabled, there's no need to enable
-- 
2.35.1

