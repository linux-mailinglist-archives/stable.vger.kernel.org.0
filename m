Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4231B451EE1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347577AbhKPAhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344704AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA927636B3;
        Mon, 15 Nov 2021 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002963;
        bh=5ifuhpAhEvvHZda+IFKyY6VJ3j2xluz7Ou2+Xm5stTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9S9YL7k4iewhFksGU3XMbP/xL0cfzQgjkUSdaSRSgUjvC1tULv/RZ5cl59ZKhOY5
         cjarhhEJY6/AyMpQny9yq5s2vgkIJbByU0LXHLSWOA7F3d0FaugEvrWBGEEks6QAzg
         FrA7K3PFwlxJmt/vaYezHNBpoRUtEYCyU0cb6r4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 760/917] nbd: fix max value for first_minor
Date:   Mon, 15 Nov 2021 18:04:15 +0100
Message-Id: <20211115165454.696863676@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e4c4871a73944353ea23e319de27ef73ce546623 ]

commit b1a811633f73 ("block: nbd: add sanity check for first_minor")
checks that 'first_minor' should not be greater than 0xff, which is
wrong. Whitout the commit, the details that when user pass 0x100000,
it ends up create sysfs dir "/sys/block/43:0" are as follows:

nbd_dev_add
 disk->first_minor = index << part_shift
  -> default part_shift is 5, first_minor is 0x2000000
  device_add_disk
   ddev->devt = MKDEV(disk->major, disk->first_minor)
    -> (0x2b << 20) | (0x2000000) = 0x2b00000
   device_add
    device_create_sys_dev_entry
	 format_dev_t
	  sprintf(buffer, "%u:%u", MAJOR(dev), MINOR(dev));
	   -> got 43:0
	  sysfs_create_link -> /sys/block/43:0

By the way, with the wrong fix, when part_shift is the default value,
only 8 ndb devices can be created since 8 << 5 is greater than 0xff.

Since the max bits for 'first_minor' should be the same as what
MKDEV() does, which is 20. Change the upper bound of 'first_minor'
from 0xff to 0xfffff.

Fixes: b1a811633f73 ("block: nbd: add sanity check for first_minor")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-2-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4f1b591c3a555..0d820c4dec176 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1749,11 +1749,11 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since first_minor will be truncated to
-	 * byte in __device_add_disk().
+	 * sysfs files/links, since MKDEV() expect that the max bits of
+	 * first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > 0xff) {
+	if (disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}
-- 
2.33.0



