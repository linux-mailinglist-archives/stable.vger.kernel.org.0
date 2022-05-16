Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16495291E0
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347998AbiEPUGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348889AbiEPT7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD442BE;
        Mon, 16 May 2022 12:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B8C360A14;
        Mon, 16 May 2022 19:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DA9C385AA;
        Mon, 16 May 2022 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730715;
        bh=icSuAv8bKxjkgQCS0+EKtkHmPx2uqUq5zHY0/SpG3nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GETKMs2BitX4VKmCQ+NtIjxQo0CIrQJsrmwjUvUfzapn6yPjd91PUescJ07xM28bp
         jxyxEoS4ubQtk+hW0ORtP8+aRA1axJHAlo72nIGvulvSUSfppRHWWRvKbwQ0gpEw//
         DySGE6WBWQ4GsiBkAVx7xww3jXFDX+8FRcUakQp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 085/102] drm/nouveau/tegra: Stop using iommu_present()
Date:   Mon, 16 May 2022 21:36:59 +0200
Message-Id: <20220516193626.435644944@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 87fd2b091fb33871a7f812658a0971e8e26f903f upstream.

Even if some IOMMU has registered itself on the platform "bus", that
doesn't necessarily mean it provides translation for the device we
care about. Replace iommu_present() with a more appropriate check.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[added cc for stable]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org # v5.0+
Link: https://patchwork.freedesktop.org/patch/msgid/70d40ea441da3663c2824d54102b471e9a621f8a.1649168494.git.robin.murphy@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c
@@ -123,7 +123,7 @@ nvkm_device_tegra_probe_iommu(struct nvk
 
 	mutex_init(&tdev->iommu.mutex);
 
-	if (iommu_present(&platform_bus_type)) {
+	if (device_iommu_mapped(dev)) {
 		tdev->iommu.domain = iommu_domain_alloc(&platform_bus_type);
 		if (!tdev->iommu.domain)
 			goto error;


