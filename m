Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2984A91015
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfHQKhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 06:37:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51588 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfHQKhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 06:37:20 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0008PN-Ig; Sat, 17 Aug 2019 11:37:16 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0005ot-Dn; Sat, 17 Aug 2019 11:37:16 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "Jan Kara" <jack@suse.cz>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Date:   Sat, 17 Aug 2019 11:35:11 +0100
Message-ID: <lsq.1566038111.2417925@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 3/4] ext4: cleanup bh release code in ext4_ind_remove_space()
In-Reply-To: <lsq.1566038111.397675943@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.73-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangyi (F)" <yi.zhang@huawei.com>

commit 5e86bdda41534e17621d5a071b294943cae4376e upstream.

Currently, we are releasing the indirect buffer where we are done with
it in ext4_ind_remove_space(), so we can see the brelse() and
BUFFER_TRACE() everywhere.  It seems fragile and hard to read, and we
may probably forget to release the buffer some day.  This patch cleans
up the code by putting of the code which releases the buffers to the
end of the function.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/indirect.c | 47 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1313,6 +1313,7 @@ int ext4_ind_remove_space(handle_t *hand
 	ext4_lblk_t offsets[4], offsets2[4];
 	Indirect chain[4], chain2[4];
 	Indirect *partial, *partial2;
+	Indirect *p = NULL, *p2 = NULL;
 	ext4_lblk_t max_block;
 	__le32 nr = 0, nr2 = 0;
 	int n = 0, n2 = 0;
@@ -1354,7 +1355,7 @@ int ext4_ind_remove_space(handle_t *hand
 		}
 
 
-		partial = ext4_find_shared(inode, n, offsets, chain, &nr);
+		partial = p = ext4_find_shared(inode, n, offsets, chain, &nr);
 		if (nr) {
 			if (partial == chain) {
 				/* Shared branch grows from the inode */
@@ -1379,13 +1380,11 @@ int ext4_ind_remove_space(handle_t *hand
 				partial->p + 1,
 				(__le32 *)partial->bh->b_data+addr_per_block,
 				(chain+n-1) - partial);
-			BUFFER_TRACE(partial->bh, "call brelse");
-			brelse(partial->bh);
 			partial--;
 		}
 
 end_range:
-		partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
+		partial2 = p2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
 		if (nr2) {
 			if (partial2 == chain2) {
 				/*
@@ -1415,16 +1414,14 @@ end_range:
 					   (__le32 *)partial2->bh->b_data,
 					   partial2->p,
 					   (chain2+n2-1) - partial2);
-			BUFFER_TRACE(partial2->bh, "call brelse");
-			brelse(partial2->bh);
 			partial2--;
 		}
 		goto do_indirects;
 	}
 
 	/* Punch happened within the same level (n == n2) */
-	partial = ext4_find_shared(inode, n, offsets, chain, &nr);
-	partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
+	partial = p = ext4_find_shared(inode, n, offsets, chain, &nr);
+	partial2 = p2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
 
 	/* Free top, but only if partial2 isn't its subtree. */
 	if (nr) {
@@ -1481,15 +1478,7 @@ end_range:
 					   partial->p + 1,
 					   partial2->p,
 					   (chain+n-1) - partial);
-			while (partial > chain) {
-				BUFFER_TRACE(partial->bh, "call brelse");
-				brelse(partial->bh);
-			}
-			while (partial2 > chain2) {
-				BUFFER_TRACE(partial2->bh, "call brelse");
-				brelse(partial2->bh);
-			}
-			return 0;
+			goto cleanup;
 		}
 
 		/*
@@ -1504,8 +1493,6 @@ end_range:
 					   partial->p + 1,
 					   (__le32 *)partial->bh->b_data+addr_per_block,
 					   (chain+n-1) - partial);
-			BUFFER_TRACE(partial->bh, "call brelse");
-			brelse(partial->bh);
 			partial--;
 		}
 		if (partial2 > chain2 && depth2 <= depth) {
@@ -1513,11 +1500,21 @@ end_range:
 					   (__le32 *)partial2->bh->b_data,
 					   partial2->p,
 					   (chain2+n2-1) - partial2);
-			BUFFER_TRACE(partial2->bh, "call brelse");
-			brelse(partial2->bh);
 			partial2--;
 		}
 	}
+
+cleanup:
+	while (p && p > chain) {
+		BUFFER_TRACE(p->bh, "call brelse");
+		brelse(p->bh);
+		p--;
+	}
+	while (p2 && p2 > chain2) {
+		BUFFER_TRACE(p2->bh, "call brelse");
+		brelse(p2->bh);
+		p2--;
+	}
 	return 0;
 
 do_indirects:
@@ -1525,7 +1522,7 @@ do_indirects:
 	switch (offsets[0]) {
 	default:
 		if (++n >= n2)
-			return 0;
+			break;
 		nr = i_data[EXT4_IND_BLOCK];
 		if (nr) {
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
@@ -1533,7 +1530,7 @@ do_indirects:
 		}
 	case EXT4_IND_BLOCK:
 		if (++n >= n2)
-			return 0;
+			break;
 		nr = i_data[EXT4_DIND_BLOCK];
 		if (nr) {
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
@@ -1541,7 +1538,7 @@ do_indirects:
 		}
 	case EXT4_DIND_BLOCK:
 		if (++n >= n2)
-			return 0;
+			break;
 		nr = i_data[EXT4_TIND_BLOCK];
 		if (nr) {
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
@@ -1550,5 +1547,5 @@ do_indirects:
 	case EXT4_TIND_BLOCK:
 		;
 	}
-	return 0;
+	goto cleanup;
 }

