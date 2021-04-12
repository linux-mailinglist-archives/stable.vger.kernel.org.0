Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355F135D00F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbhDLSMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238145AbhDLSMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 14:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B5F461350;
        Mon, 12 Apr 2021 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618251101;
        bh=VOjjidsArMWHVu6+STthr6t7XDFmwhg8C/WgwQsOgao=;
        h=From:To:Cc:Subject:Date:From;
        b=BD8CFJt8C00PoYjLt7N2KkB6JBZTpdwxyzPxNfePcr3LbO1Y0jL7bLmMlV2aTsD/A
         GDB8nZl1zlB8yBPixh4it3kxFZST7rxdmvrF5b3xs34fRofNjTnCpcjR1hVESsWmdW
         grWbk6D99h1SVqfvr9T6nHJ+YK4FymQE6bfj5Anawj97yQn9GKkZgDDTJBWSj3q8wz
         GaOKFT7cNq0QdOjnnt2/3+AR2ac6VCM2prMoBpAKaOhHR4xBjfKpQcBDEywG/JFJwt
         9qwTnjWfCjlH9r3Lw7bG10spUmIZNQ3H3yfyq3jbBTy9mW85ynf0aNuEUu9oOm6nwt
         CmHAc5Xe9M4pw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Snitzer <snitzer@redhat.com>, kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>, stable@vger.kernel.org
Subject: [PATCH] dm verity: fix not aligned logical block size of RS roots IO
Date:   Mon, 12 Apr 2021 11:11:23 -0700
Message-Id: <20210412181123.2550918-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

commit df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
made dm_bufio->block_size 1024, if f->roots is 2. But, that gives the below EIO
if the logical block size of the device is 4096, given v->data_dev_block_bits=12.

E sd 0    : 0:0:0: [sda] tag#30 request not aligned to the logical block size
E blk_update_request: I/O error, dev sda, sector 10368424 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
E device-mapper: verity-fec: 254:8: FEC 9244672: parity read failed (block 18056): -5

Let's use f->roots for dm_bufio iff it's aligned to v->data_dev_block_bits.

Fixes: df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/md/dm-verity-fec.c | 11 ++++++++---
 drivers/md/dm-verity-fec.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 66f4c6398f67..cea2b3789736 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -65,7 +65,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	block = div64_u64_rem(position, v->fec->io_size, &rem);
 	*offset = (unsigned)rem;
 
 	res = dm_bufio_read(v->fec->bufio, block, buf);
@@ -154,7 +154,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
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
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 42fbd3a7fc9f..3c46c8d61883 100644
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
-- 
2.31.1.295.g9ea45b61b8-goog

