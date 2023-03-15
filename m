Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDD6BB01E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjCOMPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjCOMP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67957E7A5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0833B81DFC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC8EC4339B;
        Wed, 15 Mar 2023 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882522;
        bh=kj87XhVVOGCIsKzLZLGOrHQLs83k6hN1rJD+BkXRRc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEuhQAPlRUqJkcNek3Zu8GDmtWDXsO9ranVq+JyGgHvPrklp3XqW5SVxo/WzrRguA
         zKZP4Sh2SrWA+D85B439kbGQHn030P3U/BDTR2bc5TlshFUcNlpFGJFrWiTjjjubr1
         5dDkjz6PIizd0Xjkg5BGv431mdV5MwufTkgAz+PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/39] udf: reduce leakage of blocks related to named streams
Date:   Wed, 15 Mar 2023 13:12:24 +0100
Message-Id: <20230315115721.633207556@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven J. Magnani <steve.magnani@digidescorp.com>

[ Upstream commit ab9a3a737284b3d9e1d2ba43a0ef31b3ef2e2417 ]

Windows is capable of creating UDF files having named streams.
One example is the "Zone.Identifier" stream attached automatically
to files downloaded from a network. See:
  https://msdn.microsoft.com/en-us/library/dn392609.aspx

Modification of a file having one or more named streams in Linux causes
the stream directory to become detached from the file, essentially leaking
all blocks pertaining to the file's streams.

Fix by saving off information about an inode's streams when reading it,
for later use when its on-disk data is updated.

Link: https://lore.kernel.org/r/20190814125002.10869-1-steve@digidescorp.com
Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: fc8033a34a3c ("udf: Preserve link count of system files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 24 +++++++++++++++++++++++-
 fs/udf/super.c |  2 ++
 fs/udf/udf_i.h |  5 ++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index af1180104e560..99d297b667ce1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1470,6 +1470,8 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
 		iinfo->i_lenAlloc = le32_to_cpu(fe->lengthAllocDescs);
 		iinfo->i_checkpoint = le32_to_cpu(fe->checkpoint);
+		iinfo->i_streamdir = 0;
+		iinfo->i_lenStreams = 0;
 	} else {
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 		    (inode->i_sb->s_blocksize_bits - 9);
@@ -1483,6 +1485,16 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
 		iinfo->i_lenAlloc = le32_to_cpu(efe->lengthAllocDescs);
 		iinfo->i_checkpoint = le32_to_cpu(efe->checkpoint);
+
+		/* Named streams */
+		iinfo->i_streamdir = (efe->streamDirectoryICB.extLength != 0);
+		iinfo->i_locStreamdir =
+			lelb_to_cpu(efe->streamDirectoryICB.extLocation);
+		iinfo->i_lenStreams = le64_to_cpu(efe->objectSize);
+		if (iinfo->i_lenStreams >= inode->i_size)
+			iinfo->i_lenStreams -= inode->i_size;
+		else
+			iinfo->i_lenStreams = 0;
 	}
 	inode->i_generation = iinfo->i_unique;
 
@@ -1745,9 +1757,19 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		       iinfo->i_ext.i_data,
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
-		efe->objectSize = cpu_to_le64(inode->i_size);
+		efe->objectSize =
+			cpu_to_le64(inode->i_size + iinfo->i_lenStreams);
 		efe->logicalBlocksRecorded = cpu_to_le64(lb_recorded);
 
+		if (iinfo->i_streamdir) {
+			struct long_ad *icb_lad = &efe->streamDirectoryICB;
+
+			icb_lad->extLocation =
+				cpu_to_lelb(iinfo->i_locStreamdir);
+			icb_lad->extLength =
+				cpu_to_le32(inode->i_sb->s_blocksize);
+		}
+
 		udf_adjust_time(iinfo, inode->i_atime);
 		udf_adjust_time(iinfo, inode->i_mtime);
 		udf_adjust_time(iinfo, inode->i_ctime);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5d179616578cf..ec082b27e9fba 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -146,9 +146,11 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 
 	ei->i_unique = 0;
 	ei->i_lenExtents = 0;
+	ei->i_lenStreams = 0;
 	ei->i_next_alloc_block = 0;
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
+	ei->i_streamdir = 0;
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 2ef0e212f08a3..00d773d1b7cf0 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -42,12 +42,15 @@ struct udf_inode_info {
 	unsigned		i_efe : 1;	/* extendedFileEntry */
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
-	unsigned		reserved : 26;
+	unsigned		i_streamdir : 1;
+	unsigned		reserved : 25;
 	union {
 		struct short_ad	*i_sad;
 		struct long_ad		*i_lad;
 		__u8		*i_data;
 	} i_ext;
+	struct kernel_lb_addr	i_locStreamdir;
+	__u64			i_lenStreams;
 	struct rw_semaphore	i_data_sem;
 	struct udf_ext_cache cached_extent;
 	/* Spinlock for protecting extent cache */
-- 
2.39.2



