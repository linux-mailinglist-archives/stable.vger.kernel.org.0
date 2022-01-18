Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EC2491A6D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352331AbiARC7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349241AbiARCrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:47:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE749C094250;
        Mon, 17 Jan 2022 18:39:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88269B81240;
        Tue, 18 Jan 2022 02:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6D1C36AF4;
        Tue, 18 Jan 2022 02:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473558;
        bh=0W+efpgq1FlUhJyr6MfVSm/5wkWq3CVYrdrfGADKS5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozaHFbGCC2Qt+7sBda5CzgsTUeTEJOWAM8y4ZFheZlmxgtdFM4Yea1q1ze6fMmSRI
         xFHnF/+mk9FZsIOtLsU1+nQYdEqCd7PNH/8x9Y2vCSQnGtuV+AGMpyZUKhtfl2E/P5
         UmYO1mbBgvTAfkJpLfrv8n7r6ppuhWzv9dIflptfKXkStaVRjotRRPZqRVmxbzXh9n
         Gfi3tyN9O7Kipv9IUfHXciqm6L7bbPxH1ZGPVnzNJJ6D95QYXntifsTSCQSVF4+EOz
         Jfa154lIWWemnvulRIn3G1RskXRcpki1PZkPthvo3gu1iFZxxwGdwL7KxKTALtOs5f
         Idi3b8W755JzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 168/188] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 17 Jan 2022 21:31:32 -0500
Message-Id: <20220118023152.1948105-168-sashal@kernel.org>
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

[ Upstream commit 85bca3c05b6cca31625437eedf2060e846c4bbad ]

Corrupt metadata could trigger an out of bounds write.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 0703ca7a7d9a4..5ce64e93aae74 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -81,14 +81,16 @@ void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 }
 
 static int insert_at(size_t value_size, struct btree_node *node, unsigned index,
-		      uint64_t key, void *value)
-		      __dm_written_to_disk(value)
+		     uint64_t key, void *value)
+	__dm_written_to_disk(value)
 {
 	uint32_t nr_entries = le32_to_cpu(node->header.nr_entries);
+	uint32_t max_entries = le32_to_cpu(node->header.max_entries);
 	__le64 key_le = cpu_to_le64(key);
 
 	if (index > nr_entries ||
-	    index >= le32_to_cpu(node->header.max_entries)) {
+	    index >= max_entries ||
+	    nr_entries >= max_entries) {
 		DMERR("too many entries in btree node for insert");
 		__dm_unbless_for_disk(value);
 		return -ENOMEM;
-- 
2.34.1

