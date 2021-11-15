Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3AB451285
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbhKOTgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244725AbhKOTRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6891632B7;
        Mon, 15 Nov 2021 18:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000592;
        bh=rgwp2BFzJTPRqdHIEZYeVg7FlO5/9pI3JSUNdIPx1nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teuz/slF1PUyeP0dy9Nh4uarZ6mtVtTydblBcWvhWmqfWouCV8Fn4orZC/Ca+ORK8
         hfw1++5zfm606+qiPqhfKWKU0uqZBk8zfCMJQC6cOdTIzqEMaMUaO4eGZZU2AwvDb5
         INtsLmuEfSzvlgyZA8IIULn82hedwXSN7vMJv9JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 718/849] nbd: fix possible overflow for first_minor in nbd_dev_add()
Date:   Mon, 15 Nov 2021 18:03:21 +0100
Message-Id: <20211115165444.539348679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 940c264984fd1457918393c49674f6b39ee16506 ]

If 'part_shift' is not zero, then 'index << part_shift' might
overflow to a value that is not greater than '0xfffff', then sysfs
might complains about duplicate creation.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-3-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index bdc6d656e785c..f72ff515ee51b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1777,11 +1777,11 @@ static int nbd_dev_add(int index)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since MKDEV() expect that the max bits of
-	 * first_minor is 20.
+	 * sysfs files/links, since index << part_shift might overflow, or
+	 * MKDEV() expect that the max bits of first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > MINORMASK) {
+	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}
-- 
2.33.0



