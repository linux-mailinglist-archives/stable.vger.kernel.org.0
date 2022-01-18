Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E07491ACD
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiARDC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352781AbiARDAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:00:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F720C029822;
        Mon, 17 Jan 2022 18:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 424C0612D1;
        Tue, 18 Jan 2022 02:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EBBC36AE3;
        Tue, 18 Jan 2022 02:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474006;
        bh=Up/mfvhONYj+Dx9dzEmZmji4FSEdxlZp4ge0yxhkITo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXySLThaNX82GXN3q02FTqZg1LkSoSOwZIRURce5qs120eoT3gJcV7Sm6Y3QXabtu
         ZPwaPOoMAgG5uhXVWuERgYD45SsPgspw18HbhVLKDjdEL7qaCJG/COZQwzIywjyKbt
         +nY7K+4BFc2kD1qhjkvPV+KovFlaPbuFpCYBX4Er+nQXsHPh20e2b4ZSjgIS1mibp2
         C+eX/c//wwGzRshOjZaiuYnK3PCvxx/ktRvglZR7JZivZLShEzrNNHlHF2pFk/AlIf
         yxK9MWVxbVFJ1pQuGOtLXQyfgJFers+9y7sGed4hB7uljOiV+6sWREW/5bEhQ+RLp7
         hKVwHy5oAZE7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 65/73] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 17 Jan 2022 21:44:24 -0500
Message-Id: <20220118024432.1952028-65-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 8aae0624a2971..6383afb88f319 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -83,14 +83,16 @@ void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
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

