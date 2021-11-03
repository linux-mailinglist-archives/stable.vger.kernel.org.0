Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE82644445B
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 16:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKCPN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 11:13:29 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59982 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhKCPN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 11:13:28 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2DB30218B5;
        Wed,  3 Nov 2021 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635952251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=anInB2kVb3pWABaNPOlE0t9drSa/Hjd5y9yI61NRDHg=;
        b=U0wCX09T/e755MapbZn75yJ6l7kYBrQDLjaa5xaI3RoaYONd0LV4vJFYq6aUEFVxrd9NmC
        /K51ABO+BJudGSTGZmqc8mMWzl15jvCNvfpTEeqgU/z2+4blK1BhZi9BmwL8sP8IbesIFu
        ILsYxcTznDvfbyC1+jpVML3uB1Pbn8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635952251;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=anInB2kVb3pWABaNPOlE0t9drSa/Hjd5y9yI61NRDHg=;
        b=5cQzlc5AscGS6LyS/auxpWSIDeftE0c8fhmmICagESsbmi2zLuzKp4feKYdQ74UZZFAwQr
        nXGvPRDXIsKKuTAQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 6ECA42C168;
        Wed,  3 Nov 2021 15:10:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: [PATCH] bcache: Revert "bcache: use bvec_virt"
Date:   Wed,  3 Nov 2021 23:10:41 +0800
Message-Id: <20211103151041.70516-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 2fd3e5efe791946be0957c8e1eed9560b541fe46.

The above commit replaces page_address(bv->bv_page) by bvec_virt(bv) to
avoid directly access to bv->bv_page, but in situation bv->bv_offset is
not zero and page_address(bv->bv_page) is not equal to bvec_virt(bv). In
such case a memory corruption may happen because memory in next page is
tainted by following line in do_btree_node_write(),
	memcpy(bvec_virt(bv), addr, PAGE_SIZE);

This patch reverts the mentioned commit to avoid the memory corruption.

Fixes: 2fd3e5efe791 ("bcache: use bvec_virt")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org # 5.15
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 93b67b8d31c3..88c573eeb598 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -378,7 +378,7 @@ static void do_btree_node_write(struct btree *b)
 		struct bvec_iter_all iter_all;
 
 		bio_for_each_segment_all(bv, b->bio, iter_all) {
-			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
+			memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
 			addr += PAGE_SIZE;
 		}
 
-- 
2.31.1

