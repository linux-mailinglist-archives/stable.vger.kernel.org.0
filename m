Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3AD3C2CE3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhGJCVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231913AbhGJCU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9F7613C5;
        Sat, 10 Jul 2021 02:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883493;
        bh=NIOvFFYGolkiUWHbQp1PRNxwIQ3ks2cXnYip0cqAkgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVC6letm+zxcCqTzGQW8Td+lbuRZl+uUwEMOwru30ms38ANsrM6c0arIzeeCOzahJ
         29y/Hv+dlAWkB9871dV4qH0t8BJtbh1rajforapZeJVCEX6ecashbDjEMtYtp2aAQo
         BAHVitmUmj8dABxKqSmOllK7ayRgfiTb4XRPLF4bJwouGjMgzE/XewLshOESbUX6uQ
         iPIa0JjUnl/l+nh8xCoFiL+FrulziE03XCeC4alm3IkCrDFA7gxSL64yTw6vm0oRaA
         UbJN4oS3jMS8N9PPveQBvwD34eZnEBdmIyz5qzQKPh9o0IA6sPJPe1I6Mj0v9dUwvJ
         2Uns2Bq0Fw0aQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 017/114] partitions: msdos: fix one-byte get_unaligned()
Date:   Fri,  9 Jul 2021 22:16:11 -0400
Message-Id: <20210710021748.3167666-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1b1774998b2dec837a57d729d1a22e5eb2d6d206 ]

A simplification of get_unaligned() clashes with callers that pass
in a character pointer, causing a harmless warning like:

block/partitions/msdos.c: In function 'msdos_partition':
include/asm-generic/unaligned.h:13:22: warning: 'packed' attribute ignored for field of type 'u8' {aka 'unsigned char'} [-Wattributes]

Remove the SYS_IND() macro with the get_unaligned() call
and just use the ->ind field directly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/ldm.c   |  2 +-
 block/partitions/ldm.h   |  3 ---
 block/partitions/msdos.c | 24 +++++++++++-------------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/block/partitions/ldm.c b/block/partitions/ldm.c
index d333786b5c7e..cc86534c80ad 100644
--- a/block/partitions/ldm.c
+++ b/block/partitions/ldm.c
@@ -510,7 +510,7 @@ static bool ldm_validate_partition_table(struct parsed_partitions *state)
 
 	p = (struct msdos_partition *)(data + 0x01BE);
 	for (i = 0; i < 4; i++, p++)
-		if (SYS_IND (p) == LDM_PARTITION) {
+		if (p->sys_ind == LDM_PARTITION) {
 			result = true;
 			break;
 		}
diff --git a/block/partitions/ldm.h b/block/partitions/ldm.h
index d8d6beaa72c4..8693704dcf5e 100644
--- a/block/partitions/ldm.h
+++ b/block/partitions/ldm.h
@@ -84,9 +84,6 @@ struct parsed_partitions;
 #define TOC_BITMAP1		"config"	/* Names of the two defined */
 #define TOC_BITMAP2		"log"		/* bitmaps in the TOCBLOCK. */
 
-/* Borrowed from msdos.c */
-#define SYS_IND(p)		(get_unaligned(&(p)->sys_ind))
-
 struct frag {				/* VBLK Fragment handling */
 	struct list_head list;
 	u32		group;
diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 8f2fcc080264..c94de377c502 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -38,8 +38,6 @@
  */
 #include <asm/unaligned.h>
 
-#define SYS_IND(p)	get_unaligned(&p->sys_ind)
-
 static inline sector_t nr_sects(struct msdos_partition *p)
 {
 	return (sector_t)get_unaligned_le32(&p->nr_sects);
@@ -52,9 +50,9 @@ static inline sector_t start_sect(struct msdos_partition *p)
 
 static inline int is_extended_partition(struct msdos_partition *p)
 {
-	return (SYS_IND(p) == DOS_EXTENDED_PARTITION ||
-		SYS_IND(p) == WIN98_EXTENDED_PARTITION ||
-		SYS_IND(p) == LINUX_EXTENDED_PARTITION);
+	return (p->sys_ind == DOS_EXTENDED_PARTITION ||
+		p->sys_ind == WIN98_EXTENDED_PARTITION ||
+		p->sys_ind == LINUX_EXTENDED_PARTITION);
 }
 
 #define MSDOS_LABEL_MAGIC1	0x55
@@ -193,7 +191,7 @@ static void parse_extended(struct parsed_partitions *state,
 
 			put_partition(state, state->next, next, size);
 			set_info(state, state->next, disksig);
-			if (SYS_IND(p) == LINUX_RAID_PARTITION)
+			if (p->sys_ind == LINUX_RAID_PARTITION)
 				state->parts[state->next].flags = ADDPART_FLAG_RAID;
 			loopct = 0;
 			if (++state->next == state->limit)
@@ -546,7 +544,7 @@ static void parse_minix(struct parsed_partitions *state,
 	 * a secondary MBR describing its subpartitions, or
 	 * the normal boot sector. */
 	if (msdos_magic_present(data + 510) &&
-	    SYS_IND(p) == MINIX_PARTITION) { /* subpartition table present */
+	    p->sys_ind == MINIX_PARTITION) { /* subpartition table present */
 		char tmp[1 + BDEVNAME_SIZE + 10 + 9 + 1];
 
 		snprintf(tmp, sizeof(tmp), " %s%d: <minix:", state->name, origin);
@@ -555,7 +553,7 @@ static void parse_minix(struct parsed_partitions *state,
 			if (state->next == state->limit)
 				break;
 			/* add each partition in use */
-			if (SYS_IND(p) == MINIX_PARTITION)
+			if (p->sys_ind == MINIX_PARTITION)
 				put_partition(state, state->next++,
 					      start_sect(p), nr_sects(p));
 		}
@@ -643,7 +641,7 @@ int msdos_partition(struct parsed_partitions *state)
 	p = (struct msdos_partition *) (data + 0x1be);
 	for (slot = 1 ; slot <= 4 ; slot++, p++) {
 		/* If this is an EFI GPT disk, msdos should ignore it. */
-		if (SYS_IND(p) == EFI_PMBR_OSTYPE_EFI_GPT) {
+		if (p->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT) {
 			put_dev_sector(sect);
 			return 0;
 		}
@@ -685,11 +683,11 @@ int msdos_partition(struct parsed_partitions *state)
 		}
 		put_partition(state, slot, start, size);
 		set_info(state, slot, disksig);
-		if (SYS_IND(p) == LINUX_RAID_PARTITION)
+		if (p->sys_ind == LINUX_RAID_PARTITION)
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
-		if (SYS_IND(p) == DM6_PARTITION)
+		if (p->sys_ind == DM6_PARTITION)
 			strlcat(state->pp_buf, "[DM]", PAGE_SIZE);
-		if (SYS_IND(p) == EZD_PARTITION)
+		if (p->sys_ind == EZD_PARTITION)
 			strlcat(state->pp_buf, "[EZD]", PAGE_SIZE);
 	}
 
@@ -698,7 +696,7 @@ int msdos_partition(struct parsed_partitions *state)
 	/* second pass - output for each on a separate line */
 	p = (struct msdos_partition *) (0x1be + data);
 	for (slot = 1 ; slot <= 4 ; slot++, p++) {
-		unsigned char id = SYS_IND(p);
+		unsigned char id = p->sys_ind;
 		int n;
 
 		if (!nr_sects(p))
-- 
2.30.2

