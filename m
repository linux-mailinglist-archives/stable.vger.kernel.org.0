Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0828730B
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 13:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgJHLCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 07:02:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56610 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHLCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 07:02:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AxWMo123624;
        Thu, 8 Oct 2020 11:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=iA7FsH2yfLhZah7k5IYFQh92WFeqRDxQdU06/NPvqFo=;
 b=v/ASVHOH03vSN9pD4cxdNEmMrKdnQFxGL8RJ96l5vQlEAoa8+VrX4UGEpi75dlv1Tptd
 UnlQYJ1WQovkohxPGgRo2zh0DDR30sxMsDAAJCnyMRqAm77kJt6Eo68NW1ko8FI5+AXT
 PyQ35pt2YZ+nANlB+ucgG4lU9dRl84Lv8APEdU+cfT1mfpXRTE8tN9c8js0hgJH510TD
 NzWRlXn6Yt5eW5qtzo8Fqb86d3U5gElqjCoCuzWPJAuxuvtjJB2vfW2vDiCwJmYroVzb
 SCD7Wa8Mw4vuKNLjU9TGHHqeaOex1cvOQpwF1xncc7TivInL/MiPz8gMURH5Ti82Dvop tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxn6xb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 11:02:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AuE7F188463;
        Thu, 8 Oct 2020 11:00:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y380yvdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 11:00:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098B0EUG023479;
        Thu, 8 Oct 2020 11:00:14 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 04:00:13 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-5.4 4/6] btrfs: Ensure we trim ranges across block group boundary
Date:   Thu,  8 Oct 2020 18:59:52 +0800
Message-Id: <e7c79e3e83c4914866f953f55458a13dc449459e.1599750901.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1599750901.git.anand.jain@oracle.com>
References: <cover.1599750901.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 6b7faadd985c990324b5b5bd18cc4ba5c395eb65 upstream.

[BUG]
When deleting large files (which cross block group boundary) with
discard mount option, we find some btrfs_discard_extent() calls only
trimmed part of its space, not the whole range:

  btrfs_discard_extent: type=0x1 start=19626196992 len=2144530432 trimmed=1073741824 ratio=50%

type:		bbio->map_type, in above case, it's SINGLE DATA.
start:		Logical address of this trim
len:		Logical length of this trim
trimmed:	Physically trimmed bytes
ratio:		trimmed / len

Thus leaving some unused space not discarded.

[CAUSE]
When discard mount option is specified, after a transaction is fully
committed (super block written to disk), we begin to cleanup pinned
extents in the following call chain:

btrfs_commit_transaction()
|- btrfs_finish_extent_commit()
   |- find_first_extent_bit(unpin, 0, &start, &end, EXTENT_DIRTY);
   |- btrfs_discard_extent()

However, pinned extents are recorded in an extent_io_tree, which can
merge adjacent extent states.

When a large file gets deleted and it has adjacent file extents across
block group boundary, we will get a large merged range like this:

      |<---    BG1    --->|<---      BG2     --->|
      |//////|<--   Range to discard   --->|/////|

To discard that range, we have the following calls:

  btrfs_discard_extent()
  |- btrfs_map_block()
  |  Returned bbio will end at BG1's end. As btrfs_map_block()
  |  never returns result across block group boundary.
  |- btrfs_issuse_discard()
     Issue discard for each stripe.

So we will only discard the range in BG1, not the remaining part in BG2.

Furthermore, this bug is not that reliably observed, for above case, if
there is no other extent in BG2, BG2 will be empty and btrfs will trim
all space of BG2, covering up the bug.

[FIX]
- Allow __btrfs_map_block_for_discard() to modify @length parameter
  btrfs_map_block() uses its @length paramter to notify the caller how
  many bytes are mapped in current call.
  With __btrfs_map_block_for_discard() also modifing the @length,
  btrfs_discard_extent() now understands when to do extra trim.

- Call btrfs_map_block() in a loop until we hit the range end Since we
  now know how many bytes are mapped each time, we can iterate through
  each block group boundary and issue correct trim for each range.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/extent-tree.c | 41 +++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.c     |  6 ++++--
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ef05cbacef73..a546212594e8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1306,8 +1306,10 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 u64 num_bytes, u64 *actual_bytes)
 {
-	int ret;
+	int ret = 0;
 	u64 discarded_bytes = 0;
+	u64 end = bytenr + num_bytes;
+	u64 cur = bytenr;
 	struct btrfs_bio *bbio = NULL;
 
 
@@ -1316,15 +1318,23 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 	 * associated to its stripes that don't go away while we are discarding.
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
-	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(fs_info, BTRFS_MAP_DISCARD, bytenr, &num_bytes,
-			      &bbio, 0);
-	/* Error condition is -ENOMEM */
-	if (!ret) {
-		struct btrfs_bio_stripe *stripe = bbio->stripes;
+	while (cur < end) {
+		struct btrfs_bio_stripe *stripe;
 		int i;
 
+		num_bytes = end - cur;
+		/* Tell the block device(s) that the sectors can be discarded */
+		ret = btrfs_map_block(fs_info, BTRFS_MAP_DISCARD, cur,
+				      &num_bytes, &bbio, 0);
+		/*
+		 * Error can be -ENOMEM, -ENOENT (no such chunk mapping) or
+		 * -EOPNOTSUPP. For any such error, @num_bytes is not updated,
+		 * thus we can't continue anyway.
+		 */
+		if (ret < 0)
+			goto out;
 
+		stripe = bbio->stripes;
 		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
 			u64 bytes;
 			struct request_queue *req_q;
@@ -1341,10 +1351,19 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 						  stripe->physical,
 						  stripe->length,
 						  &bytes);
-			if (!ret)
+			if (!ret) {
 				discarded_bytes += bytes;
-			else if (ret != -EOPNOTSUPP)
-				break; /* Logic errors or -ENOMEM, or -EIO but I don't know how that could happen JDM */
+			} else if (ret != -EOPNOTSUPP) {
+				/*
+				 * Logic errors or -ENOMEM, or -EIO, but
+				 * unlikely to happen.
+				 *
+				 * And since there are two loops, explicitly
+				 * go to out to avoid confusion.
+				 */
+				btrfs_put_bbio(bbio);
+				goto out;
+			}
 
 			/*
 			 * Just in case we get back EOPNOTSUPP for some reason,
@@ -1354,7 +1373,9 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			ret = 0;
 		}
 		btrfs_put_bbio(bbio);
+		cur += num_bytes;
 	}
+out:
 	btrfs_bio_counter_dec(fs_info);
 
 	if (actual_bytes)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1dba45d43485..ad540283d455 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5674,12 +5674,13 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
  * replace.
  */
 static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
-					 u64 logical, u64 length,
+					 u64 logical, u64 *length_ret,
 					 struct btrfs_bio **bbio_ret)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
 	struct btrfs_bio *bbio;
+	u64 length = *length_ret;
 	u64 offset;
 	u64 stripe_nr;
 	u64 stripe_nr_end;
@@ -5713,6 +5714,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 
 	offset = logical - em->start;
 	length = min_t(u64, em->start + em->len - logical, length);
+	*length_ret = length;
 
 	stripe_len = map->stripe_len;
 	/*
@@ -6127,7 +6129,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	if (op == BTRFS_MAP_DISCARD)
 		return __btrfs_map_block_for_discard(fs_info, logical,
-						     *length, bbio_ret);
+						     length, bbio_ret);
 
 	ret = btrfs_get_io_geometry(fs_info, op, logical, *length, &geom);
 	if (ret < 0)
-- 
2.25.1

