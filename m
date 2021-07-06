Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9023BCBEC
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhGFLRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhGFLRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E073D61C2C;
        Tue,  6 Jul 2021 11:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570107;
        bh=eWhmhpiMqM87jdVbTbTJeoNWiAD8ZXiQSfYHQ/uJd5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPRdrcOe5zvKczdD3UHDIsSpoTrwkzGJBfQ9hFYustKtn4bzwBfXwnUvDxAdjN/Ox
         xNuV4kMFSLHXGnh9aJsVJazx1TRH330m5jj7I+hC2ZvKXk0lVu9ntG8GIzl74SNlGe
         DsRMSyV/GIgC3RjGw6bgbv7dHp1FdqRhUv7WcMwHKRBG3KhWnrR3WrfXeKIMv5zP5O
         PK09aBrqWhKD5YjLr/zNVGsllmCEf4K04olZ5gbMyZ/Qa9uNy7rSGLryOdgKqBugjj
         4rhYSjNRIT7AQk/r0q4C/lsmrtHAuBzidEgjk0nGUfmrnkp1j98zdx3I/6eGvnQZ0L
         MpmlO01uDGCJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arturo Giusti <koredump@protonmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 040/189] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Tue,  6 Jul 2021 07:11:40 -0400
Message-Id: <20210706111409.2058071-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 3ae9f1e91984..7c7c9bbbfa57 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -934,6 +934,10 @@ static int udf_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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

