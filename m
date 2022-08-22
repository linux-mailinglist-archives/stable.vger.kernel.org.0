Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0159CA8E
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 23:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiHVVMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 17:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiHVVMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 17:12:46 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0924DB20;
        Mon, 22 Aug 2022 14:12:44 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s206so10517850pgs.3;
        Mon, 22 Aug 2022 14:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=CHMD7ViEoir19ulN0n/TmFDdy0sPIFiFNZ+oytn7T3Q=;
        b=ixe6FKSwlovcyxR6vpt4UPib2Mj7rmTCQ8opZ7L8eMyOPmzefc9xgYYuSEsHbtQfcN
         3nvyMATUOZYVtEx4ahdUTGIqZV0j1hbeVKTKgOEb9RUSVj7jf1foq40a8/9ddPfa+XL9
         t3aUbcMycxn78lrcAAFzNCnpEVQW4wfLWhXXhXB2nRYoRZnIFksqJCpRjQlta+wVD7q3
         wDBFSnfe0YNyk7eDGCIdTjsJCDVBxHC70zzOaPMI57b68tCMMJx8yGFCFtXX7chpTq5R
         cmIwp28/jF9NCKmYWa8sB2Q10YUsu+YjP4//+B9QGsd5br7oQL8KYMcXnhrtV8cICEkG
         XLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=CHMD7ViEoir19ulN0n/TmFDdy0sPIFiFNZ+oytn7T3Q=;
        b=KIq36hUEYMQiGoVYozwdNJoLeIWRDXuBKLXlh5s2tTz+UqCVhnqR7NpdX/f83OC9Au
         Idrvk/fS+oJut/4eTXwJbj9OnvcT9cZ57vMZiJ5koFFdDq8q/pgZtm8n75mz/w6xLHIx
         Hz5jwzooPXf6qAK3CCjZQpu/3XY6YZadiSb42QYLjG/yoyIOSVI8qqWyNnRz1zBKRFyH
         VzgZzO5JkBGUgtZJz+mkq2A0RAXGt14O75r9/ybWz4aUYQ1Oe7T5tPJeI4FwN1Eyq3j+
         0N3OmMTMqD3p7sHjxLVFYVJPjbrtPHHC3N/IGs7Q/B6tOi2DFjMc0DscdkpM/vcRdeUt
         TYgA==
X-Gm-Message-State: ACgBeo1xYptFYvwy1jk7wkZ6WoqbqsXHoek1xWFTIwxppvpAqV08htOc
        rYKUg4MXCgi1kqdozRHjhgc=
X-Google-Smtp-Source: AA6agR6H4atjR4N1uYffvRjgWmfWtR4Kj1KcGcDXxAyQ7p9WxRBiKL1ByVONtqJYyVOsD87pgNIogw==
X-Received: by 2002:a63:6ac3:0:b0:41d:17dc:eb66 with SMTP id f186-20020a636ac3000000b0041d17dceb66mr17875090pgc.384.1661202764339;
        Mon, 22 Aug 2022 14:12:44 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id e3-20020a056a0000c300b00536d3ac847csm1633158pfj.0.2022.08.22.14.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:12:44 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D2B3E360326; Tue, 23 Aug 2022 09:12:40 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, hch@lst.de,
        Michael Schmitz <schmitzmic@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v9 RESEND #2 2/2] block: add overflow checks for Amiga partition support
Date:   Tue, 23 Aug 2022 09:12:36 +1200
Message-Id: <20220822211236.9023-3-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220822211236.9023-1-schmitzmic@gmail.com>
References: <20220822211236.9023-1-schmitzmic@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Amiga partition parser module uses signed int for partition sector
address and count, which will overflow for disks larger than 1 TB.

Use u64 as type for sector address and size to allow using disks up to
2 TB without LBD support, and disks larger than 2 TB with LBD. The RBD
format allows to specify disk sizes up to 2^128 bytes (though native
OS limitations reduce this somewhat, to max 2^68 bytes), so check for
u64 overflow carefully to protect against overflowing sector_t.

Bail out if sector addresses overflow 32 bits on kernels without LBD
support.

This bug was reported originally in 2012, and the fix was created by
the RDB author, Joanne Dow <jdow@earthlink.net>. A patch had been
discussed and reviewed on linux-m68k at that time but never officially
submitted (now resubmitted as separate patch).
This patch adds additional error checking and warning messages.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43511
Fixes: 1da177e4c3f41524 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org> # 5.2
Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
Message-ID: <201206192146.09327.Martin@lichtvoll.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@infradead.org>

---

Changes from RFC:

- use u64 instead of sector_t, since that may be u32 without LBD support
- check multiplication overflows each step - 3 u32 values may exceed u64!
- warn against use on AmigaDOS if partition data overflow u32 sector count.
- warn if partition CylBlocks larger than what's stored in the RDSK header.
- bail out if we were to overflow sector_t (32 or 64 bit).

Changes from v1:

Kars de Jong:
- use defines for magic offsets in DosEnvec struct

Geert Uytterhoeven:
- use u64 cast for multiplications of u32 numbers
- use array3_size for overflow checks
- change pr_err to pr_warn
- discontinue use of pr_cont
- reword log messages
- drop redundant nr_sects overflow test
- warn against 32 bit overflow for each affected partition
- skip partitions that overflow sector_t size instead of aborting scan

Changes from v2:

- further trim 32 bit overflow test
- correct duplicate types.h inclusion introduced in v2

Changes from v3:

- split off sector address type fix for independent review
- change blksize to unsigned
- use check_mul_overflow() instead of array3_size()
- rewrite checks to avoid 64 bit divisions in check_mul_overflow()

Changes from v5:

Geert Uytterhoeven:
- correct ineffective u64 cast to avoid 32 bit mult. overflow
- fix mult. overflow in partition block address calculation

Changes from v6:

Geert Uytterhoeven:
- don't fail hard on partition block address overflow

Changes from v7:

- replace bdevname(state->bdev, b) by state->disk->disk_name
- drop warn_no_part conditionals
- remove remaining warn_no_part

Changes from v8:

Christoph Hellwig:
- whitespace fix, drop unnecessary u64 casts

kbuid warning:
- sparse warning fix
---
 block/partitions/amiga.c | 103 ++++++++++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 18 deletions(-)

diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 85c5c79aae48..e28a4b917822 100644
--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -11,10 +11,18 @@
 #define pr_fmt(fmt) fmt
 
 #include <linux/types.h>
+#include <linux/mm_types.h>
+#include <linux/overflow.h>
 #include <linux/affs_hardblocks.h>
 
 #include "check.h"
 
+/* magic offsets in partition DosEnvVec */
+#define NR_HD	3
+#define NR_SECT	5
+#define LO_CYL	9
+#define HI_CYL	10
+
 static __inline__ u32
 checksum_block(__be32 *m, int size)
 {
@@ -31,9 +39,12 @@ int amiga_partition(struct parsed_partitions *state)
 	unsigned char *data;
 	struct RigidDiskBlock *rdb;
 	struct PartitionBlock *pb;
-	sector_t start_sect, nr_sects;
-	int blk, part, res = 0;
-	int blksize = 1;	/* Multiplier for disk block size */
+	u64 start_sect, nr_sects;
+	sector_t blk, end_sect;
+	u32 cylblk;		/* rdb_CylBlocks = nr_heads*sect_per_track */
+	u32 nr_hd, nr_sect, lo_cyl, hi_cyl;
+	int part, res = 0;
+	unsigned int blksize = 1;	/* Multiplier for disk block size */
 	int slot = 1;
 
 	for (blk = 0; ; blk++, put_dev_sector(sect)) {
@@ -41,7 +52,7 @@ int amiga_partition(struct parsed_partitions *state)
 			goto rdb_done;
 		data = read_part_sector(state, blk, &sect);
 		if (!data) {
-			pr_err("Dev %s: unable to read RDB block %d\n",
+			pr_err("Dev %s: unable to read RDB block %llu\n",
 			       state->disk->disk_name, blk);
 			res = -1;
 			goto rdb_done;
@@ -58,12 +69,12 @@ int amiga_partition(struct parsed_partitions *state)
 		*(__be32 *)(data+0xdc) = 0;
 		if (checksum_block((__be32 *)data,
 				be32_to_cpu(rdb->rdb_SummedLongs) & 0x7F)==0) {
-			pr_err("Trashed word at 0xd0 in block %d ignored in checksum calculation\n",
+			pr_err("Trashed word at 0xd0 in block %llu ignored in checksum calculation\n",
 			       blk);
 			break;
 		}
 
-		pr_err("Dev %s: RDB in block %d has bad checksum\n",
+		pr_err("Dev %s: RDB in block %llu has bad checksum\n",
 		       state->disk->disk_name, blk);
 	}
 
@@ -80,10 +91,15 @@ int amiga_partition(struct parsed_partitions *state)
 	blk = be32_to_cpu(rdb->rdb_PartitionList);
 	put_dev_sector(sect);
 	for (part = 1; blk>0 && part<=16; part++, put_dev_sector(sect)) {
-		blk *= blksize;	/* Read in terms partition table understands */
+		/* Read in terms partition table understands */
+		if (check_mul_overflow(blk, (sector_t) blksize, &blk)) {
+			pr_err("Dev %s: overflow calculating partition block %llu! Skipping partitions %u and beyond\n",
+				state->disk->disk_name, blk, part);
+			break;
+		}
 		data = read_part_sector(state, blk, &sect);
 		if (!data) {
-			pr_err("Dev %s: unable to read partition block %d\n",
+			pr_err("Dev %s: unable to read partition block %llu\n",
 			       state->disk->disk_name, blk);
 			res = -1;
 			goto rdb_done;
@@ -95,19 +111,70 @@ int amiga_partition(struct parsed_partitions *state)
 		if (checksum_block((__be32 *)pb, be32_to_cpu(pb->pb_SummedLongs) & 0x7F) != 0 )
 			continue;
 
-		/* Tell Kernel about it */
+		/* RDB gives us more than enough rope to hang ourselves with,
+		 * many times over (2^128 bytes if all fields max out).
+		 * Some careful checks are in order, so check for potential
+		 * overflows.
+		 * We are multiplying four 32 bit numbers to one sector_t!
+		 */
+
+		nr_hd   = be32_to_cpu(pb->pb_Environment[NR_HD]);
+		nr_sect = be32_to_cpu(pb->pb_Environment[NR_SECT]);
+
+		/* CylBlocks is total number of blocks per cylinder */
+		if (check_mul_overflow(nr_hd, nr_sect, &cylblk)) {
+			pr_err("Dev %s: heads*sects %u overflows u32, skipping partition!\n",
+				state->disk->disk_name, cylblk);
+			continue;
+		}
+
+		/* check for consistency with RDB defined CylBlocks */
+		if (cylblk > be32_to_cpu((__be32)rdb->rdb_CylBlocks)) {
+			pr_warn("Dev %s: cylblk %u > rdb_CylBlocks %u!\n",
+				state->disk->disk_name, cylblk,
+				be32_to_cpu(rdb->rdb_CylBlocks));
+		}
+
+		/* RDB allows for variable logical block size -
+		 * normalize to 512 byte blocks and check result.
+		 */
+
+		if (check_mul_overflow(cylblk, blksize, &cylblk)) {
+			pr_err("Dev %s: partition %u bytes per cyl. overflows u32, skipping partition!\n",
+				state->disk->disk_name, part);
+			continue;
+		}
+
+		/* Calculate partition start and end. Limit of 32 bit on cylblk
+		 * guarantees no overflow occurs if LBD support is enabled.
+		 */
+
+		lo_cyl = be32_to_cpu(pb->pb_Environment[LO_CYL]);
+		start_sect = ((u64) lo_cyl * cylblk);
+
+		hi_cyl = be32_to_cpu(pb->pb_Environment[HI_CYL]);
+		nr_sects = (((u64) hi_cyl - lo_cyl + 1) * cylblk);
 
-		nr_sects = ((sector_t)be32_to_cpu(pb->pb_Environment[10]) + 1 -
-			   be32_to_cpu(pb->pb_Environment[9])) *
-			   be32_to_cpu(pb->pb_Environment[3]) *
-			   be32_to_cpu(pb->pb_Environment[5]) *
-			   blksize;
 		if (!nr_sects)
 			continue;
-		start_sect = (sector_t)be32_to_cpu(pb->pb_Environment[9]) *
-			     be32_to_cpu(pb->pb_Environment[3]) *
-			     be32_to_cpu(pb->pb_Environment[5]) *
-			     blksize;
+
+		/* Warn user if partition end overflows u32 (AmigaDOS limit) */
+
+		if ((start_sect + nr_sects) > UINT_MAX) {
+			pr_warn("Dev %s: partition %u (%llu-%llu) needs 64 bit device support!\n",
+				state->disk->disk_name, part,
+				start_sect, start_sect + nr_sects);
+		}
+
+		if (check_add_overflow(start_sect, nr_sects, &end_sect)) {
+			pr_err("Dev %s: partition %u (%llu-%llu) needs LBD device support, skipping partition!\n",
+				state->disk->disk_name, part,
+				start_sect, end_sect);
+			continue;
+		}
+
+		/* Tell Kernel about it */
+
 		put_partition(state,slot++,start_sect,nr_sects);
 		{
 			/* Be even more informative to aid mounting */
-- 
2.17.1

