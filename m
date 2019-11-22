Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58E106DC8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbfKVLDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbfKVLDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337892084F;
        Fri, 22 Nov 2019 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420585;
        bh=eTpx9tamZQwPzwO6LWZ1fM9HmGoF86TvRZSkGzpGxuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNHC/nQhvcQoSevsDtWX362NGgFcoMmkr6PGGBtJc7A4OM7YNIcmrUDwJcyZ1QHcN
         RuVIluT4CvmO9U8SicM4vefO4hy579TjahaqpBavQTh0/5QqI8Ubr0njHrToIMH65E
         8Eq1wXqepjMzkxh+KWgRV7mo64yA92kEzaqcDBUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>,
        Tang Junhui <tang.junhui.linux@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/220] bcache: account size of buckets used in uuid write to ca->meta_sectors_written
Date:   Fri, 22 Nov 2019 11:28:41 +0100
Message-Id: <20191122100923.929643756@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



