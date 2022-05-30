Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCB9537C50
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiE3N2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbiE3N12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A8584A1D;
        Mon, 30 May 2022 06:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 376CFB80DA9;
        Mon, 30 May 2022 13:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DECEC36AE7;
        Mon, 30 May 2022 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917144;
        bh=MryhVYwL20qdpycWJZzLIYovOEL+Bs5lNHa/2TnV0EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKxLbBOKfSBeA9wLI0UOft+82dBc1ayyO7LgZdz71KbG1qs18NiR6knTbgmTgecmI
         13lWI6cA2zeW+ak7PEtMFhx9rfr4v1/fY0H2ItaRjNNQBbfdFgL9s+2T6dMONR0eGi
         e0mhK8PE2zHSAs3XGfdJ8FaFgCqGuT2RjoJSMSLJOjqXCNeCgOE8G90p+YwrKceTUJ
         /e6Y4IpY22a1U4VlHWck5aU1yo1Ja8/XsTAiKIwBbM2UX0XkcOQ4iWU/puPXpi0gPH
         se/c5pGHgtqikof0W70prot0ZOVKhLoU5TuDmSz+wBAz5YKz+mvwIWikMqXVhr/l85
         POTCLDH8N8ZgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 034/159] loop: implement ->free_disk
Date:   Mon, 30 May 2022 09:22:19 -0400
Message-Id: <20220530132425.1929512-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d2c7f56f8b5256d57f9e3fc7794c31361d43bdd9 ]

Ensure that the lo_device which is stored in the gendisk private
data is valid until the gendisk is freed.  Currently the loop driver
uses a lot of effort to make sure a device is not freed when it is
still in use, but to to fix a potential deadlock this will be relaxed
a bit soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220330052917.2566582-12-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a58595f5ee2c..ed7bec11948c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1768,6 +1768,14 @@ static void lo_release(struct gendisk *disk, fmode_t mode)
 	mutex_unlock(&lo->lo_mutex);
 }
 
+static void lo_free_disk(struct gendisk *disk)
+{
+	struct loop_device *lo = disk->private_data;
+
+	mutex_destroy(&lo->lo_mutex);
+	kfree(lo);
+}
+
 static const struct block_device_operations lo_fops = {
 	.owner =	THIS_MODULE,
 	.open =		lo_open,
@@ -1776,6 +1784,7 @@ static const struct block_device_operations lo_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	lo_compat_ioctl,
 #endif
+	.free_disk =	lo_free_disk,
 };
 
 /*
@@ -2090,15 +2099,14 @@ static void loop_remove(struct loop_device *lo)
 {
 	/* Make this loop device unreachable from pathname. */
 	del_gendisk(lo->lo_disk);
-	blk_cleanup_disk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_disk->queue);
 	blk_mq_free_tag_set(&lo->tag_set);
 
 	mutex_lock(&loop_ctl_mutex);
 	idr_remove(&loop_index_idr, lo->lo_number);
 	mutex_unlock(&loop_ctl_mutex);
-	/* There is no route which can find this loop device. */
-	mutex_destroy(&lo->lo_mutex);
-	kfree(lo);
+
+	put_disk(lo->lo_disk);
 }
 
 static void loop_probe(dev_t dev)
-- 
2.35.1

