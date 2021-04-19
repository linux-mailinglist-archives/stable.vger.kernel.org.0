Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C513642B6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhDSNLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239565AbhDSNKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 539F661362;
        Mon, 19 Apr 2021 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837806;
        bh=/0EFt+oC5nkaqB0I+I0+gOt65NBd30fm8mGLACfO6o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rbprtfo7jG/dghHXwZ7FYP4dG9P1tJ6WTSPVxAXa+y1wzc0g9lJNhoXlX/ScMwoff
         E2jGcv+sATUWAny2tQoEjusjWABj8R/VicubHo6ttUho7ibV2WxwBugRhcrW5rSlDZ
         BS+ai52ldISHrJoenI8r/y/y2yXg1Sr6rQ/LUvPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@google.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 059/122] dm verity fec: fix misaligned RS roots IO
Date:   Mon, 19 Apr 2021 15:05:39 +0200
Message-Id: <20210419130532.187080194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

commit 8ca7cab82bda4eb0b8064befeeeaa38106cac637 upstream.

commit df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to
block size") introduced the possibility for misaligned roots IO
relative to the underlying device's logical block size. E.g. Android's
default RS roots=2 results in dm_bufio->block_size=1024, which causes
the following EIO if the logical block size of the device is 4096,
given v->data_dev_block_bits=12:

E sd 0    : 0:0:0: [sda] tag#30 request not aligned to the logical block size
E blk_update_request: I/O error, dev sda, sector 10368424 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
E device-mapper: verity-fec: 254:8: FEC 9244672: parity read failed (block 18056): -5

Fix this by onlu using f->roots for dm_bufio blocksize IFF it is
aligned to v->data_dev_block_bits.

Fixes: df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |   11 ++++++++---
 drivers/md/dm-verity-fec.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -65,7 +65,7 @@ static u8 *fec_read_parity(struct dm_ver
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	block = div64_u64_rem(position, v->fec->io_size, &rem);
 	*offset = (unsigned)rem;
 
 	res = dm_bufio_read(v->fec->bufio, block, buf);
@@ -154,7 +154,7 @@ static int fec_decode_bufs(struct dm_ver
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= v->fec->roots << SECTOR_SHIFT) {
+		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -742,8 +742,13 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
+	if ((f->roots << SECTOR_SHIFT) & ((1 << v->data_dev_block_bits) - 1))
+		f->io_size = 1 << v->data_dev_block_bits;
+	else
+		f->io_size = v->fec->roots << SECTOR_SHIFT;
+
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  f->roots << SECTOR_SHIFT,
+					  f->io_size,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -36,6 +36,7 @@ struct dm_verity_fec {
 	struct dm_dev *dev;	/* parity data device */
 	struct dm_bufio_client *data_bufio;	/* for data dev access */
 	struct dm_bufio_client *bufio;		/* for parity data access */
+	size_t io_size;		/* IO size for roots */
 	sector_t start;		/* parity data start in blocks */
 	sector_t blocks;	/* number of blocks covered */
 	sector_t rounds;	/* number of interleaving rounds */


