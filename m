Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6030490DB8
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241225AbiAQRFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbiAQRCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D49C06175F;
        Mon, 17 Jan 2022 09:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A685D611E2;
        Mon, 17 Jan 2022 17:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4E8C36AF2;
        Mon, 17 Jan 2022 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438954;
        bh=GzbYbsXc5BwyTSbLqMt453HSpU4UrE4xgXx+YQpBbjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwpEJBxIPUFedd0+Cm6Vk5z28ggAKwuQCE47BqWssaSx2UxCHK6JpvC1nmItBOC18
         Utd72weFHJqMaPd13qc3/OjmGy2ElIvVpkM/aIMlPZp3ZLJjRHXW1+PiP5N6rrvbx4
         PmVw+np+dvgBMF830Br8CZVcTSaIHcMGLpWNUa6eRarLrtWm9F+e0yHMWqMWPXWUjr
         X22GNzGsCRYkRE56Kx434BKYXYA/+za1HcXpT2nnwnaLid2/xR35pvutMC/gs+FAiv
         V3n0navshyhez0C6TPK/x+RoroP4YzksriKMkJxW/76kVHl0ZvD1Y/RrpfJr1qtYON
         ZYYwGAoPRaibQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+9ca499bb57a2b9e4c652@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jack@suse.com
Subject: [PATCH AUTOSEL 5.15 28/44] udf: Fix error handling in udf_new_inode()
Date:   Mon, 17 Jan 2022 12:01:11 -0500
Message-Id: <20220117170127.1471115-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

