Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F12F49951D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392226AbiAXUut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39712 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358153AbiAXUn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:43:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3698260B28;
        Mon, 24 Jan 2022 20:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196B9C340E5;
        Mon, 24 Jan 2022 20:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057037;
        bh=GzbYbsXc5BwyTSbLqMt453HSpU4UrE4xgXx+YQpBbjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpkrP0qb86i8DB42Wrb58N+OPup/mcWpJqnbDKzUR9S3Wst98a4KBdmhXrEPZnmPr
         da+fgY+lkYsCcyLvyccpyHdyMgdLk7rWetoJqD8NREQ5o/RmaBUk5wC7DsMZWKsIoB
         b07zlPthWKk3GZ3oQ9TbPxbyOs9qCYOYoDi7SDz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9ca499bb57a2b9e4c652@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 649/846] udf: Fix error handling in udf_new_inode()
Date:   Mon, 24 Jan 2022 19:42:46 +0100
Message-Id: <20220124184123.406590822@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit f05f2429eec60851b98bdde213de31dab697c01b ]

When memory allocation of iinfo or block allocation fails, already
allocated struct udf_inode_info gets freed with iput() and
udf_evict_inode() may look at inode fields which are not properly
initialized. Fix it by marking inode bad before dropping reference to it
in udf_new_inode().

Reported-by: syzbot+9ca499bb57a2b9e4c652@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/ialloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 2ecf0e87660e3..b5d611cee749c 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -77,6 +77,7 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode)
 					GFP_KERNEL);
 	}
 	if (!iinfo->i_data) {
+		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -86,6 +87,7 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode)
 			      dinfo->i_location.partitionReferenceNum,
 			      start, &err);
 	if (err) {
+		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(err);
 	}
-- 
2.34.1



