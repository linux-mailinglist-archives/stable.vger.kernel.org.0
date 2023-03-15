Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C72B6BB01F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjCOMPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjCOMP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D51D898C6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3482961D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C39C4339B;
        Wed, 15 Mar 2023 12:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882527;
        bh=OBOMO2qUl2W8+YoGzK/ZYn68/vWNFk3RtyyWAiEZwt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOMESQPn8QfWWGIuPmFcmKRAImM7P7T/+YgUj2ZkqYnmet5Yip/d+xb8mAR0Anbiz
         6fqsCiBJvVMrOsn/h7Fp6AA5EexTzWIGyti9SDV1p2/yc1cQ2xOZRpeMd6qSnzGml+
         ZZqo/m7PwD12jrvqgMqb45rjl37OaNCjivArgLr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/39] udf: Preserve link count of system files
Date:   Wed, 15 Mar 2023 13:12:26 +0100
Message-Id: <20230315115721.708335790@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit fc8033a34a3ca7d23353e645e6dde5d364ac5f12 ]

System files in UDF filesystem have link count 0. To not confuse VFS we
fudge the link count to be 1 when reading such inodes however we forget
to restore the link count of 0 when writing such inodes. Fix that.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 9 +++++++--
 fs/udf/super.c | 1 +
 fs/udf/udf_i.h | 3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 415f1186d250f..7436337914b19 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1375,6 +1375,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = -EIO;
 		goto out;
 	}
+	iinfo->i_hidden = hidden_inode;
 	iinfo->i_unique = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenExtents = 0;
@@ -1694,8 +1695,12 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	if (S_ISDIR(inode->i_mode) && inode->i_nlink > 0)
 		fe->fileLinkCount = cpu_to_le16(inode->i_nlink - 1);
-	else
-		fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	else {
+		if (iinfo->i_hidden)
+			fe->fileLinkCount = cpu_to_le16(0);
+		else
+			fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	}
 
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index cdaef406f3899..bce48a07790cb 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -151,6 +151,7 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
 	ei->i_streamdir = 0;
+	ei->i_hidden = 0;
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 2a4731314d51f..b77bf713a1b68 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -43,7 +43,8 @@ struct udf_inode_info {
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
 	unsigned		i_streamdir : 1;
-	unsigned		reserved : 25;
+	unsigned		i_hidden : 1;	/* hidden system inode */
+	unsigned		reserved : 24;
 	__u8			*i_data;
 	struct kernel_lb_addr	i_locStreamdir;
 	__u64			i_lenStreams;
-- 
2.39.2



