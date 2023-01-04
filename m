Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7B465D90F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjADQVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239765AbjADQU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829A863FE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 224C46177C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2917EC433EF;
        Wed,  4 Jan 2023 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849256;
        bh=1yD27mWLNBYI9eyGvQ2BPyVDuiK7l6bZM0wpZQs7J5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgmtckT9L2BUZSMa+wpxXIVYWnF2UaE9yexmricSlkOo7BUB+mFFiekNMmkYRoH8m
         NQj54GMFwD8z/qkRKQ8s6FTbxRxL+GaLgKy27r4uW70tb6ztfi+oD1fe7BBNmi6MXe
         W/bEt/l5hbT7J3wclvmCTa0Mm/fJ+ZsFQHV7h4x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, Song Liu <song@kernel.org>
Subject: [PATCH 6.0 090/177] md/bitmap: Fix bitmap chunk size overflow issues
Date:   Wed,  4 Jan 2023 17:06:21 +0100
Message-Id: <20230104160510.368909507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

commit 4555211190798b6b6fa2c37667d175bf67945c78 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *b
 	sb = kmap_atomic(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
-	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
+	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
 	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
 		 le32_to_cpu(*(__le32 *)(sb->uuid+0)),
 		 le32_to_cpu(*(__le32 *)(sb->uuid+4)),
@@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *b
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
 
@@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitm
 			bytes = DIV_ROUND_UP(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
 				bytes += sizeof(bitmap_super_t);
-		} while (bytes > (space << 9));
+		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
+			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
 	} else
 		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
 
@@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitm
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
@@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitm
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
@@ -2537,6 +2538,9 @@ chunksize_store(struct mddev *mddev, con
 	if (csize < 512 ||
 	    !is_power_of_2(csize))
 		return -EINVAL;
+	if (BITS_PER_LONG > 32 && csize >= (1ULL << (BITS_PER_BYTE *
+		sizeof(((bitmap_super_t *)0)->chunksize))))
+		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
 }


