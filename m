Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B428B66CD97
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbjAPRhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbjAPRhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75DF49002
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B79FCE1285
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E892C433EF;
        Mon, 16 Jan 2023 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889221;
        bh=H+eRMSCmyjOdkUPMMlKsBp9N3ycpnFmME5ctnbRSS8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEKeu6KzqZGoj4T7E9hvXoay5KCVlp+o7B0bsyMxtMaCoc2UAp47J8z7HWJuUC6p7
         K/pRFlefqm3J0zRiUAdyk5Tmvjg46qfdZ9HrhAXVAbRitzB1w4vIwCf/UPHgX6OPrd
         SDqmazM+O5UzInBiNXUwCWF0HpwacdWn/G+GCTSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.14 277/338] dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort
Date:   Mon, 16 Jan 2023 16:52:30 +0100
Message-Id: <20230116154833.154235923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

commit 352b837a5541690d4f843819028cf2b8be83d424 upstream.

Same ABBA deadlock pattern fixed in commit 4b60f452ec51 ("dm thin: Fix
ABBA deadlock between shrink_slab and dm_pool_abort_metadata") to
DM-cache's metadata.

Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: stable@vger.kernel.org
Fixes: 028ae9f76f29 ("dm cache: add fail io mode and needs_check flag")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |   54 +++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -550,11 +550,13 @@ static int __create_persistent_data_obje
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd)
+static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(cmd->metadata_sm);
 	dm_tm_destroy(cmd->tm);
-	dm_block_manager_destroy(cmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(cmd->bm);
 }
 
 typedef unsigned long (*flags_mutator)(unsigned long);
@@ -825,7 +827,7 @@ static struct dm_cache_metadata *lookup_
 		cmd2 = lookup(bdev);
 		if (cmd2) {
 			mutex_unlock(&table_lock);
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 			kfree(cmd);
 			return cmd2;
 		}
@@ -873,7 +875,7 @@ void dm_cache_metadata_close(struct dm_c
 		mutex_unlock(&table_lock);
 
 		if (!cmd->fail_io)
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 		kfree(cmd);
 	}
 }
@@ -1807,14 +1809,52 @@ int dm_cache_metadata_needs_check(struct
 
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 {
-	int r;
+	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with cmd->root_lock held below */
+	if (unlikely(cmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
+	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 CACHE_MAX_CONCURRENT_LOCKS);
 
 	WRITE_LOCK(cmd);
-	__destroy_persistent_data_objects(cmd);
-	r = __create_persistent_data_objects(cmd, false);
+	if (cmd->fail_io) {
+		WRITE_UNLOCK(cmd);
+		goto out;
+	}
+
+	__destroy_persistent_data_objects(cmd, false);
+	old_bm = cmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		cmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	cmd->bm = new_bm;
+	r = __open_or_format_metadata(cmd, false);
+	if (r) {
+		cmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		cmd->fail_io = true;
 	WRITE_UNLOCK(cmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }


