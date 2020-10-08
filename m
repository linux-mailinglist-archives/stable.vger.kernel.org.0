Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3882872F7
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 13:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgJHLAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 07:00:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54860 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgJHLAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 07:00:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098B0AA6124148;
        Thu, 8 Oct 2020 11:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=VyqBepynHzcRKTGpk+ePcG9a6VItZf9Oq40fOmu2XXI=;
 b=UDZhOjlaWD2CFQSAJTGy/MacCWvISbacPydlYrhla2dC6NL7xT1UHx4ND4lunVSqS3Wm
 cuzqXmmMugXYMkZVRpCYSUWYWvXvhYm9ZIAWj+nbmnN34VzQU5kWmDTGX2NnOkeodO6l
 EakH96oqlb6D0rz5nB1BnkfVllZP9SHQ3uhY2LNabcYKTEfU1qp2mL8bM7mhMy4VeGxM
 U+d3E9EYHcH2kHgaBY8IeLn+8DdGHLLkjVOPnvlZkAL4yRUcgaD9krk/eqFzDQbd2XNn
 8fd/p6xxSRKU4tLDlPym9SClNJu4XJ62lsNKl9p3S08V7DJQlKXMRhRWw0Iy7EMKLF5i aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxn6x1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 11:00:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AtFtS033469;
        Thu, 8 Oct 2020 11:00:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 341xnbgpqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 11:00:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098B09je011145;
        Thu, 8 Oct 2020 11:00:09 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 04:00:08 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-5.4 2/6] Btrfs: send, fix emission of invalid clone operations within the same file
Date:   Thu,  8 Oct 2020 18:59:50 +0800
Message-Id: <619aad15476b97e259c3625dad8223bb137e9053.1599750901.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1599750901.git.anand.jain@oracle.com>
References: <cover.1599750901.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080081
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

commit 9722b10148504c4153a74a9c89725af271e490fc upstream.

When doing an incremental send and a file has extents shared with itself
at different file offsets, it's possible for send to emit clone operations
that will fail at the destination because the source range goes beyond the
file's current size. This happens when the file size has increased in the
send snapshot, there is a hole between the shared extents and both shared
extents are at file offsets which are greater the file's size in the
parent snapshot.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt/sdb

  $ xfs_io -f -c "pwrite -S 0xf1 0 64K" /mnt/sdb/foobar
  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/base
  $ btrfs send -f /tmp/1.snap /mnt/sdb/base

  # Create a 320K extent at file offset 512K.
  $ xfs_io -c "pwrite -S 0xab 512K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0xcd 576K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0xef 640K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0x64 704K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0x73 768K 64K" /mnt/sdb/foobar

  # Clone part of that 320K extent into a lower file offset (192K).
  # This file offset is greater than the file's size in the parent
  # snapshot (64K). Also the clone range is a bit behind the offset of
  # the 320K extent so that we leave a hole between the shared extents.
  $ xfs_io -c "reflink /mnt/sdb/foobar 448K 192K 192K" /mnt/sdb/foobar

  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/incr
  $ btrfs send -p /mnt/sdb/base -f /tmp/2.snap /mnt/sdb/incr

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ btrfs receive -f /tmp/1.snap /mnt/sdc
  $ btrfs receive -f /tmp/2.snap /mnt/sdc
  ERROR: failed to clone extents to foobar: Invalid argument

The problem is that after processing the extent at file offset 256K, which
refers to the first 128K of the 320K extent created by the buffered write
operations, we have 'cur_inode_next_write_offset' set to 384K, which
corresponds to the end offset of the partially shared extent (256K + 128K)
and to the current file size in the receiver. Then when we process the
extent at offset 512K, we do extent backreference iteration to figure out
if we can clone the extent from some other inode or from the same inode,
and we consider the extent at offset 256K of the same inode as a valid
source for a clone operation, which is not correct because at that point
the current file size in the receiver is 384K, which corresponds to the
end of last processed extent (at file offset 256K), so using a clone
source range from 256K to 256K + 320K is invalid because that goes past
the current size of the file (384K) - this makes the receiver get an
-EINVAL error when attempting the clone operation.

So fix this by excluding clone sources that have a range that goes beyond
the current file size in the receiver when iterating extent backreferences.

A test case for fstests follows soon.

Fixes: 11f2069c113e02 ("Btrfs: send, allow clone operations within the same file")
CC: stable@vger.kernel.org # 5.5+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 48d028b1cfaf..b0e5dfb9be7a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1270,7 +1270,8 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 		 * destination of the stream.
 		 */
 		if (ino == bctx->cur_objectid &&
-		    offset >= bctx->sctx->cur_inode_next_write_offset)
+		    offset + bctx->extent_len >
+		    bctx->sctx->cur_inode_next_write_offset)
 			return 0;
 	}
 
-- 
2.25.1

