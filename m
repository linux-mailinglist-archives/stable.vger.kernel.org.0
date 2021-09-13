Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28516409FF6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348684AbhIMWgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348560AbhIMWfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E00B61211;
        Mon, 13 Sep 2021 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572460;
        bh=zZOv9c0hDXozICSiYrxi1nEvEJ4mookKp3h0i39ylNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5nyOOVKVaa2r26P6XJWZYKSh1F/n28e+kzyuBoDt3t6+IoNyv6kGBtI3dB8wf3e5
         ALOqL2947W1fK6EznyARB5bzAfyJWC+xYExe4/GW7uf+fKr6HjR6EgeMsJFL2FrI0a
         93c3LvbhM74dzmfPSUbdmil0/JIIcNrGwywHFNUnHlGNCTre0IABBTB3vTs/mnKHiC
         Hj9uaAMb8YaQAS3yghFFCki7XUvgzUEiy4MHacfIiDuLSVA64tHsk1gSosgJUrGk97
         Y9ZIJ0RAQ0a4vfUxvwNuddV1l5lTvD3RXOQK6CaX9/D9b7xuvbJggfJ38sr6UVjks1
         D+CE4tEfBGuYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 03/19] gfs2: Switch to may_setattr in gfs2_setattr
Date:   Mon, 13 Sep 2021 18:33:59 -0400
Message-Id: <20210913223415.435654-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
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

