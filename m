Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDA63BD273
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhGFLmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237772AbhGFLhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1178661F5E;
        Tue,  6 Jul 2021 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570984;
        bh=A4QdYZ8oBR9zs9/MVrYuFTTY8xRdz18tMYVC1uI/r2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bakm0M3DmZtYdcSCTMupvGCzgLA/La95UeKkDdc0/rt+afo+4MXjb4LsM3skUVmUD
         4G88MNty8IfBPkobllxLRdmcoVnI4ad6LpovwrY+RhjEg1ZF8Scs2nKNeGkc/DH7uS
         gSeYDFI4yllKyMeTa8xSMTGVhpuMjGtHgnXzBz0o0YUNJivpKpE3fB2QbDFYHO28eq
         3zeuSsRK7tDAwlgBXKG24TN6BOdw57F9PyKwdsFkCB+WVy/mC2N7wId0MMrvY0pwJG
         JCJ7ntwJDUJeRb/a0U3iSJXNTknL91JzekidYJS1EwG20zhM+jQ3j2UdBouzwR5ztY
         DPCZZX1Vh5D3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arturo Giusti <koredump@protonmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 10/31] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Tue,  6 Jul 2021 07:29:10 -0400
Message-Id: <20210706112931.2066397-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arturo Giusti <koredump@protonmail.com>

[ Upstream commit fa236c2b2d4436d9f19ee4e5d5924e90ffd7bb43 ]

In function udf_symlink, epos.bh is assigned with the value returned
by udf_tgetblk. The function udf_tgetblk is defined in udf/misc.c
and returns the value of sb_getblk function that could be NULL.
Then, epos.bh is used without any check, causing a possible
NULL pointer dereference when sb_getblk fails.

This fix adds a check to validate the value of epos.bh.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213083
Signed-off-by: Arturo Giusti <koredump@protonmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f34c545f4e54..074560ad190e 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -945,6 +945,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 				iinfo->i_location.partitionReferenceNum,
 				0);
 		epos.bh = udf_tgetblk(sb, block);
+		if (unlikely(!epos.bh)) {
+			err = -ENOMEM;
+			goto out_no_entry;
+		}
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, bsize);
 		set_buffer_uptodate(epos.bh);
-- 
2.30.2

