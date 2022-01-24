Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188DE498E3C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355072AbiAXTj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57544 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353696AbiAXTfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:35:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED109B81235;
        Mon, 24 Jan 2022 19:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCE0C340E5;
        Mon, 24 Jan 2022 19:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052913;
        bh=Up/mfvhONYj+Dx9dzEmZmji4FSEdxlZp4ge0yxhkITo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0xwKFf8tQV6HtT5bfq8ru6gKzz/sCe1hxM0QQ9q3sYLA7Ej37faRqxAmOmEV/knO
         WNrp6svatwDyYIhrhT7X3ctGdbN0PzX0BzUZSfDCnPnHX18fbf1ZUM2xWqKKLVq9QQ
         N2W2DjHZdg5yGx77zC1Op0kYYSgk9fCjaCpBwzgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/320] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 24 Jan 2022 19:43:19 +0100
Message-Id: <20220124184000.957089456@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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



