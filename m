Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EC0323205
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 21:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhBWUXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 15:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbhBWUXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 15:23:01 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA33C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 12:22:21 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id y17so2319785wrs.12
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5fh/D1A+JiA68ji7CME2QlrIQrJhB9RCBAudcPZNzck=;
        b=Rdy7qWcEY9tuPimLaBvvhvO3bpgAwqa/RdscyvDXqlNzKd+82UeqyjgChRnbq52uzn
         rs+N2briJhQV730WjyignJW2MJYz+SwEu4jsK+bTiY6+odKVkEjJnL3y5qij20Ln2R7W
         e/TypDoM9w7HOsBlJJbCywTJ1miuLRSx3RztE0mU2JoQIiG9xdBxtZvZHgrTE7a0QFL1
         m4Kt5wazCgKe6ZAkWKHW/OaDV+nQj5lnP65vTjKQS68ASqdBNea0DKiJK7yG9sVQ0ooa
         gaPuqcjCIRqgl+3QyTc7b60RBuntL2Fgmpm+EwSsMiVw5g+6xhvIxRxu1WLlkalJ9kWU
         +KPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5fh/D1A+JiA68ji7CME2QlrIQrJhB9RCBAudcPZNzck=;
        b=dnV7GmFXrf+IhYra2r6cG1SDfEXNErzGrTVlicH05X4/Bq+UZXjKDIbb36cG6jV/7e
         U4s7/pBA/NSdbjjN/yUs3on/bngz0MKfEUVI9XqheC1xPdSekpnO0XyJwQQGtdb/nL5M
         39aPQGeya3OhRZVGcJGmabjgmgmdYgq9DrLCvmtFRPMlWycpKU3rq8IR/NxrkpeDYNGd
         cHNLZuavvLbNpSfIh2FuMkNCgONC7Wc19E8i5Tnf3NAGvY9xmT41S+0SJCeuZeiTUmkL
         KAkmOMzA02RHjKxJ7YM7UmQQ3QrnPki8bKFmQsFqGNM+rZT0KQi0brQ5fvvwxHa/WSqh
         NQmg==
X-Gm-Message-State: AOAM531jTQ2TnEaLtzdDzJQugyT6LJ6Mh7I5dKPx1trOyf6hVJ0+wa2s
        DicaSEzmkVM3IVRTp7KTx+g=
X-Google-Smtp-Source: ABdhPJx/+Ep89Sibo1iSUcyjlYpnVeP5r9e3humFdcQNG+3kFULnpLmOL4DjXQXHJopW3TUVHL4tkQ==
X-Received: by 2002:a5d:4044:: with SMTP id w4mr20003557wrp.121.1614111740229;
        Tue, 23 Feb 2021 12:22:20 -0800 (PST)
Received: from merlot.mazyland.net (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.googlemail.com with ESMTPSA id w4sm3718072wmc.13.2021.02.23.12.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 12:22:19 -0800 (PST)
From:   Milan Broz <gmazyland@gmail.com>
To:     dm-devel@redhat.com
Cc:     mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?= <cJ-ko@zougloub.eu>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] dm-verity: Fix FEC for RS roots non-aligned to block size
Date:   Tue, 23 Feb 2021 21:21:21 +0100
Message-Id: <20210223202121.898736-2-gmazyland@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210223202121.898736-1-gmazyland@gmail.com>
References: <20210222211528.848441-1-gmazyland@gmail.com>
 <20210223202121.898736-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Optional Forward Error Correction (FEC) code in dm-verity uses
Reed-Solomon code and should support roots from 2 to 24.

The error correction parity bytes (of roots lengths per RS block) are stored
on a separate device in sequence without any padding.

Currently, to access FEC device, the dm-verity-fec code uses dm-bufio client
with block size set to verity data block (usually 4096 or 512 bytes).

Because this block size is not divisible by some (most!) of the roots
supported lengths, data repair cannot work for partially stored
parity bytes.

This patch changes FEC device dm-bufio block size to "roots << SECTOR_SHIFT"
where we can be sure that the full parity data is always available.
(There cannot be partial FEC blocks because parity must cover whole sectors.)

Because the optional FEC starting offset could be unaligned to this
new block size, we have to use dm_bufio_set_sector_offset() to configure it.

The problem is easily reproducible using veritysetup,
here for example for roots=13:

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

Without it, FEC code usually ends on unrecoverable failure in RS decoder:
  device-mapper: verity-fec: 7:1: FEC 0: failed to correct: -74
  ...

With the patch, errors are properly repaired.
  device-mapper: verity-fec: 7:1: FEC 0: corrected 8 errors
  ...

This problem is present in all kernels since the FEC code introduction (kernel 4.5).

AFAIK the problem is not visible in Android  ecosystem because it always
use default RS roots=2.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Tested-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-verity-fec.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fb41b4f23c48..66401ca1f624 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -61,18 +61,18 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
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
 	if (IS_ERR(res)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
-		      (unsigned long long)(v->fec->start + block),
+		      (unsigned long long)block,
 		      PTR_ERR(res));
 		*buf = NULL;
 	}
@@ -155,7 +155,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= 1 << v->data_dev_block_bits) {
+		if (offset >= v->fec->roots << SECTOR_SHIFT) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -674,7 +674,7 @@ int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks;
+	u64 hash_blocks, fec_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -744,15 +744,17 @@ int verity_fec_ctr(struct dm_verity *v)
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
-- 
2.30.1

