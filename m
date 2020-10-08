Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240E52872F4
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 13:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgJHLAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 07:00:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgJHLAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 07:00:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098B05KE124111;
        Thu, 8 Oct 2020 11:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BIZ9fryrmRrVhcBHB0BNbiwOy/jnq8U+/1IagHmFeJo=;
 b=t0P2dXdTLbS/Vmm/UULAvlkxZebTyPP6+OsSESJj3qP60/U39oBlXs11L5N6DSbZRQam
 8Ky7zSE4CZa9foIghuoeq9yuPPd59Jv2RhawFCj8dTTPdCY6dtdzYCMwmyZIYQE9Fcsz
 u0P1obsp5N3G6RyIVz3P9kzEkS0IkPfpYPELCGIyKHnOpkAk/AfG80oEXKC0wa7UQPDa
 vWEIAoDItiIZPtKcbKG1oYZeaxh+9YUjHiTAdtVz6MtA0KU5OIsLXfb++3wmTWmZk1h+
 n3h8TpMBhh5W5Aagk9iXTkbreertURsROHOpysu4NKO/SixJ0zbWPnIeeX2th4ONrcXT yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxn6x1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 11:00:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AuEUi188369;
        Thu, 8 Oct 2020 11:00:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33y380yv3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 11:00:07 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098B068j011110;
        Thu, 8 Oct 2020 11:00:06 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 04:00:05 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-5.4 1/6] Btrfs: send, allow clone operations within the same file
Date:   Thu,  8 Oct 2020 18:59:49 +0800
Message-Id: <cebd942fda19f9c39e0608aa6bd93af5e0b3639b.1599750901.git.anand.jain@oracle.com>
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

From: Filipe Manana <fdmanana@suse.com>

commit 11f2069c113e02971b8db6fda62f9b9cd31a030f upstream.

For send we currently skip clone operations when the source and
destination files are the same. This is so because clone didn't support
this case in its early days, but support for it was added back in May
2013 by commit a96fbc72884fcb ("Btrfs: allow file data clone within a
file"). This change adds support for it.

Example:

  $ mkfs.btrfs -f /dev/sdd
  $ mount /dev/sdd /mnt/sdd

  $ xfs_io -f -c "pwrite -S 0xab -b 64K 0 64K" /mnt/sdd/foobar
  $ xfs_io -c "reflink /mnt/sdd/foobar 0 64K 64K" /mnt/sdd/foobar

  $ btrfs subvolume snapshot -r /mnt/sdd /mnt/sdd/snap

  $ mkfs.btrfs -f /dev/sde
  $ mount /dev/sde /mnt/sde

  $ btrfs send /mnt/sdd/snap | btrfs receive /mnt/sde

Without this change file foobar at the destination has a single 128Kb
extent:

  $ filefrag -v /mnt/sde/snap/foobar
  Filesystem type is: 9123683e
  File size of /mnt/sde/snap/foobar is 131072 (32 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..      31:          0..        31:     32:             last,unknown_loc,delalloc,eof
  /mnt/sde/snap/foobar: 1 extent found

With this we get a single 64Kb extent that is shared at file offsets 0
and 64K, just like in the source filesystem:

  $ filefrag -v /mnt/sde/snap/foobar
  Filesystem type is: 9123683e
  File size of /mnt/sde/snap/foobar is 131072 (32 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..      15:       3328..      3343:     16:             shared
     1:       16..      31:       3328..      3343:     16:       3344: last,shared,eof
  /mnt/sde/snap/foobar: 2 extents found

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/send.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6ad216e8178e..48d028b1cfaf 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1257,12 +1257,20 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 	 */
 	if (found->root == bctx->sctx->send_root) {
 		/*
-		 * TODO for the moment we don't accept clones from the inode
-		 * that is currently send. We may change this when
-		 * BTRFS_IOC_CLONE_RANGE supports cloning from and to the same
-		 * file.
+		 * If the source inode was not yet processed we can't issue a
+		 * clone operation, as the source extent does not exist yet at
+		 * the destination of the stream.
 		 */
-		if (ino >= bctx->cur_objectid)
+		if (ino > bctx->cur_objectid)
+			return 0;
+		/*
+		 * We clone from the inode currently being sent as long as the
+		 * source extent is already processed, otherwise we could try
+		 * to clone from an extent that does not exist yet at the
+		 * destination of the stream.
+		 */
+		if (ino == bctx->cur_objectid &&
+		    offset >= bctx->sctx->cur_inode_next_write_offset)
 			return 0;
 	}
 
-- 
2.25.1

