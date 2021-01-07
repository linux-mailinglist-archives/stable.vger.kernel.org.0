Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDDF2ED1C1
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbhAGORO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728999AbhAGORO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F6B233A1;
        Thu,  7 Jan 2021 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028999;
        bh=ReUes9q7BqELJX4xI33jWXD2pF9HTd2JgrZ9Ofcr1oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyW/QfWOdp+c3g3jiXfQb+Z3sqIjAPT8obtgUOC3lnF40G4izuJeZvT7sfVXmNzUK
         DMdEj3jqdVuEew97UbwsEe5pMALBwPXug2ZteY0ZI94cs4R/2BECOD6fA0LOQeOFE3
         fWiVl7l6g0TashFS0kPlt3uDo26o00/5YOfYaWpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/32] quota: Dont overflow quota file offsets
Date:   Thu,  7 Jan 2021 15:16:40 +0100
Message-Id: <20210107140828.805868146@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 10f04d40a9fa29785206c619f80d8beedb778837 ]

The on-disk quota format supports quota files with upto 2^32 blocks. Be
careful when computing quota file offsets in the quota files from block
numbers as they can overflow 32-bit types. Since quota files larger than
4GB would require ~26 millions of quota users, this is mostly a
theoretical concern now but better be careful, fuzzers would find the
problem sooner or later anyway...

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/quota_tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index 0738972e8d3f0..ecd9887b0d1fe 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -61,7 +61,7 @@ static ssize_t read_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 
 	memset(buf, 0, info->dqi_usable_bs);
 	return sb->s_op->quota_read(sb, info->dqi_type, buf,
-	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
+	       info->dqi_usable_bs, (loff_t)blk << info->dqi_blocksize_bits);
 }
 
 static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
@@ -70,7 +70,7 @@ static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 	ssize_t ret;
 
 	ret = sb->s_op->quota_write(sb, info->dqi_type, buf,
-	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
+	       info->dqi_usable_bs, (loff_t)blk << info->dqi_blocksize_bits);
 	if (ret != info->dqi_usable_bs) {
 		quota_error(sb, "dquota write failed");
 		if (ret >= 0)
@@ -283,7 +283,7 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
 			    blk);
 		goto out_buf;
 	}
-	dquot->dq_off = (blk << info->dqi_blocksize_bits) +
+	dquot->dq_off = ((loff_t)blk << info->dqi_blocksize_bits) +
 			sizeof(struct qt_disk_dqdbheader) +
 			i * info->dqi_entry_size;
 	kfree(buf);
@@ -558,7 +558,7 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
 		ret = -EIO;
 		goto out_buf;
 	} else {
-		ret = (blk << info->dqi_blocksize_bits) + sizeof(struct
+		ret = ((loff_t)blk << info->dqi_blocksize_bits) + sizeof(struct
 		  qt_disk_dqdbheader) + i * info->dqi_entry_size;
 	}
 out_buf:
-- 
2.27.0



