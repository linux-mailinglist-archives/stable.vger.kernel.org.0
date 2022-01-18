Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1C7491C5D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355955AbiARDO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353083AbiARDIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:08:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D054EC061756;
        Mon, 17 Jan 2022 18:51:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4084861355;
        Tue, 18 Jan 2022 02:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B11C36AEF;
        Tue, 18 Jan 2022 02:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474267;
        bh=3pko/fty3e1jkvDU+lcK2yAE20crUsN5XxWJWc2HQzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt8M02Jad7SdzKvCkhh5LbDtqG9W75wXd3V34Ly1BCp0kzgakFhxfTYGIbx3btV6O
         8gGWdWDTX8+iHXx2TWLQF1/Y4nauBLXJ5EvC4ve5PyODDg8fBXQKkjKOkrZCcXkxzc
         rDmiAX2Be8M+CJkw6Hj7qJcd4fgeyqw0DnWvoqHrYQJqqxgjozYkodOOdQsjxrvcaC
         s0+dOrar3ZjP1+42f3x+HyaMR7wzTlzNvImjArARZ8xLpDwPRF/Gz1m4e3R5bTY9XX
         yk5Il4cxbB+0CggSfjS+QSW0O8CiqmcZ9Tx3oDSaW4OCf/FQaByioQ0TLsQ9huZn4M
         XWbunrIbx6BEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 52/56] dm space map common: add bounds check to sm_ll_lookup_bitmap()
Date:   Mon, 17 Jan 2022 21:49:04 -0500
Message-Id: <20220118024908.1953673-52-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index a2eceb12f01d4..1095b90307aed 100644
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

