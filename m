Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97424E9396
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiC1LYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbiC1LXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF8F58E46;
        Mon, 28 Mar 2022 04:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A4BB61120;
        Mon, 28 Mar 2022 11:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B977BC340EC;
        Mon, 28 Mar 2022 11:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466429;
        bh=P/lxEK3xXgM2nxhjaAHZNVVhYk11eH/eKFXBmOkQsxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+TJnOEkMSJJRonGfovAEVXGT4lME0gygkIzOhs7fuUThdMdefIWeGDXlAEQBopWw
         VOqFXzokqwsYN041K3K7JpoGXFhQ9aItHKsHdOSOyCee+Sq3X7s0/1kmpzCwrcC1cn
         BXT+80hOcyW0qPPKslmKJIRMVSH5XbhVH0cIU9pZgeSv+uZaKPgvAoyVJZum7xFmYJ
         fhVzPT9qIF8uZmqd4JcBKHNpu3Z+YWl9j1inywp2i3s00qbsiScUnp9VvOZtyJm141
         LJnGIJSeCxfhs04kQ9s2LgggQhMNK+UjnHP8WHEaJ7dLil3OWAMfL7N/y07EWRO4rt
         9pLsuALGLdMcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, mcgrof@kernel.org,
        baijiaju1990@gmail.com, chaitanya.kulkarni@wdc.com,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 09/35] memstick/mspro_block: fix handling of read-only devices
Date:   Mon, 28 Mar 2022 07:19:45 -0400
Message-Id: <20220328112011.1555169-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112011.1555169-1-sashal@kernel.org>
References: <20220328112011.1555169-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6dab421bfe06a59bf8f212a72e34673e8acf2018 ]

Use set_disk_ro to propagate the read-only state to the block layer
instead of checking for it in ->open and leaking a reference in case
of a read-only device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220215094514.3828912-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/mspro_block.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c0450397b673..7ea312f0840e 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -186,13 +186,8 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 
 	mutex_lock(&mspro_block_disk_lock);
 
-	if (msb && msb->card) {
+	if (msb && msb->card)
 		msb->usage_count++;
-		if ((mode & FMODE_WRITE) && msb->read_only)
-			rc = -EROFS;
-		else
-			rc = 0;
-	}
 
 	mutex_unlock(&mspro_block_disk_lock);
 
@@ -1239,6 +1234,9 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
 
+	if (msb->read_only)
+		set_disk_ro(msb->disk, true);
+
 	rc = device_add_disk(&card->dev, msb->disk, NULL);
 	if (rc)
 		goto out_cleanup_disk;
-- 
2.34.1

