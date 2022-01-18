Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEAB491D52
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbiARDfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344898AbiARDGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:06:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C488EC06127A;
        Mon, 17 Jan 2022 18:48:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED6BB8123F;
        Tue, 18 Jan 2022 02:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFCAC36AE3;
        Tue, 18 Jan 2022 02:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474136;
        bh=diNtmretYvBMH6ruzlzMmmbrIGYcwFDWMdE2r2P1wKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/kCQakY+1xYFhB7ImCb4FfAsmKzJIPw5dGVjzP6TxlWuToQLwM5NklO2xK+gNSse
         gswXVJaZ70jAtBQzT6M1iOsdLKZOW5LGD4MAXs/iqdGl2M4e32xR9+GzB4xegCV/ip
         58cT13aQjhkshe0k8ySd1DLq0+eAJ+1JVBXtdekjr+xI0c4rfS8n7/HXOo+FDVYpNC
         l5L8ywZpzCRppbHk3Chhjiu3qFxAW6FVkwn5Dk93YzM0Di4JEiCDdMYvzfRyTN3XDP
         G2iDc4Fc7mtkEdpWlfJ8dQEsyppKNXZuaiCs4/K5McI/SdnaOBFWvqpQf5FF61Y6Ur
         dzS3Ivnzifn2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 53/59] dm space map common: add bounds check to sm_ll_lookup_bitmap()
Date:   Mon, 17 Jan 2022 21:46:54 -0500
Message-Id: <20220118024701.1952911-53-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

[ Upstream commit cba23ac158db7f3cd48a923d6861bee2eb7a2978 ]

Corrupted metadata could warrant returning error from sm_ll_lookup_bitmap().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-space-map-common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index a284762e548e1..5115a27196038 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -279,6 +279,11 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
 	struct disk_index_entry ie_disk;
 	struct dm_block *blk;
 
+	if (b >= ll->nr_blocks) {
+		DMERR_LIMIT("metadata block out of bounds");
+		return -EINVAL;
+	}
+
 	b = do_div(index, ll->entries_per_block);
 	r = ll->load_ie(ll, index, &ie_disk);
 	if (r < 0)
-- 
2.34.1

