Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9941EFB3F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgFEOZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbgFEOQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394C5208B8;
        Fri,  5 Jun 2020 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366614;
        bh=usTWkI/BDbEZqG7b7JXwId/H5vjLUwle1vR+sF0fBd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee7Bha+c7EXb8Z1HsdEW/jGYcJ6STecPjSZz7vpzMYThXtZFL+WBHCXa4yxXu/HlF
         otOGT0MNKPj+Cj/P2mpINPAVoEln5whQJEWOKulKAJAbImN/sboGldroG0NHODeVGv
         aOW7sQ1rCjVeJAEVpm6BSAHd1Oze8dY8+I5yIE7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 24/43] null_blk: return error for invalid zone size
Date:   Fri,  5 Jun 2020 16:14:54 +0200
Message-Id: <20200605140153.790067538@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit e274832590211c4b1b1e807ca66fad8b5bb8b328 ]

In null_init_zone_dev() check if the zone size is larger than device
capacity, return error if needed.

This also fixes the following oops :-

null_blk: changed the number of conventional zones to 4294967295
BUG: kernel NULL pointer dereference, address: 0000000000000010
PGD 7d76c5067 P4D 7d76c5067 PUD 7d240c067 PMD 0
Oops: 0002 [#1] SMP NOPTI
CPU: 4 PID: 5508 Comm: nullbtests.sh Tainted: G OE 5.7.0-rc4lblk-fnext0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e4
RIP: 0010:null_init_zoned_dev+0x17a/0x27f [null_blk]
RSP: 0018:ffffc90007007e00 EFLAGS: 00010246
RAX: 0000000000000020 RBX: ffff8887fb3f3c00 RCX: 0000000000000007
RDX: 0000000000000000 RSI: ffff8887ca09d688 RDI: ffff888810fea510
RBP: 0000000000000010 R08: ffff8887ca09d688 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8887c26e8000
R13: ffffffffa05e9390 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fcb5256f740(0000) GS:ffff888810e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000081e8fe000 CR4: 00000000003406e0
Call Trace:
 null_add_dev+0x534/0x71b [null_blk]
 nullb_device_power_store.cold.41+0x8/0x2e [null_blk]
 configfs_write_file+0xe6/0x150
 vfs_write+0xba/0x1e0
 ksys_write+0x5f/0xe0
 do_syscall_64+0x60/0x250
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7fcb51c71840

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_zoned.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index ed34785dd64b..5dc955f5ea0a 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -20,6 +20,10 @@ int null_zone_init(struct nullb_device *dev)
 		pr_err("zone_size must be power-of-two\n");
 		return -EINVAL;
 	}
+	if (dev->zone_size > dev->size) {
+		pr_err("Zone size larger than device capacity\n");
+		return -EINVAL;
+	}
 
 	dev->zone_size_sects = dev->zone_size << ZONE_SIZE_SHIFT;
 	dev->nr_zones = dev_size >>
-- 
2.25.1



