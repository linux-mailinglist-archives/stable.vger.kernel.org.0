Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E625860C56C
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 09:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiJYHhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 03:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiJYHhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 03:37:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DDB9186C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:37:08 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b2so10352549eja.6
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q62BXo1sUE/A7oBeCBFMb3IRGsZ8ne8pgvaqkcg6rqk=;
        b=LoSpLLvbaQdrc8sxLciYVrpC5WT+DRd48s1s750iRun8RkwECoZ1COwzBcQbphlTsL
         n6ApWbOjSXr41nL6RCy+wXuf4Q7PQyfpsTTtIeOVOZXdXyg7kwDI+eiFR+DnwWRPjEGp
         PUkWunx0E4i2yW5bQmrH5tApL0cK4sGPQEXIV5NqTyIvdWWr2nMibLdvPwzfZdB353oQ
         cV6GBYRGnzWyRoHajwdiYa+tJt+3wGqM1nCLv4cUgJgY+eV6+a1AfBsDFJRpe4uiZsyB
         CD6Y7mpKfPJgcuyo+D9ect3vcm+U2ad7rsB5bX1CjvinIGfXi1b8bfn2tXvXBx2ztYMO
         LOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q62BXo1sUE/A7oBeCBFMb3IRGsZ8ne8pgvaqkcg6rqk=;
        b=EvDO1/uslJpI78IVCBy3qAtS7ju7rCtVnI5j8ANWYOAdFERFnfCV2FWcOAKRHyRJfJ
         lfmRt1zVZjPKnRx2nDvwrruEwIgOsLZa4X1uldv40/wpD8DvItp5YR+Zy3tXUz7rWuV8
         vCDGXIZF+Pq/OjGgdn1id2g+qxyGqSvQz0aqs87P9Yqe9+Er5mElErs80Q+i87ga3fPJ
         h1TbIWmp94Pl8fY0pUD+eo4gYgHp1Mo/QFxQmvTIjfzUbEi9K/w9PCjHt+a7JDsahVYf
         8STrXGj5Z83IObkPiPNpMR9ZbKweAyuKTXh8iAv4GSQPij9tGQvuCicZ1jpzq9VXAfue
         E53A==
X-Gm-Message-State: ACrzQf1BRDeRrA+FNuM8zK0EWp2BAyQGCetq2a78/MRsvzneJSj2aS0X
        QhW0/TCMZlMHaPSu5vUSqUR7XEoOGqeM3Q==
X-Google-Smtp-Source: AMsMyM4IKVQrHGhP9O593qinEjIBwx0l2Gkir4iOByK1CLvEBYybHeHeisQ7apaJk4W1SeU0MTu2IQ==
X-Received: by 2002:a17:907:7638:b0:7aa:987f:4e91 with SMTP id jy24-20020a170907763800b007aa987f4e91mr5287570ejc.442.1666683427000;
        Tue, 25 Oct 2022 00:37:07 -0700 (PDT)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:1417:db00:fbfd:10a3:7b84:252c])
        by smtp.gmail.com with ESMTPSA id gs18-20020a170906f19200b007a62215eb4esm965342ejb.16.2022.10.25.00.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 00:37:06 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        stable@vger.kernel.org
Subject: [PATCHv3] md/bitmap: Fix bitmap chunk size overflow issues
Date:   Tue, 25 Oct 2022 09:37:05 +0200
Message-Id: <20221025073705.17692-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Song Liu <song@kernel.org>
---
v3: fix build warning on i386.
 drivers/md/md-bitmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 63ece30114e5..e7cc6ba1b657 100644
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
@@ -2537,6 +2538,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	if (csize < 512 ||
 	    !is_power_of_2(csize))
 		return -EINVAL;
+	if (BITS_PER_LONG > 32 && csize >= (1ULL << (BITS_PER_BYTE *
+		sizeof(((bitmap_super_t *)0)->chunksize))))
+		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
 }
-- 
2.34.1

