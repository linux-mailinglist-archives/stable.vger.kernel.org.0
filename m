Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB68409FBD
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbhIMWfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245674AbhIMWfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB036112E;
        Mon, 13 Sep 2021 22:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572427;
        bh=zZOv9c0hDXozICSiYrxi1nEvEJ4mookKp3h0i39ylNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaTJeREaE/eawI2JiLyDkwW1ICchQGeQfXxSZblWHGlGj0dvHR66IJ6SckczHS7IL
         OUyhkGQ34pOYbCvyq8YVzbI/9+tjN1rNmNaJMUCRL6N0C8OPSwAnUuLcdd80xjYxWQ
         QDcLLUoKdFDx8cliTrbSdodl93w84hVM3hpDlpMIujZlgY01qOqMb5D9BNISeyIlnT
         MwlvTJcw3XgODJqWccYGCbIvQuY+XyowxJbpsFso8xyzBPO2Dy+TBpPRHxxAuQVK+z
         vAcS/iHu+gud9quPlG3I/OGWk2mSvNnM7/9/GiNE1oxRP76dbfL9bljKAXSXnAotlu
         v6oGud9+S0L7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.14 05/25] gfs2: Switch to may_setattr in gfs2_setattr
Date:   Mon, 13 Sep 2021 18:33:19 -0400
Message-Id: <20210913223339.435347-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit d75b9fa053e4cd278281386d860c26fdbfbe9d03 ]

The permission check in gfs2_setattr is an old and outdated version of
may_setattr().  Switch to the updated version.

Fixes fstest generic/079.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6e15434b23ac..3130f85d2b3f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1985,8 +1985,8 @@ static int gfs2_setattr(struct user_namespace *mnt_userns,
 	if (error)
 		goto out;
 
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+	error = may_setattr(&init_user_ns, inode, attr->ia_valid);
+	if (error)
 		goto error;
 
 	error = setattr_prepare(&init_user_ns, dentry, attr);
-- 
2.30.2

