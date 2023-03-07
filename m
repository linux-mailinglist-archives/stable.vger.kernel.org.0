Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8856AEEA1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjCGSNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjCGSNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED9F738BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C44961523
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C468C433A0;
        Tue,  7 Mar 2023 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212553;
        bh=6UUeGEX5GlhzaR1SlSF1KWn04741UKjkHzpSXTw1kj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6+qOlnIK9c/SQx1434BPy/EDJDpwxOdbO0In5E8VSJRY7/n0ScDXSdNwEydz1RYu
         YVD5ufjCtCYwzDhGhDKN27RDXl3uJHz1C6YBgrm0qQYHRSTqOT7CsPICqeGyLsNwgz
         BAAB6AaaSeXKZ8gVr4JGL5f/YlqLAMiX3FgxrGxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Viresh Kumar <viresh.kumar@linaro.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/885] xen/grant-dma-iommu: Implement a dummy probe_device() callback
Date:   Tue,  7 Mar 2023 17:52:35 +0100
Message-Id: <20230307170011.685160180@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>

[ Upstream commit 2062f9fb6445451b189595e295765c69f43bc12e ]

Update stub IOMMU driver (which main purpose is to reuse generic
IOMMU device-tree bindings by Xen grant DMA-mapping layer on Arm)
according to the recent changes done in the following
commit 57365a04c921 ("iommu: Move bus setup to IOMMU device registration").

With probe_device() callback being called during IOMMU device registration,
the uninitialized callback just leads to the "kernel NULL pointer
dereference" issue during boot. Fix that by adding a dummy callback.

Looks like the release_device() callback is not mandatory to be
implemented as IOMMU framework makes sure that callback is initialized
before dereferencing.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Signed-off-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20230208153649.3604857-1-olekstysh@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-dma-iommu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-dma-iommu.c b/drivers/xen/grant-dma-iommu.c
index 16b8bc0c0b33d..6a9fe02c6bfcc 100644
--- a/drivers/xen/grant-dma-iommu.c
+++ b/drivers/xen/grant-dma-iommu.c
@@ -16,8 +16,15 @@ struct grant_dma_iommu_device {
 	struct iommu_device iommu;
 };
 
-/* Nothing is really needed here */
-static const struct iommu_ops grant_dma_iommu_ops;
+static struct iommu_device *grant_dma_iommu_probe_device(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+/* Nothing is really needed here except a dummy probe_device callback */
+static const struct iommu_ops grant_dma_iommu_ops = {
+	.probe_device = grant_dma_iommu_probe_device,
+};
 
 static const struct of_device_id grant_dma_iommu_of_match[] = {
 	{ .compatible = "xen,grant-dma" },
-- 
2.39.2



