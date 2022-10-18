Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C5601EBD
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiJRAMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiJRAKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E1D88DF5;
        Mon, 17 Oct 2022 17:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2950B61314;
        Tue, 18 Oct 2022 00:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F727C433D7;
        Tue, 18 Oct 2022 00:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051734;
        bh=MYsXPCCZudwVdMZHgFFQW2l401Y+tXJbW6caoYc4ohE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+2BYc6fywgJi/EV4UJ6395U56JGi6Gc7TGgvnNRluriwwEub6emL2YjYTEyttUuu
         b+e3jbwpX9W7WOlk0BvHIOFv8OObdhX5h9HkPv9piggo1r5mBznnK1u2M6zKtuzK9Q
         PdzwjAAKQICVCiTkC1Gy2n0MQR5tBPETUNxRWDhi9HHeYzkV1o13KW2+LgXUJzzqOs
         AYDfmrGgPQBDnlEuqC6w//dEzUqGqoRgQKHcrh3+itYFHrczzMM4LuaWNhDBxv9dzi
         CKFWmGpTxxkiOQvNFAqAkwxqBJ74rnb1fswkEaQX2p3Gs/Xf255DfsTFTY3gWBjjir
         rjAKbdDzs1+Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, dwmw2@infradead.org,
        baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
        iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 07/29] iommu/vt-d: Handle race between registration and device probe
Date:   Mon, 17 Oct 2022 20:08:16 -0400
Message-Id: <20221018000839.2730954-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000839.2730954-1-sashal@kernel.org>
References: <20221018000839.2730954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit c919739ce4721ecf7b96b99253b032df30fcf19b ]

Currently we rely on registering all our instances before initially
allowing any .probe_device calls via bus_set_iommu(). In preparation for
phasing out the latter, make sure we won't inadvertently return success
for a device associated with a known but not yet registered instance,
otherwise we'll run straight into iommu_group_get_for_dev() trying to
use NULL ops.

That also highlights an issue with intel_iommu_get_resv_regions() taking
dmar_global_lock from within a section where intel_iommu_init() already
holds it, which already exists via probe_acpi_namespace_devices() when
an ANDD device is probed, but gets more obvious with the upcoming change
to iommu_device_register(). Since they are both read locks it manages
not to deadlock in practice, and a more in-depth rework of this locking
is underway, so no attempt is made to address it here.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/579f2692291bcbfc3ac64f7456fcff0d629af131.1660572783.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3ed15e8ca677..690fad0d37f8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4586,7 +4586,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 	u8 bus, devfn;
 
 	iommu = device_to_iommu(dev, &bus, &devfn);
-	if (!iommu)
+	if (!iommu || !iommu->iommu.ops)
 		return ERR_PTR(-ENODEV);
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-- 
2.35.1

