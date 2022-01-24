Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B91349A2F5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366056AbiAXXwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843795AbiAXXGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:06:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAE7C06E035;
        Mon, 24 Jan 2022 13:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C217B61320;
        Mon, 24 Jan 2022 21:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9853CC340E5;
        Mon, 24 Jan 2022 21:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059033;
        bh=jD2m76gJr8SX4WVu10homi6mG4H+RudfTZtcaIyUIs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAUuAApCIfiVP6w82P88Yd0DVqeC5pguIGejrWRW+b6KV0FBHMMkl0AV94GRnmGmz
         I7qZLDHDQokZhg4V7QazB2E506/ki3sARU5pSTNG1ljuGOuVgO+i7ZRzGNg79Ty0QL
         39+nS8lnjRR3O0YBkAT5G8NQBeV1D7ihOztCz8Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashish Mhetre <amhetre@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0475/1039] iommu: Extend mutex lock scope in iommu_probe_device()
Date:   Mon, 24 Jan 2022 19:37:44 +0100
Message-Id: <20220124184141.239324386@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index dd7863e453a5f..8b86406b71627 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -288,11 +288,11 @@ int iommu_probe_device(struct device *dev)
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
@@ -300,6 +300,7 @@ int iommu_probe_device(struct device *dev)
 
 	iommu_create_device_direct_mappings(group, dev);
 
+	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
 
 	if (ops->probe_finalize)
-- 
2.34.1



