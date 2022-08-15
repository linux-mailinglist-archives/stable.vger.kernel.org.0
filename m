Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA77594C8B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243306AbiHPAc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354147AbiHPAbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D470831ECA;
        Mon, 15 Aug 2022 13:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E58CB80EA8;
        Mon, 15 Aug 2022 20:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57AFC433C1;
        Mon, 15 Aug 2022 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595792;
        bh=g53U7Pc7vbbQYGqZ6XvGCvWrGBN/w1B36+hSTLtR6IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMoVZRJ7a8QA9wrM6dwDZkVbJ+R1r0DVwIm/N55GjOkmADXnSlJd6Ckzo/cB1yMpY
         xfhFsWvanst2GFMusl7P+dICIy9pNpnMVEjNfT8YxnKCXtxyYAN+7vYBAeMVsY/EEE
         LVWGVmnW5YM9oQ61Gen1o6bnlrnxGdzzbUfFmerI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0877/1157] null_blk: fix ida error handling in null_add_dev()
Date:   Mon, 15 Aug 2022 20:03:53 +0200
Message-Id: <20220815180514.530110453@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ee452a8d984f94fa8e894f003a52e776e4572881 ]

There needs to be some error checking if ida_simple_get() fails.
Also call ida_free() if there are errors later.

Fixes: 94bc02e30fb8 ("nullb: use ida to manage index")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YtEhXsr6vJeoiYhd@kili
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 6b67088f4ea7..c0a0474be574 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2043,8 +2043,13 @@ static int null_add_dev(struct nullb_device *dev)
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
 
 	mutex_lock(&lock);
-	nullb->index = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
-	dev->index = nullb->index;
+	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
+	if (rv < 0) {
+		mutex_unlock(&lock);
+		goto out_cleanup_zone;
+	}
+	nullb->index = rv;
+	dev->index = rv;
 	mutex_unlock(&lock);
 
 	blk_queue_logical_block_size(nullb->q, dev->blocksize);
@@ -2070,7 +2075,7 @@ static int null_add_dev(struct nullb_device *dev)
 
 	rv = null_gendisk_register(nullb);
 	if (rv)
-		goto out_cleanup_zone;
+		goto out_ida_free;
 
 	mutex_lock(&lock);
 	list_add_tail(&nullb->list, &nullb_list);
@@ -2079,6 +2084,9 @@ static int null_add_dev(struct nullb_device *dev)
 	pr_info("disk %s created\n", nullb->disk_name);
 
 	return 0;
+
+out_ida_free:
+	ida_free(&nullb_indexes, nullb->index);
 out_cleanup_zone:
 	null_free_zoned_dev(dev);
 out_cleanup_disk:
-- 
2.35.1



