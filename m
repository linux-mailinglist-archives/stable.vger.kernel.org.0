Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50260498AC3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346482AbiAXTGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345282AbiAXTDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CDAC06175A;
        Mon, 24 Jan 2022 10:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A347FB81238;
        Mon, 24 Jan 2022 18:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E6AC340E7;
        Mon, 24 Jan 2022 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050749;
        bh=1irUI/gODjLwvM/jMUYlUbBn28oVk1kyE3HGzfg2p/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvSJW3QMjDmDV4q5GrvTO/b2SDCrmhrhqbNSt6u/xwRS1P8/HUzbZJdYpBIz/MLgK
         vyjJ7aiPDCtMnf44wpI6ldMj+AWCi7bmkkd7hDwgyXh3NW+/qBQm1LU1k0lrYt1Bfo
         nuG38J4mtFLirzjcrnH25nejZ0xETAnqzU7BFnz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 100/157] dm btree: add a defensive bounds check to insert_at()
Date:   Mon, 24 Jan 2022 19:43:10 +0100
Message-Id: <20220124183935.937971550@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
index 386215245dfe2..85273da5da206 100644
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



