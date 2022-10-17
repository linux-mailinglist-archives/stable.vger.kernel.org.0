Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72259600C0E
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 12:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJQKKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 06:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiJQKKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 06:10:03 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D005F2BB18
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 03:09:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id r17so23704845eja.7
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 03:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6DCblaajzz3mwQyFYu391W26ToVOeSQSUoFjijUTHs8=;
        b=cdP6G3RjL4n4HZoBM6y19Ze4BwZNGN2JB+469S0Njn9VStt6GP8NlYSGS6XwVGtBCU
         mApJkTsr+XsumQxWnzWxxThw25CoJ3xPnj0x7SrIDMCsqnOVFkOjy1JCxW22Xrna2peA
         jG1Pec0q90Jw0xNpUc2C9pym+w8c6yQL0Ibj3ygMeiryaU9hDJElCPUHE3tUqu92BHjU
         oeFfgMjDG3SZ67t/2avI6QmM3HHmm2lbL0DzrDzPeRTwBHI4yDI1iCXpIpigOnb9IWE9
         rxfaeokwDvh6NNe1/YTS4kpO34KDYSfXA8enMgYh47+sUAoF8gPl0lk++7hWJn/j4vqf
         g+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6DCblaajzz3mwQyFYu391W26ToVOeSQSUoFjijUTHs8=;
        b=O/dJPANxhQ65D8uICuzBmKvLLItwhzdi1t8jgoEAt1B1nq3S7oAoxyEqH7YyWCTgtA
         wqXW9uSXtgi3PMEIz5P7+ELs5ofi7xSxgbj2a2SArILzLVkd0xofdpplnxZcvCs/i69K
         Esan0Er6q/Ta0C9lPEQgdPxX1ugfpMY/osrnNUIv/UTq2w0Q4PfArcfq1TiuRYCzb+qy
         GS95ENugAWVqRaitsMjEUJsJ1MqVgrQ++AF5cv8b76Ckk09qrPiL1ESY4sLby/rw4IWk
         e8dT/cCYZnQr+BexEyFaoceiGdFQY/353SZ/+iVX8AGM8leWb8OqKdUmIx+sSKw6dvmu
         U/dQ==
X-Gm-Message-State: ACrzQf2z1Zq9+3Auw62vp0/ZDho0LhUkl3Mb0zwpH5b/9BkLhj3t1TZF
        CEAWKZrqiQwGobopwkU6o2qwXg==
X-Google-Smtp-Source: AMsMyM7gxAUO068ioP7tvUAylJaKTh59uHW+WkOLVXek9Z5dLzYRVg/Twfkt+NJ0cAfEoEteZ+bQVQ==
X-Received: by 2002:a17:906:db07:b0:77b:82cf:54af with SMTP id xj7-20020a170906db0700b0077b82cf54afmr8231844ejb.666.1666001393209;
        Mon, 17 Oct 2022 03:09:53 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:142e:f700:8ccf:9069:42be:668e])
        by smtp.gmail.com with ESMTPSA id b21-20020aa7d495000000b004580862ffdbsm7040594edr.59.2022.10.17.03.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 03:09:52 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        stable@vger.kernel.org
Subject: [PATCHv2] md/bitmap: Fix bitmap chunk size overflow issues
Date:   Mon, 17 Oct 2022 12:09:51 +0200
Message-Id: <20221017100951.22727-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

- limit bitmap chunk size internal u64 variable to values not overflowing
  the u32 bitmap superblock structure variable stored on persistent media
- assign bitmap chunk size internal u64 variable from unsigned values to
  avoid possible sign extension artifacts when assigning from a s32 value

The bug has been there since at least kernel 4.0.
Steps to reproduce it:
1: mdadm -C /dev/mdx -l 1 --bitmap=internal --bitmap-chunk=256M -e 1.2
-n2 /dev/rnbd1 /dev/rnbd2
2 resize member device rnbd1 and rnbd2 to 8 TB
3 mdadm --grow /dev/mdx --size=max

The bitmap_chunksize will overflow without patch.

Cc: stable@vger.kernel.org

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
v1->v2: extend commit message for steps to reproduce the problem.
        fix the warning reported by buildbot

 drivers/md/md-bitmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..d4bf7f603ef6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	sb = kmap_atomic(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
-	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
+	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
 	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
 		 le32_to_cpu(*(__le32 *)(sb->uuid+0)),
 		 le32_to_cpu(*(__le32 *)(sb->uuid+4)),
@@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("events cleared: %llu\n",
 		 (unsigned long long) le64_to_cpu(sb->events_cleared));
 	pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
-	pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
+	pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
 	pr_debug("     sync size: %llu KB\n",
 		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
-	pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
+	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
 	kunmap_atomic(sb);
 }
 
@@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			bytes = DIV_ROUND_UP(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
 				bytes += sizeof(bitmap_super_t);
-		} while (bytes > (space << 9));
+		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
+			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
 	} else
 		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
 
@@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
@@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				bitmap->counts.missing_pages = old_counts.pages;
 				bitmap->counts.chunkshift = old_counts.chunkshift;
 				bitmap->counts.chunks = old_counts.chunks;
-				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
-									     BITMAP_BLOCK_SHIFT);
+				bitmap->mddev->bitmap_info.chunksize =
+					1UL << (old_counts.chunkshift + BITMAP_BLOCK_SHIFT);
 				blocks = old_counts.chunks << old_counts.chunkshift;
 				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
 				break;
@@ -2534,6 +2535,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	if (csize < 512 ||
 	    !is_power_of_2(csize))
 		return -EINVAL;
+	if (csize >= (1ULL << (BITS_PER_BYTE *
+		sizeof(((bitmap_super_t *)0)->chunksize))))
+		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
 }
-- 
2.34.1

