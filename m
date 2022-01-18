Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FABC491ADB
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352338AbiARC7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345250AbiARCrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:47:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79205C094252;
        Mon, 17 Jan 2022 18:39:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A646115F;
        Tue, 18 Jan 2022 02:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0832C36AEF;
        Tue, 18 Jan 2022 02:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473559;
        bh=+j/hF9KUbkWpVpF0TWD+CJhI+JZR0eec5rq0R+03JEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzMBmL3CFL/3d8vAn/2AfphcVAk4CIWXgU3CzhDHfF6Dycsx4MXqJ77sMoDuigTKM
         qzwrt7OQ4p4LFgrdUmYCnnIqde0a7402H9PBL4n6wrgo+CPts+YV0SWO+XoBMPmG66
         WOLxyj6ST+a8KCzRCRn/5UR4ik4ONi1BYuwdPwSN8AsvjW4kaaZl3G70o5Wn7QPj7s
         VuwOb/P/5PvbPaxre+NMWsuUQwXBysmw2C5wlVh6cXWaHCd3rHpzW1iCiRjGh5p5JE
         58mR1MsMHdHvRetvKlYnuhhcUFkHXGF+D9Wkqt7nVM9EteBunDUw4aKnrel5TOSIzk
         D6qbIKRqH5FqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 169/188] dm space map common: add bounds check to sm_ll_lookup_bitmap()
Date:   Mon, 17 Jan 2022 21:31:33 -0500
Message-Id: <20220118023152.1948105-169-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 4a6a2a9b4eb49..bfbfa750e0160 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -283,6 +283,11 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
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

