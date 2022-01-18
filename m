Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3711D491634
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbiARCdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:33:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47328 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344435AbiARC3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E014610AB;
        Tue, 18 Jan 2022 02:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D011C36AF3;
        Tue, 18 Jan 2022 02:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472993;
        bh=0W+efpgq1FlUhJyr6MfVSm/5wkWq3CVYrdrfGADKS5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9cbS+J2ry6d3q1RLeZJRy+dO7ntcyIV2tInEK93OSSzCe9lpSooMKdXzG2pJNXI+
         CC4pSH3Ao8SzaA+EWmirN3iLGInYWt1bXvYWvN8kCoOBE5o9d4oBrU9fdQeh+Jezh4
         VzFbc6Hm4VB6wWoZHIlZJCy6pKriA6M/EVme60IMGCPqqaDTnxF+4+j3BPUAhwo+To
         cBfTk4fKbb3P0/N5xLuetmuChisnJ5cWVDgVim393AbWxiFRUUDVHrJ5P4N9QRtYo1
         g8CkJsGIgHlZb1ICV1/LIzaFQeyYQIRbtELaTfSN2nwdg7KmtKZv0T6CScmmXogylK
         ycBOTJi1lIvnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.16 196/217] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 17 Jan 2022 21:19:19 -0500
Message-Id: <20220118021940.1942199-196-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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

