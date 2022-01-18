Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2E491C25
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348369AbiARDNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354544AbiARDGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:06:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A024C033251;
        Mon, 17 Jan 2022 18:48:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE7AA612CF;
        Tue, 18 Jan 2022 02:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589B1C36AF3;
        Tue, 18 Jan 2022 02:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474135;
        bh=Up/mfvhONYj+Dx9dzEmZmji4FSEdxlZp4ge0yxhkITo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci3kuT0FhNVUAZOyRlIw+UEIWSQXU5ex/kQE0wE0FU4Ns8nKLMjP3JcoE3UGD5NyP
         /oDEVc1ZBrCggnBWLmYIeaB6CFLf++1Fi8GQBzIBCHgjq8QGqYApx4CTFwjvkfPKm3
         MWsQARKjhOd4JAP3AZhrv4zLMQu6R9+L6jPkhPL/R7CQH8/I4FMsC6ZKHx7dhzhDsf
         icYojyOi2nwrQFmXbGTpfVXZS6qT9gzufOcVJYkaozC653Hw5XloRngQTXwRB6xGsY
         j/3mzqlPYgJvSelYN/m6ByenGlX8/NOttWQ9z+vlyWuCwIMIgsQGmDW4ItEdJOLlPi
         aEEdQCJJTmTgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 52/59] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 17 Jan 2022 21:46:53 -0500
Message-Id: <20220118024701.1952911-52-sashal@kernel.org>
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

