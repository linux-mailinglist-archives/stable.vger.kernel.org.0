Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A674FA106
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbfKMBy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbfKMBy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ECA7222D4;
        Wed, 13 Nov 2019 01:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610066;
        bh=eTpx9tamZQwPzwO6LWZ1fM9HmGoF86TvRZSkGzpGxuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jymKijPrMtjyHG/GTCBEbq+egc45yNKGDipGhvEXlqvEFWu5piJyrYjWZfu7fpvZf
         dmCNoVl6YCzpnlCtUWldjcAei9m9+/g8mOtaQSoRxFBzIm6Kmzo2gKZhUxfqNe1nbK
         xxcGagXBVIWWWdeLwXVPcyOj1NQf3vuqamPP5HuY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shenghui Wang <shhuiw@foxmail.com>,
        Tang Junhui <tang.junhui.linux@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 145/209] bcache: account size of buckets used in uuid write to ca->meta_sectors_written
Date:   Tue, 12 Nov 2019 20:49:21 -0500
Message-Id: <20191113015025.9685-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 7a55948d38eb9b274cbbdd56dc1dd4b96ebfbe04 ]

UUIDs are considered as metadata. __uuid_write should add the number
of buckets (in sectors) written to disk to ca->meta_sectors_written.
Currently only 1 bucket is used in uuid write.

Steps to test:
1) create a fresh backing device and a fresh cache device separately.
   The backing device didn't attach to any cache set.
2) cd /sys/block/<cache device>/bcache
   cat metadata_written      // record the output value
   cat bucket_size
3) attach the backing device to cache set
4) cat metadata_written
   The output value is almost the same as the value in step 2
   before the change.
   After the change, the value is bigger about 1 bucket size.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Reviewed-by: Tang Junhui <tang.junhui.linux@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2321643974dab..c4da2fe623e9e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -418,6 +418,7 @@ static int __uuid_write(struct cache_set *c)
 {
 	BKEY_PADDED(key) k;
 	struct closure cl;
+	struct cache *ca;
 
 	closure_init_stack(&cl);
 	lockdep_assert_held(&bch_register_lock);
@@ -429,6 +430,10 @@ static int __uuid_write(struct cache_set *c)
 	uuid_io(c, REQ_OP_WRITE, 0, &k.key, &cl);
 	closure_sync(&cl);
 
+	/* Only one bucket used for uuid write */
+	ca = PTR_CACHE(c, &k.key, 0);
+	atomic_long_add(ca->sb.bucket_size, &ca->meta_sectors_written);
+
 	bkey_copy(&c->uuid_bucket, &k.key);
 	bkey_put(c, &k.key);
 	return 0;
-- 
2.20.1

