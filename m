Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D150411BE35
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLKUqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:46:00 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54949 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLKUqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:46:00 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MtfVx-1hrzjx1qbH-00v5Yw; Wed, 11 Dec 2019 21:44:34 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@hgst.com>,
        Shaun Tancheff <shaun@tancheff.com>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org
Subject: [PATCH 03/24] compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE
Date:   Wed, 11 Dec 2019 21:42:37 +0100
Message-Id: <20191211204306.1207817-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:tUHZTqYugYCYUwAQZWPackACXJTSUKL9x3lbDrGZrX999DK9Asp
 TVe964nJnMAgtKxNZszDAtDuKLzdq2+bKOi/TqfobbZHHI8sJXCBGqZU/QHvOzN+d6zOfS/
 Zr8LsXc41Dvhge0/mLw1M78GQTOdVLa+/8mbuDopq13rvC8A8dLivfsUuc3sqFq2hbpqt+a
 2T7gy1fgYL0l6KRKhCfjQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8Ca/Kaw5pJ0=:pX2Fj/FOn33vjECxD2DR3C
 gSxWY/h8Xl8vHByOcl7R6E0JSiBUsjc+vyap3TL0a6nyiYl2MU9J0aP3apJ/rSnZYrPZpnkPS
 W2Xj8SOJv52EZqY82PIfqVHzu/QYq/aFoZZEcTlkXKLxoDtvGqLzsuU1mQbE4bGkv7gV4QZRV
 GPFKQ9MhGGRABXA+ROegxW6pu7ZPeqmyRkIWjVUZrT6b4HWFU94AmaKqkUpUaMmMWdu5+/ixQ
 /Ul+joTcYsyc0l3f4EYl5USyRrjUhx9vmA0dn2K/SihYox24fWdJFg2bOZnUpJunQtAVjGO+s
 x/ZhligRpVhEpCI26y5LCJ8Gjkv8oy88jk75CvLFAUaN8RhX4rGmElV6Wa91PBzA7r1K29LYM
 lyJS4JJ+tV/5KzKmkkuQDhdgZXSzwbp76MIz9OdCKazzUDU+rOqmJEiQtworObbgI3mQauy8o
 Who5zGuZvHCwG5zcIF1tzTs+hoEVYsXSKQZquno2ai4gncriNKnh4br+M3OcioyNTgSZa6xrQ
 eF1lVZzXvPqtkSK5Rrwibef0ucVGO/lE+u7Mq9FsNgSuuYLHZAjDsDG+lda0sX6lD3i9ZHAEW
 fvrpdrl+fRORccEuDSkXTWZtcGTpP2zm2nFZE++CcLXGIQQVmfg/Ba9bA4/rrg3+tdoBI9MVw
 g/65hRQfWlwg/JC86yDbUxiFSbif0nzxXhhJV+8nZFklGG6ufyXvmACSOAF4BpOCTQJacgbzU
 dQ/QhZ2biI9H+kwB0zcwO1iGxGAaRX8eStw11rJRX8C+rfEAGLHbMJ8axdDWZoMEpMEmw5hvq
 LkO6gW96Cnj0eIdRUkFYDPOD4b6On+m6shG6eLibyp2LZ4NRSeHkIrdqCdaEC2Nr3B+Sz7sj3
 u+m1hGTzY0O37G2+CxFw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were added to blkdev_ioctl() but not blkdev_compat_ioctl,
so add them now.

Cc: <stable@vger.kernel.org> # v4.10+
Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 6ca015f92766..830f91e05fe3 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -354,6 +354,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	 * but we call blkdev_ioctl, which gets the lock for us
 	 */
 	case BLKRRPART:
+	case BLKREPORTZONE:
+	case BLKRESETZONE:
 		return blkdev_ioctl(bdev, mode, cmd,
 				(unsigned long)compat_ptr(arg));
 	case BLKBSZSET_32:
-- 
2.20.0

