Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DAB1AC800
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436705AbgDPPCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897768AbgDPNyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29D62076D;
        Thu, 16 Apr 2020 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045239;
        bh=Szm+1rgDnYEAet5MAJnily9gGMqOJMGUuLDtS4pC0Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZOvYfnrbGtwwRAPxHIbDCq7DCITo8QZYzSHGP3KZkvzrmYt5RqmSl9a3afXvKM12
         Z4/r7voQaNDfTn5/cyZRcWpT1bAXUWXRnO2f9lkFzkt5+yhgJyl+Fc4DS4EJkiHKCK
         4ZKYpzbUH8prvCLRVZBb6RMJQrTHxsROohrYs8qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Alexey Dobriyan (SK hynix)" <adobriyan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 051/254] block, zoned: fix integer overflow with BLKRESETZONE et al
Date:   Thu, 16 Apr 2020 15:22:20 +0200
Message-Id: <20200416131332.264664702@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 11bde986002c0af67eb92d73321d06baefae7128 ]

Check for overflow in addition before checking for end-of-block-device.

Steps to reproduce:

	#define _GNU_SOURCE 1
	#include <sys/ioctl.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>

	typedef unsigned long long __u64;

	struct blk_zone_range {
	        __u64 sector;
	        __u64 nr_sectors;
	};

	#define BLKRESETZONE    _IOW(0x12, 131, struct blk_zone_range)

	int main(void)
	{
	        int fd = open("/dev/nullb0", O_RDWR|O_DIRECT);
	        struct blk_zone_range zr = {4096, 0xfffffffffffff000ULL};
	        ioctl(fd, BLKRESETZONE, &zr);
	        return 0;
	}

BUG: KASAN: null-ptr-deref in submit_bio_wait+0x74/0xe0
Write of size 8 at addr 0000000000000040 by task a.out/1590

CPU: 8 PID: 1590 Comm: a.out Not tainted 5.6.0-rc1-00019-g359c92c02bfa #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
Call Trace:
 dump_stack+0x76/0xa0
 __kasan_report.cold+0x5/0x3e
 kasan_report+0xe/0x20
 submit_bio_wait+0x74/0xe0
 blkdev_zone_mgmt+0x26f/0x2a0
 blkdev_zone_mgmt_ioctl+0x14b/0x1b0
 blkdev_ioctl+0xb28/0xe60
 block_ioctl+0x69/0x80
 ksys_ioctl+0x3af/0xa50

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 05741c6f618be..6b442ae96499a 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -173,7 +173,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	if (!op_is_zone_mgmt(op))
 		return -EOPNOTSUPP;
 
-	if (!nr_sectors || end_sector > capacity)
+	if (end_sector <= sector || end_sector > capacity)
 		/* Out of range */
 		return -EINVAL;
 
-- 
2.20.1



