Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E672333E73
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhCJN0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhCJNZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A231C64FE8;
        Wed, 10 Mar 2021 13:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382726;
        bh=SmnihGdTDqNSXZKBkfXhVji79PLiI/93xn8ZpIzjLhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bvdp76vheFq3BFHdpKYP/HR1HALH2k9bzr1qeZfrxE1fu+SLSMITSflDJ7nFxMWPY
         05tNbWfzhi6hlkYjSRoY3wDnIXiEMQPeEqM/huFzpD7XAo9PLqbUSLEffbj7YvzRL3
         zNmCo+EI/Gf1Ryr1KX2YRdPh828n80NpyxfoOp0Y=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?= <cJ-ko@zougloub.eu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 19/39] dm verity: fix FEC for RS roots unaligned to block size
Date:   Wed, 10 Mar 2021 14:24:27 +0100
Message-Id: <20210310132320.325750529@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Milan Broz <gmazyland@gmail.com>

commit df7b59ba9245c4a3115ebaa905e3e5719a3810da upstream.

Optional Forward Error Correction (FEC) code in dm-verity uses
Reed-Solomon code and should support roots from 2 to 24.

The error correction parity bytes (of roots lengths per RS block) are
stored on a separate device in sequence without any padding.

Currently, to access FEC device, the dm-verity-fec code uses dm-bufio
client with block size set to verity data block (usually 4096 or 512
bytes).

Because this block size is not divisible by some (most!) of the roots
supported lengths, data repair cannot work for partially stored parity
bytes.

This fix changes FEC device dm-bufio block size to "roots << SECTOR_SHIFT"
where we can be sure that the full parity data is always available.
(There cannot be partial FEC blocks because parity must cover whole
sectors.)

Because the optional FEC starting offset could be unaligned to this
new block size, we have to use dm_bufio_set_sector_offset() to
configure it.

The problem is easily reproduced using veritysetup, e.g. for roots=13:

  # create verity device with RS FEC
  dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
  veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=13 | awk '/^Root hash/{ print $3 }' >roothash

  # create an erasure that should be always repairable with this roots setting
  dd if=/dev/zero of=data.img conv=notrunc bs=1 count=8 seek=4088 status=none

  # try to read it through dm-verity
  veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=13 $(cat roothash)
  dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer
  # wait for possible recursive recovery in kernel
  udevadm settle
  veritysetup close test

With this fix, errors are properly repaired.
  device-mapper: verity-fec: 7:1: FEC 0: corrected 8 errors
  ...

Without it, FEC code usually ends on unrecoverable failure in RS decoder:
  device-mapper: verity-fec: 7:1: FEC 0: failed to correct: -74
  ...

This problem is present in all kernels since the FEC code's
introduction (kernel 4.5).

It is thought that this problem is not visible in Android ecosystem
because it always uses a default RS roots=2.

Depends-on: a14e5ec66a7a ("dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size")
Signed-off-by: Milan Broz <gmazyland@gmail.com>
Tested-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: stable@vger.kernel.org # 4.5+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-verity-fec.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -65,19 +65,18 @@ static int fec_decode_rs8(struct dm_veri
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 			   unsigned *offset, struct dm_buffer **buf)
 {
-	u64 position, block;
+	u64 position, block, rem;
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = position >> v->data_dev_block_bits;
-	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
+	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	*offset = (unsigned)rem;
 
-	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
+	res = dm_bufio_read(v->fec->bufio, block, buf);
 	if (unlikely(IS_ERR(res))) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
-		      (unsigned long long)(v->fec->start + block),
-		      PTR_ERR(res));
+		      (unsigned long long)block, PTR_ERR(res));
 		*buf = NULL;
 	}
 
@@ -159,7 +158,7 @@ static int fec_decode_bufs(struct dm_ver
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= 1 << v->data_dev_block_bits) {
+		if (offset >= v->fec->roots << SECTOR_SHIFT) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -675,7 +674,7 @@ int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks;
+	u64 hash_blocks, fec_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -745,15 +744,17 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  1 << v->data_dev_block_bits,
+					  f->roots << SECTOR_SHIFT,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
 	}
 
-	if (dm_bufio_get_device_size(f->bufio) <
-	    ((f->start + f->rounds * f->roots) >> v->data_dev_block_bits)) {
+	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
+
+	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
+	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}


