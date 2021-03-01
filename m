Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A12328734
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbhCARVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237852AbhCARNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E26464E42;
        Mon,  1 Mar 2021 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617031;
        bh=RsbPo0XyIseqr+G8QIRElmcAco+518rnGF0zBeON3Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ5N+LUaxHUbF11jzIpGGv3PMbvWg+v3ex/54/uNbzFNIsNkBEGHaMffJnA8Zd2gO
         ahqxetHDFED/n0dhvdUv8152c+mHXusta4PN/mUg7+O8/eB5crq1csQOIwfHA6tL96
         3PcJDdWhKYmhmEZGUWMV/7EArRZbWol7wUhob9l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 178/247] blk-settings: align max_sectors on "logical_block_size" boundary
Date:   Mon,  1 Mar 2021 17:13:18 +0100
Message-Id: <20210301161040.366245892@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 97f433c3601a24d3513d06f575a389a2ca4e11e4 upstream.

We get I/O errors when we run md-raid1 on the top of dm-integrity on the
top of ramdisk.
device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8048, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8147, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8246, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8345, 0xbb

The ramdisk device has logical_block_size 512 and max_sectors 255. The
dm-integrity device uses logical_block_size 4096 and it doesn't affect the
"max_sectors" value - thus, it inherits 255 from the ramdisk. So, we have
a device with max_sectors not aligned on logical_block_size.

The md-raid device sees that the underlying leg has max_sectors 255 and it
will split the bios on 255-sector boundary, making the bios unaligned on
logical_block_size.

In order to fix the bug, we round down max_sectors to logical_block_size.

Cc: stable@vger.kernel.org
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-settings.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -513,6 +513,14 @@ void blk_queue_io_opt(struct request_que
 }
 EXPORT_SYMBOL(blk_queue_io_opt);
 
+static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lbs)
+{
+	sectors = round_down(sectors, lbs >> SECTOR_SHIFT);
+	if (sectors < PAGE_SIZE >> SECTOR_SHIFT)
+		sectors = PAGE_SIZE >> SECTOR_SHIFT;
+	return sectors;
+}
+
 /**
  * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
  * @t:	the stacking driver (top)
@@ -639,6 +647,10 @@ int blk_stack_limits(struct queue_limits
 		ret = -1;
 	}
 
+	t->max_sectors = blk_round_down_sectors(t->max_sectors, t->logical_block_size);
+	t->max_hw_sectors = blk_round_down_sectors(t->max_hw_sectors, t->logical_block_size);
+	t->max_dev_sectors = blk_round_down_sectors(t->max_dev_sectors, t->logical_block_size);
+
 	/* Discard alignment and granularity */
 	if (b->discard_granularity) {
 		alignment = queue_limit_discard_alignment(b, start);


