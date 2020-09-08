Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A648F261BBB
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgIHTIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730964AbgIHQG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:06:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF3723DC1;
        Tue,  8 Sep 2020 15:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579997;
        bh=QUNd9U2D0FIKd8CMrZu8G74GmA9dtKwfLxlZRU8UKMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo6xyPhAg5WO9UH8c/j8+72Io0Tb+xlPR2JT52cPyhuyC0sMao6Ya/43lyQsx+9dP
         W4ZKJsWsI7pW6ldnxZZruHCgT8o+bp56xIvE18xnoHZKhM8u+p2t3sqb+BqfeR4rss
         FHFo3LaJ+zHF/oqXfYzWSmjOn9HzzRvpbhhRk9Co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 119/129] dm thin metadata: Fix use-after-free in dm_bm_set_read_only
Date:   Tue,  8 Sep 2020 17:26:00 +0200
Message-Id: <20200908152235.796309786@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 3a653b205f29b3f9827a01a0c88bfbcb0d169494 upstream.

The following error ocurred when testing disk online/offline:

[  301.798344] device-mapper: thin: 253:5: aborting current metadata transaction
[  301.848441] device-mapper: thin: 253:5: failed to abort metadata transaction
[  301.849206] Aborting journal on device dm-26-8.
[  301.850489] EXT4-fs error (device dm-26) in __ext4_new_inode:943: Journal has aborted
[  301.851095] EXT4-fs (dm-26): Delayed block allocation failed for inode 398742 at logical offset 181 with max blocks 19 with error 30
[  301.854476] BUG: KASAN: use-after-free in dm_bm_set_read_only+0x3a/0x40 [dm_persistent_data]

Reason is:

 metadata_operation_failed
    abort_transaction
        dm_pool_abort_metadata
	    __create_persistent_data_objects
	        r = __open_or_format_metadata
	        if (r) --> If failed will free pmd->bm but pmd->bm not set NULL
		    dm_block_manager_destroy(pmd->bm);
    set_pool_mode
	dm_pool_metadata_read_only(pool->pmd);
	dm_bm_set_read_only(pmd->bm);  --> use-after-free

Add checks to see if pmd->bm is NULL in dm_bm_set_read_only and
dm_bm_set_read_write functions.  If bm is NULL it means creating the
bm failed and so dm_bm_is_read_only must return true.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c                 |    2 +-
 drivers/md/persistent-data/dm-block-manager.c |   14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -958,7 +958,7 @@ int dm_pool_metadata_close(struct dm_poo
 	}
 
 	pmd_write_lock_in_core(pmd);
-	if (!dm_bm_is_read_only(pmd->bm) && !pmd->fail_io) {
+	if (!pmd->fail_io && !dm_bm_is_read_only(pmd->bm)) {
 		r = __commit_transaction(pmd);
 		if (r < 0)
 			DMWARN("%s: __commit_transaction() failed, error = %d",
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -493,7 +493,7 @@ int dm_bm_write_lock(struct dm_block_man
 	void *p;
 	int r;
 
-	if (bm->read_only)
+	if (dm_bm_is_read_only(bm))
 		return -EPERM;
 
 	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
@@ -562,7 +562,7 @@ int dm_bm_write_lock_zero(struct dm_bloc
 	struct buffer_aux *aux;
 	void *p;
 
-	if (bm->read_only)
+	if (dm_bm_is_read_only(bm))
 		return -EPERM;
 
 	p = dm_bufio_new(bm->bufio, b, (struct dm_buffer **) result);
@@ -602,7 +602,7 @@ EXPORT_SYMBOL_GPL(dm_bm_unlock);
 
 int dm_bm_flush(struct dm_block_manager *bm)
 {
-	if (bm->read_only)
+	if (dm_bm_is_read_only(bm))
 		return -EPERM;
 
 	return dm_bufio_write_dirty_buffers(bm->bufio);
@@ -616,19 +616,21 @@ void dm_bm_prefetch(struct dm_block_mana
 
 bool dm_bm_is_read_only(struct dm_block_manager *bm)
 {
-	return bm->read_only;
+	return (bm ? bm->read_only : true);
 }
 EXPORT_SYMBOL_GPL(dm_bm_is_read_only);
 
 void dm_bm_set_read_only(struct dm_block_manager *bm)
 {
-	bm->read_only = true;
+	if (bm)
+		bm->read_only = true;
 }
 EXPORT_SYMBOL_GPL(dm_bm_set_read_only);
 
 void dm_bm_set_read_write(struct dm_block_manager *bm)
 {
-	bm->read_only = false;
+	if (bm)
+		bm->read_only = false;
 }
 EXPORT_SYMBOL_GPL(dm_bm_set_read_write);
 


