Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7431B49A432
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369328AbiAYABc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1848234AbiAXXWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:22:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8F9C0A02BE;
        Mon, 24 Jan 2022 13:28:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F60B815E2;
        Mon, 24 Jan 2022 21:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E87C33E61;
        Mon, 24 Jan 2022 21:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059728;
        bh=0W+efpgq1FlUhJyr6MfVSm/5wkWq3CVYrdrfGADKS5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dypMdqPLlrYW9BF7C471e2WcAvw9bYU6I5rDW7Zanomfdb7UbJVrkgYu6qOlBjF+I
         AAe9ntst8/TnTrL8TfJ9nLsm2kqjzPg8UN57ZSYhZAZ/rg0a0v/ZvY+taai9J6PvbI
         6+A81a9NRxqZzCkF1n88a3gruJrasOC7HcWOlIds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0713/1039] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 24 Jan 2022 19:41:42 +0100
Message-Id: <20220124184149.302012944@linuxfoundation.org>
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



