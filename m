Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6F36AEC4F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCGRxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjCGRxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:53:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C3877CAA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9DEF61501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09C4C4339C;
        Tue,  7 Mar 2023 17:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211299;
        bh=FMTlfqftjRutFASKYkj61b4aGSUC0iNvGkP7nrFV4X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn3fI5/Q8sboFLkAAxVzGn9vGjMNlaxza2nCose8SFEwTYfrGdcNHlFqfEQ3EaxSL
         sGQ6Q3Zv+Ifr71+SH2OOmF1OBDWc7CQLnbiPyS+K54lbNx/+gOjdXw1Hv9CKAFVeKH
         kaaf1LwWoNcstoR8a7QK2b0Txrt5+1kooCP+Tqz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 6.2 0817/1001] udf: Preserve link count of system files
Date:   Tue,  7 Mar 2023 17:59:49 +0100
Message-Id: <20230307170057.203939608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit fc8033a34a3ca7d23353e645e6dde5d364ac5f12 upstream.

System files in UDF filesystem have link count 0. To not confuse VFS we
fudge the link count to be 1 when reading such inodes however we forget
to restore the link count of 0 when writing such inodes. Fix that.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    9 +++++++--
 fs/udf/super.c |    1 +
 fs/udf/udf_i.h |    3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1373,6 +1373,7 @@ reread:
 		ret = -EIO;
 		goto out;
 	}
+	iinfo->i_hidden = hidden_inode;
 	iinfo->i_unique = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenExtents = 0;
@@ -1708,8 +1709,12 @@ static int udf_update_inode(struct inode
 
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
 
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -147,6 +147,7 @@ static struct inode *udf_alloc_inode(str
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
 	ei->i_streamdir = 0;
+	ei->i_hidden = 0;
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -44,7 +44,8 @@ struct udf_inode_info {
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
 	unsigned		i_streamdir : 1;
-	unsigned		reserved : 25;
+	unsigned		i_hidden : 1;	/* hidden system inode */
+	unsigned		reserved : 24;
 	__u8			*i_data;
 	struct kernel_lb_addr	i_locStreamdir;
 	__u64			i_lenStreams;


