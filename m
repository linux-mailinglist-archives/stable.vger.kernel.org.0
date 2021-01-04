Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95FE2E9A73
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbhADQJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbhADQAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA25F22473;
        Mon,  4 Jan 2021 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776027;
        bh=Rpl5XNX4S2+Z7AcpERuwFeSEjczuuFk6ejVvwNWPCVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Wrzli67HbZF0xtjBjoNHSp9JH9LZwBfzN7yTdNtzoWNjIT0nSVMC2ZBCdiZx7z49
         2V8FC4WOzRekVr5mGD/OPa9/5DwbGT1bjJLEX52awHJmvHi0LZZNcR3eHiMJeKpEnR
         kTuriLusYuJtxJ70WqfrlEFdUvdkapPpy7G6+fSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/47] quota: Dont overflow quota file offsets
Date:   Mon,  4 Jan 2021 16:57:35 +0100
Message-Id: <20210104155707.481231084@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
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
index a6f856f341dc7..c5562c871c8be 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -62,7 +62,7 @@ static ssize_t read_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 
 	memset(buf, 0, info->dqi_usable_bs);
 	return sb->s_op->quota_read(sb, info->dqi_type, buf,
-	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
+	       info->dqi_usable_bs, (loff_t)blk << info->dqi_blocksize_bits);
 }
 
 static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
@@ -71,7 +71,7 @@ static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 	ssize_t ret;
 
 	ret = sb->s_op->quota_write(sb, info->dqi_type, buf,
-	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
+	       info->dqi_usable_bs, (loff_t)blk << info->dqi_blocksize_bits);
 	if (ret != info->dqi_usable_bs) {
 		quota_error(sb, "dquota write failed");
 		if (ret >= 0)
@@ -284,7 +284,7 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
 			    blk);
 		goto out_buf;
 	}
-	dquot->dq_off = (blk << info->dqi_blocksize_bits) +
+	dquot->dq_off = ((loff_t)blk << info->dqi_blocksize_bits) +
 			sizeof(struct qt_disk_dqdbheader) +
 			i * info->dqi_entry_size;
 	kfree(buf);
@@ -559,7 +559,7 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
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



