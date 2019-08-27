Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DC59E0C4
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbfH0IFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732279AbfH0IFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68992173E;
        Tue, 27 Aug 2019 08:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893148;
        bh=GKWfCIS+VGed4cqENG/dJ1poEMyqYBzvOrLTWjqa9XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MClKOgt4EFl6VNhOneyaWKD0pET7VD4GvyEorUd8ejwGfCWpPZ09RURcGzsoFA5a
         U8iNPmsxAMwQXB1uS2XuoLh42bD+Cb/APsaMUoaRq7CnWE6LippLTBrESmtvQD/eWl
         FOFpOXYkmi+cDUM2V6Soj+RwqLiCNBHolYu2OyJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bryan Gurney <bgurney@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.2 136/162] dm dust: use dust block size for badblocklist index
Date:   Tue, 27 Aug 2019 09:51:04 +0200
Message-Id: <20190827072743.332150234@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan Gurney <bgurney@redhat.com>

commit 08c04c84a5cde3af9baac0645a7496d6dcd76822 upstream.

Change the "frontend" dust_remove_block, dust_add_block, and
dust_query_block functions to store the "dust block number", instead
of the sector number corresponding to the "dust block number".

For the "backend" functions dust_map_read and dust_map_write,
right-shift by sect_per_block_shift.  This fixes the inability to
emulate failure beyond the first sector of each "dust block" (for
devices with a "dust block size" larger than 512 bytes).

Fixes: e4f3fabd67480bf ("dm: add dust target")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-dust.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -25,6 +25,7 @@ struct dust_device {
 	unsigned long long badblock_count;
 	spinlock_t dust_lock;
 	unsigned int blksz;
+	int sect_per_block_shift;
 	unsigned int sect_per_block;
 	sector_t start;
 	bool fail_read_on_bb:1;
@@ -79,7 +80,7 @@ static int dust_remove_block(struct dust
 	unsigned long flags;
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
-	bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
+	bblock = dust_rb_search(&dd->badblocklist, block);
 
 	if (bblock == NULL) {
 		if (!dd->quiet_mode) {
@@ -113,7 +114,7 @@ static int dust_add_block(struct dust_de
 	}
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
-	bblock->bb = block * dd->sect_per_block;
+	bblock->bb = block;
 	if (!dust_rb_insert(&dd->badblocklist, bblock)) {
 		if (!dd->quiet_mode) {
 			DMERR("%s: block %llu already in badblocklist",
@@ -138,7 +139,7 @@ static int dust_query_block(struct dust_
 	unsigned long flags;
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
-	bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
+	bblock = dust_rb_search(&dd->badblocklist, block);
 	if (bblock != NULL)
 		DMINFO("%s: block %llu found in badblocklist", __func__, block);
 	else
@@ -165,6 +166,7 @@ static int dust_map_read(struct dust_dev
 	int ret = DM_MAPIO_REMAPPED;
 
 	if (fail_read_on_bb) {
+		thisblock >>= dd->sect_per_block_shift;
 		spin_lock_irqsave(&dd->dust_lock, flags);
 		ret = __dust_map_read(dd, thisblock);
 		spin_unlock_irqrestore(&dd->dust_lock, flags);
@@ -195,6 +197,7 @@ static int dust_map_write(struct dust_de
 	unsigned long flags;
 
 	if (fail_read_on_bb) {
+		thisblock >>= dd->sect_per_block_shift;
 		spin_lock_irqsave(&dd->dust_lock, flags);
 		__dust_map_write(dd, thisblock);
 		spin_unlock_irqrestore(&dd->dust_lock, flags);
@@ -331,6 +334,8 @@ static int dust_ctr(struct dm_target *ti
 	dd->blksz = blksz;
 	dd->start = tmp;
 
+	dd->sect_per_block_shift = __ffs(sect_per_block);
+
 	/*
 	 * Whether to fail a read on a "bad" block.
 	 * Defaults to false; enabled later by message.


