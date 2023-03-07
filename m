Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787CD6AF02D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbjCGS3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjCGS2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:28:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A3F9FBC3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:21:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FB90614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28501C433D2;
        Tue,  7 Mar 2023 18:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213291;
        bh=u36mYcw1f4GnayqJFF+k3Zx4K3R6//a/CI16mtdXDDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4MXZV4nz78xf7Q0PPezsX+OtvFaTgLqzxTQhChIcrVuemjnE7RF06XhIz/qcNLvb
         kZJggMg777Xu86b4n/6vdvcedJ1NtLzxeUhom9F2Q9DdHddvs0kQUVJ24gDv+j21o8
         D4tLWqZ8wB92JLFQYw7ilLZpeandMtnE87GnObZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Eric Curtin <ecurtin@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 460/885] iommu/dart: Fix apple_dart_device_group for PCI groups
Date:   Tue,  7 Mar 2023 17:56:34 +0100
Message-Id: <20230307170022.486331968@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit cf5c1c87c2391649e05e58ecc6dfc3dc5ebebc05 ]

pci_device_group() can return an already existing IOMMU group if the PCI
device's pagetables have to be shared with another one due to bus
toplogy, isolation features and/or DMA alias quirks.
apple_dart_device_group() however assumes that the group has just been
created and overwrites its iommudata which will eventually lead to
apple_dart_release_group leaving stale entries in sid2group.
Fix that by merging the iommudata if the returned group already exists.

Fixes: f0b636804c7c ("iommu/dart: Clear sid2group entry when a group is freed")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Link: https://lore.kernel.org/r/20230128113532.94651-1-sven@svenpeter.dev
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/apple-dart.c | 51 ++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 80e4436ee4de7..06ca73bddb5a5 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -689,6 +689,29 @@ static void apple_dart_release_group(void *iommu_data)
 	mutex_unlock(&apple_dart_groups_lock);
 }
 
+static int apple_dart_merge_master_cfg(struct apple_dart_master_cfg *dst,
+				       struct apple_dart_master_cfg *src)
+{
+	/*
+	 * We know that this function is only called for groups returned from
+	 * pci_device_group and that all Apple Silicon platforms never spread
+	 * PCIe devices from the same bus across multiple DARTs such that we can
+	 * just assume that both src and dst only have the same single DART.
+	 */
+	if (src->stream_maps[1].dart)
+		return -EINVAL;
+	if (dst->stream_maps[1].dart)
+		return -EINVAL;
+	if (src->stream_maps[0].dart != dst->stream_maps[0].dart)
+		return -EINVAL;
+
+	bitmap_or(dst->stream_maps[0].sidmap,
+		  dst->stream_maps[0].sidmap,
+		  src->stream_maps[0].sidmap,
+		  dst->stream_maps[0].dart->num_streams);
+	return 0;
+}
+
 static struct iommu_group *apple_dart_device_group(struct device *dev)
 {
 	int i, sid;
@@ -730,14 +753,28 @@ static struct iommu_group *apple_dart_device_group(struct device *dev)
 	if (!group)
 		goto out;
 
-	group_master_cfg = kmemdup(cfg, sizeof(*group_master_cfg), GFP_KERNEL);
-	if (!group_master_cfg) {
-		iommu_group_put(group);
-		goto out;
-	}
+	group_master_cfg = iommu_group_get_iommudata(group);
+	if (group_master_cfg) {
+		int ret;
 
-	iommu_group_set_iommudata(group, group_master_cfg,
-		apple_dart_release_group);
+		ret = apple_dart_merge_master_cfg(group_master_cfg, cfg);
+		if (ret) {
+			dev_err(dev, "Failed to merge DART IOMMU grups.\n");
+			iommu_group_put(group);
+			res = ERR_PTR(ret);
+			goto out;
+		}
+	} else {
+		group_master_cfg = kmemdup(cfg, sizeof(*group_master_cfg),
+					   GFP_KERNEL);
+		if (!group_master_cfg) {
+			iommu_group_put(group);
+			goto out;
+		}
+
+		iommu_group_set_iommudata(group, group_master_cfg,
+			apple_dart_release_group);
+	}
 
 	for_each_stream_map(i, cfg, stream_map)
 		for_each_set_bit(sid, stream_map->sidmap, stream_map->dart->num_streams)
-- 
2.39.2



