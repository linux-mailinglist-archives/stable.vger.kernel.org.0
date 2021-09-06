Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8019F40128B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbhIFBVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238679AbhIFBVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E12CA6108E;
        Mon,  6 Sep 2021 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891213;
        bh=mABDKOQrNOYmohIEZGbu+NdedYH3RHu/VM8TY9sq2bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGXpONY9NGBiLz4IqcKjkJsOMnhBSlomI8IcdCMPvGobasPM8d4/IJNOVg9dHfaUC
         kGHguuB28U5Xvxu21j8HbktJ+nk4RdEkArtylbknJQLMI3hBbRCcl5XU8a0i5XEiF4
         j8ZFiimTJUjT+gYeaH430psDGWyJJQq+SBhPH+K4Mad1ehlZZgpbsTvcjnk9E+8It/
         baYl1p/h2Kudkr7mmL0zK5xiKRYFhOpWG6ip+VWk5spCz4inWawRuZG793aU6Lc4A6
         i44Ue8Z7N+M010EnR29xz2DVtwwohIQKV9AAiRmNrMYHXFM3/9K+W2A13aRGhtrWjV
         VWdlHMbLomwuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org
Subject: [PATCH AUTOSEL 5.14 18/47] nbd: add the check to prevent overflow in __nbd_ioctl()
Date:   Sun,  5 Sep 2021 21:19:22 -0400
Message-Id: <20210906011951.928679-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit fad7cd3310db3099f95dd34312c77740fbc455e5 ]

If user specify a large enough value of NBD blocks option, it may trigger
signed integer overflow which may lead to nbd->config->bytesize becomes a
large or small value, zero in particular.

UBSAN: Undefined behaviour in drivers/block/nbd.c:325:31
signed integer overflow:
1024 * 4611686155866341414 cannot be represented in type 'long long int'
[...]
Call trace:
[...]
 handle_overflow+0x188/0x1dc lib/ubsan.c:192
 __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
 nbd_size_set drivers/block/nbd.c:325 [inline]
 __nbd_ioctl drivers/block/nbd.c:1342 [inline]
 nbd_ioctl+0x998/0xa10 drivers/block/nbd.c:1395
 __blkdev_driver_ioctl block/ioctl.c:311 [inline]
[...]

Although it is not a big deal, still silence the UBSAN by limit
the input value.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20210804021212.990223-1-libaokun1@huawei.com
[axboe: dropped unlikely()]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 19f5d5a8b16a..acf3f85bf3c7 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1388,6 +1388,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		       unsigned int cmd, unsigned long arg)
 {
 	struct nbd_config *config = nbd->config;
+	loff_t bytesize;
 
 	switch (cmd) {
 	case NBD_DISCONNECT:
@@ -1402,8 +1403,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_SET_SIZE:
 		return nbd_set_size(nbd, arg, config->blksize);
 	case NBD_SET_SIZE_BLOCKS:
-		return nbd_set_size(nbd, arg * config->blksize,
-				    config->blksize);
+		if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
+			return -EINVAL;
+		return nbd_set_size(nbd, bytesize, config->blksize);
 	case NBD_SET_TIMEOUT:
 		nbd_set_cmd_timeout(nbd, arg);
 		return 0;
-- 
2.30.2

