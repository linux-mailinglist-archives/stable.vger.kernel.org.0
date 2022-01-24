Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2359D499B56
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575121AbiAXVvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572913AbiAXVmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBEEC0419E1;
        Mon, 24 Jan 2022 12:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38D54B81253;
        Mon, 24 Jan 2022 20:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5116EC340E5;
        Mon, 24 Jan 2022 20:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056289;
        bh=jI6jJQ1Hx8HqSkH0QXPdw56p5o+wSAGat7bHGfPaK7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1A7Yx2o+CMfPmWYurRzAIP+5emPI9XjWss5z9BElm7HPqSgTQNpZfnaB67kUEp8Yy
         wwJezy/mgGeX0rlurzMIgH6XEcCWcmW1gOZmid0l9pDJg5TWR/3RYeKv/l75JDSWsb
         m3j9aUgvAVYdV5sA7JSEEj9VGBVS2p4p+8BWeoQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashish Mhetre <amhetre@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/846] iommu: Extend mutex lock scope in iommu_probe_device()
Date:   Mon, 24 Jan 2022 19:38:39 +0100
Message-Id: <20220124184114.828786411@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 556f99ac886635e8da15528995f06d1d7028cfca ]

Extend the scope of holding group->mutex so that it can cover the default
domain check/attachment and direct mappings of reserved regions.

Cc: Ashish Mhetre <amhetre@nvidia.com>
Fixes: 211ff31b3d33b ("iommu: Fix race condition during default domain allocation")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20211108061349.1985579-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3303d707bab4b..f62fb6a58f109 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -287,11 +287,11 @@ int iommu_probe_device(struct device *dev)
 	 */
 	mutex_lock(&group->mutex);
 	iommu_alloc_default_domain(group, dev);
-	mutex_unlock(&group->mutex);
 
 	if (group->default_domain) {
 		ret = __iommu_attach_device(group->default_domain, dev);
 		if (ret) {
+			mutex_unlock(&group->mutex);
 			iommu_group_put(group);
 			goto err_release;
 		}
@@ -299,6 +299,7 @@ int iommu_probe_device(struct device *dev)
 
 	iommu_create_device_direct_mappings(group, dev);
 
+	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
 
 	if (ops->probe_finalize)
-- 
2.34.1



