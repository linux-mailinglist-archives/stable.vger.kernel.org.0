Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD64490DE5
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242436AbiAQRGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54376 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242443AbiAQREZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F74C61248;
        Mon, 17 Jan 2022 17:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04611C36AE7;
        Mon, 17 Jan 2022 17:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439064;
        bh=4KlIyUwdaU0SslnKI/s1L0XxnUs5SxyM+C11F7GRPMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptdspJwgVVigSEo1mNsubRvGNKYqZgnBaM8NgxxmpkRdAWE5yrBpV/w6QtOPsa2/Q
         r3/x7y6u8fDyYjFG+6PH/RNq0Z7QXGrc2XNINnmIzqEGp7ZZ+fU0B/Ka9zI/PRM2VQ
         hj+enIDQzbVf1nzD5a4BBz8Y1ziT8Avrlhow8/P0lAC7jsE6BDc7REWJDWhWKPIYvh
         HKFdroPgSsRGXdNxy9I9FWHeOVFOLKta9UAyxtEoslbBvP6ehPzqRv8M3tX/DCU1pv
         +7BcMODivj5PlTfLVF+7GhUZgD/pAhSNBzi3x7KCKQWkpTw3JrVGGX+18AKxFIJKNY
         F8ymsX//6qo1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+9ca499bb57a2b9e4c652@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jack@suse.com
Subject: [PATCH AUTOSEL 5.10 25/34] udf: Fix error handling in udf_new_inode()
Date:   Mon, 17 Jan 2022 12:03:15 -0500
Message-Id: <20220117170326.1471712-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
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
index 84ed23edebfd3..87a77bf70ee19 100644
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

