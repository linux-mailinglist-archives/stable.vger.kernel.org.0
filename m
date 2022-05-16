Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DFA528FD4
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346670AbiEPULq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351071AbiEPUB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370354756C;
        Mon, 16 May 2022 12:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3651B81615;
        Mon, 16 May 2022 19:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A89C385AA;
        Mon, 16 May 2022 19:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731081;
        bh=icSuAv8bKxjkgQCS0+EKtkHmPx2uqUq5zHY0/SpG3nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8r+6b23J+ks/buIbvFEYKhI5lnGJ+jWGRVkfbUGaFwDN33nHO0WOe1FViCdWWu6m
         xsXJ4oswfxgZ1AeiUVzBDZt38uNQWOGpi6misdfqsvXFNgv8TS9lbdzdU+L4AfJ5AK
         PI8MqDL7VzgTMJ1zu1bvWq8cLk6z5uu/6UOhCMpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.17 097/114] drm/nouveau/tegra: Stop using iommu_present()
Date:   Mon, 16 May 2022 21:37:11 +0200
Message-Id: <20220516193628.259867940@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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


