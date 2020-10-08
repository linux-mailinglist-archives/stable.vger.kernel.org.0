Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96712287300
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 13:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgJHLAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 07:00:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbgJHLAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 07:00:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098B0I3k010622;
        Thu, 8 Oct 2020 11:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=uquMoBZZItGLXnFVj80x0u7kQnKwqnsLLDba9RQOm00=;
 b=K6TwWS9zjjnHlBPU5/jLZs/nlImFleSHtDtazHayfBwhbV+0aW3AAcYuHUbBZy7sUez9
 EbfXMOLlLO/7SC2yyV2ft5/xDfTw0vs2pZPDwhX7N6b0nIhI2qsMiwEUHbmDlEmZNyQv
 DMLW9EgsMUEYQYZk4QOHvfxDF3z0V0CdaAix4nwUBhinGX6+6F9vDptRBGShkAFBsWNe
 W9HhFCKJOfoFm2URrHDbuyfDWq+PWzWyl3C/fg+kfPpmTZklWWnIz2mxa6lgfu+eTbmL
 t5N7z+kx5Frt/RgpZ/8EDeBez/z8Captm7n/jxvyWQKoNkhOp4wme3PxpcxJhhG+juuW hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34v3rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 11:00:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AstPH087573;
        Thu, 8 Oct 2020 11:00:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3410k1009c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 11:00:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098B0G5p023487;
        Thu, 8 Oct 2020 11:00:17 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 04:00:16 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-5.4 5/6] btrfs: fix RWF_NOWAIT write not failling when we need to cow
Date:   Thu,  8 Oct 2020 18:59:53 +0800
Message-Id: <3d6c7a6445ab42dfacd86b8b3ab166decc8ee65a.1599750901.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1599750901.git.anand.jain@oracle.com>
References: <cover.1599750901.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 260a63395f90f67d6ab89e4266af9e3dc34a77e9 upstream.

If we attempt to do a RWF_NOWAIT write against a file range for which we
can only do NOCOW for a part of it, due to the existence of holes or
shared extents for example, we proceed with the write as if it were
possible to NOCOW the whole range.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ touch /mnt/sdj/bar
  $ chattr +C /mnt/sdj/bar

  $ xfs_io -d -c "pwrite -S 0xab -b 256K 0 256K" /mnt/bar
  wrote 262144/262144 bytes at offset 0
  256 KiB, 1 ops; 0.0003 sec (694.444 MiB/sec and 2777.7778 ops/sec)

  $ xfs_io -c "fpunch 64K 64K" /mnt/bar
  $ sync

  $ xfs_io -d -c "pwrite -N -V 1 -b 128K -S 0xfe 0 128K" /mnt/bar
  wrote 131072/131072 bytes at offset 0
  128 KiB, 1 ops; 0.0007 sec (160.051 MiB/sec and 1280.4097 ops/sec)

This last write should fail with -EAGAIN since the file range from 64K to
128K is a hole. On xfs it fails, as expected, but on ext4 it currently
succeeds because apparently it is expensive to check if there are extents
allocated for the whole range, but I'll check with the ext4 people.

Fix the issue by checking if check_can_nocow() returns a number of
NOCOW'able bytes smaller then the requested number of bytes, and if it
does return -EAGAIN.

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4e4ddd5629e5..4d0e1f9452a5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1919,13 +1919,27 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	pos = iocb->ki_pos;
 	count = iov_iter_count(from);
 	if (iocb->ki_flags & IOCB_NOWAIT) {
+		size_t nocow_bytes = count;
+
 		/*
 		 * We will allocate space in case nodatacow is not set,
 		 * so bail
 		 */
 		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC)) ||
-		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
+		    check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes) <= 0) {
+			inode_unlock(inode);
+			return -EAGAIN;
+		}
+
+		/* check_can_nocow() locks the snapshot lock on success */
+		btrfs_end_write_no_snapshotting(root);
+		/*
+		 * There are holes in the range or parts of the range that must
+		 * be COWed (shared extents, RO block groups, etc), so just bail
+		 * out.
+		 */
+		if (nocow_bytes < count) {
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
-- 
2.25.1

