Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1DC491C80
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356196AbiARDPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33016 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348348AbiARDJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 811DB60C49;
        Tue, 18 Jan 2022 03:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320D1C36AE3;
        Tue, 18 Jan 2022 03:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475368;
        bh=m3dT+BwIryTLHf0an/Okp1ItP323n1YSAxKneotYt5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5iywYX07uLaq24HES5wrCtc+Ha+34ejsWIYCnwac4HlELpHzxhiCBisFFK6cnmI4
         Rz5+VTgkM8GET2a2H+sN4EsE7smf5mfRk/SQ+k6beQdSq/WFmiIbghMoBqkfPgDpQg
         HcJnS0IuDIZTQ8LM7T3KcErJOVQaLGKOgpTPgfSClLsdtKYkEFxyp0aOmHXZtUuT3x
         NkIQW97Lb9ZUczJWxJp+x7wCtDHrOjPUB0JGSSTc4H0VYTomkKjkzrhcy9VfBx2dAY
         hUGqITaY0R+G6WtZuYoqso78Kas/6OSlw0Fpm+7xzcnLTfZ2S8sxRIoczaqmFVgnG1
         S4VH8Y6Fi7SSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.4 25/29] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 17 Jan 2022 22:08:18 -0500
Message-Id: <20220118030822.1955469-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
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
index fa9039a53ae5c..23b1d22f693c1 100644
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

