Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D5D3290F6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243062AbhCAUR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242886AbhCAUIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48C61653B5;
        Mon,  1 Mar 2021 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621589;
        bh=Fb2dgFtBZU3nN+ppaehb91TVOnQks0UJ+HxYJJs/hg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2xPQrnEzWLbuo+f+HKZNB3Bg+dHFvTUuufUhZHQaVhQMrP3wOfzVCy2wiUkxkSzl
         RxGQAEDvAjT+CwTLMjYj7akbCbGOUA1JdZPXBS4y9PKByo0k1QV7fjDDgYya/zHh71
         rIYyle9PtY0/GM8MKU7EvDN7AXkDLBFAA8Mp2akI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 572/775] blk-settings: align max_sectors on "logical_block_size" boundary
Date:   Mon,  1 Mar 2021 17:12:20 +0100
Message-Id: <20210301161229.723015255@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
@@ -481,6 +481,14 @@ void blk_queue_io_opt(struct request_que
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
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top device)
@@ -607,6 +615,10 @@ int blk_stack_limits(struct queue_limits
 		ret = -1;
 	}
 
+	t->max_sectors = blk_round_down_sectors(t->max_sectors, t->logical_block_size);
+	t->max_hw_sectors = blk_round_down_sectors(t->max_hw_sectors, t->logical_block_size);
+	t->max_dev_sectors = blk_round_down_sectors(t->max_dev_sectors, t->logical_block_size);
+
 	/* Discard alignment and granularity */
 	if (b->discard_granularity) {
 		alignment = queue_limit_discard_alignment(b, start);


