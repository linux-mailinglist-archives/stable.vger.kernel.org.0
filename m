Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD28B59CA8F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 23:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiHVVMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 17:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiHVVMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 17:12:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D8D558DD;
        Mon, 22 Aug 2022 14:12:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 20so11042765plo.10;
        Mon, 22 Aug 2022 14:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=N/X2QE0vyj5059Rl5tVrIDqj6J5xUx1xeSxzqqjIZwk=;
        b=A9LhYVupLFArYEg2GXauf91psX284WIhJQKEVDD8trGIlyhhqntsy1tcMIHqlgNndq
         jU+ApOrRpfbeTzJyg27aBn21DFsPE4H7+1Kxb4rB8DQ2KGRkWBZgUC5vU7QBaPLPxl0t
         O2g6+oa9gnDdMbB7Q6d0yucccGChVoCLm5eMl9M31p9KvMKKcE9m4bE7M+mlSU4IB7vW
         jqoc41gUn7qzHeAejOFkIKx7IOk/bTVsuul6+KNbTNenm8YuXoVW6TdyaceCtl04CJD4
         oT8F/oU6SCgNHuj+2PSQqyFuYUtJpDvdGSW/je8/N2w9ydqYJVqW+Q7SCD3lwOMhjXZh
         m7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=N/X2QE0vyj5059Rl5tVrIDqj6J5xUx1xeSxzqqjIZwk=;
        b=ueXsB47CZxgN16jnscxIEUC54XDBXXlg6aFNSjqwG3qMTog5wwoLh8CYTSKVX/CcEl
         UUruvaFUunTJazkiaMMJWAL3an4P/sKAZSNeE6+2/Wu/2vDF87L04C5lNJL9IIZuWm8C
         CMFPB0jGB9hcaQB+uduvxzxaNjSCglKVW6CXA1fA1RgdtusEYQPJTmlRDDGHchROHD8k
         u/ijjCWseVp2JcEyR/0xfyfSdy7bgFL69ty3Tv411CAnwVvBX4USwVX5UjHItwBw1qMU
         FBvlb13mKQT/I0UkVTm1T/6tRJiiDV5lG780sYMSMTgNZ3XzRmcoXracVNYAqaOoQWXw
         IyRQ==
X-Gm-Message-State: ACgBeo2BFaZ9lc0/R3ZsxZoW3ytTNCuu/NJa8NAt6x8fVu/2PGWxf70V
        aVbZfDSpQSnJBWrt6RAwZSgJROMx4uM=
X-Google-Smtp-Source: AA6agR7VqNIKa4r3H8A7If6mRs7XoVKt9kVYuEJr+/K3ThRsx2klVL8SKZT3kPE30OaLG7qIR/pGoQ==
X-Received: by 2002:a17:902:d484:b0:16f:161c:ac3f with SMTP id c4-20020a170902d48400b0016f161cac3fmr21541438plg.107.1661202763306;
        Mon, 22 Aug 2022 14:12:43 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id 83-20020a621756000000b0052b84ca900csm9099112pfx.62.2022.08.22.14.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:12:43 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 1D9D236031F; Tue, 23 Aug 2022 09:12:40 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, hch@lst.de,
        Michael Schmitz <schmitzmic@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v9 RESEND #2 1/2] block: fix signed int overflow in Amiga partition support
Date:   Tue, 23 Aug 2022 09:12:35 +1200
Message-Id: <20220822211236.9023-2-schmitzmic@gmail.com>
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

Use sector_t as type for sector address and size to allow using disks
up to 2 TB without LBD support, and disks larger than 2 TB with LBD.

This bug was reported originally in 2012, and the fix was created by
the RDB author, Joanne Dow <jdow@earthlink.net>. A patch had been
discussed and reviewed on linux-m68k at that time but never officially
submitted. This patch differs from Joanne's patch only in its use of
sector_t instead of unsigned int. No checking for overflows is done
(see patch 2 of this series for that).

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43511
Fixes: 1da177e4c3f41524 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org> # 5.2
Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
Message-ID: <201206192146.09327.Martin@lichtvoll.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Martin Steigerwald <Martin@lichtvoll.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---

Changes from v3:

- split off change of sector address type as quick fix.
- cast to sector_t in sector address calculations.
- move overflow checking to separate patch for more thorough review.

Changes from v4:

Andreas Schwab:
- correct cast to sector_t in sector address calculations

Changes from v7:

Christoph Hellwig
- correct style issues
---
 block/partitions/amiga.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 5c8624e26a54..85c5c79aae48 100644
--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -31,7 +31,8 @@ int amiga_partition(struct parsed_partitions *state)
 	unsigned char *data;
 	struct RigidDiskBlock *rdb;
 	struct PartitionBlock *pb;
-	int start_sect, nr_sects, blk, part, res = 0;
+	sector_t start_sect, nr_sects;
+	int blk, part, res = 0;
 	int blksize = 1;	/* Multiplier for disk block size */
 	int slot = 1;
 
@@ -96,14 +97,14 @@ int amiga_partition(struct parsed_partitions *state)
 
 		/* Tell Kernel about it */
 
-		nr_sects = (be32_to_cpu(pb->pb_Environment[10]) + 1 -
-			    be32_to_cpu(pb->pb_Environment[9])) *
+		nr_sects = ((sector_t)be32_to_cpu(pb->pb_Environment[10]) + 1 -
+			   be32_to_cpu(pb->pb_Environment[9])) *
 			   be32_to_cpu(pb->pb_Environment[3]) *
 			   be32_to_cpu(pb->pb_Environment[5]) *
 			   blksize;
 		if (!nr_sects)
 			continue;
-		start_sect = be32_to_cpu(pb->pb_Environment[9]) *
+		start_sect = (sector_t)be32_to_cpu(pb->pb_Environment[9]) *
 			     be32_to_cpu(pb->pb_Environment[3]) *
 			     be32_to_cpu(pb->pb_Environment[5]) *
 			     blksize;
-- 
2.17.1

