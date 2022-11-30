Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3059363DEE0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiK3Slo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiK3Sl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:41:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B569894D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F2B761D41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66945C433C1;
        Wed, 30 Nov 2022 18:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833685;
        bh=GcXlIGsa+nuE2ry+v6H1EZ8MlBMsb6KWVkWdNb6emWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5i7jSRZXngKrPWE87vnyXrLd8xvDtwtz+VcJqWyMAUq1Ids5UvYnIuTRC29TBLb8
         qQ+0rv0cVV7SxCi9bAOLlJcllnJKHH/dRfjxK1rPyCzHGw6o70wAl23LEkgJouynwR
         tqkyKnK3AdxMKRGKpgXADg7niEuDI2pVQLu5+6uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Hunter <jonathanh@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/206] gpu: host1x: Avoid trying to use GART on Tegra20
Date:   Wed, 30 Nov 2022 19:23:56 +0100
Message-Id: <20221130180537.699239392@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index 611cd8dad46e..4f5affdc6080 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1083,6 +1083,10 @@ static bool host1x_drm_wants_iommu(struct host1x_device *dev)
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
index fc9f54282f7d..c2a4bf2aae61 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -204,6 +204,10 @@ static void host1x_setup_sid_table(struct host1x *host)
 
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



