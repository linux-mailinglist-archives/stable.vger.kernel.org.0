Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9239266672
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgIKR2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgIKM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E792224F;
        Fri, 11 Sep 2020 12:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828951;
        bh=An3623LYJz8ha2T9Fwp0QpSAGawmTzp7icvaog2KT7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGZNhiMqdDLQF9cqPpVbAC0KyHAmJVbhwI2UV/h1OsYLkrwBhwW1oHHkWMI7ePRSa
         iQc4u4bXbHYfCHqlyqGuX7kasJAPD5Mh/+QwPKzNU1+EwejmqqiyzazIj2NYWDk2p8
         wO/YJB//SAAXbrGuD/g6ZQWO/7q+KHO7HXACm5TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Frederick <fabf@skynet.be>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 54/62] fs/affs: use octal for permissions
Date:   Fri, 11 Sep 2020 14:46:37 +0200
Message-Id: <20200911122505.088073305@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

[ Upstream commit 1bafd6f164d9ec9bf2fa9829051fbeb36342be0b ]

According to commit f90774e1fd27 ("checkpatch: look for symbolic
permissions and suggest octal instead")

Link: http://lkml.kernel.org/r/20170109191208.6085-5-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/amigaffs.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 5fa92bc790ef7..a148c7ecb35d3 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -390,23 +390,23 @@ prot_to_mode(u32 prot)
 	umode_t mode = 0;
 
 	if (!(prot & FIBF_NOWRITE))
-		mode |= S_IWUSR;
+		mode |= 0200;
 	if (!(prot & FIBF_NOREAD))
-		mode |= S_IRUSR;
+		mode |= 0400;
 	if (!(prot & FIBF_NOEXECUTE))
-		mode |= S_IXUSR;
+		mode |= 0100;
 	if (prot & FIBF_GRP_WRITE)
-		mode |= S_IWGRP;
+		mode |= 0020;
 	if (prot & FIBF_GRP_READ)
-		mode |= S_IRGRP;
+		mode |= 0040;
 	if (prot & FIBF_GRP_EXECUTE)
-		mode |= S_IXGRP;
+		mode |= 0010;
 	if (prot & FIBF_OTR_WRITE)
-		mode |= S_IWOTH;
+		mode |= 0002;
 	if (prot & FIBF_OTR_READ)
-		mode |= S_IROTH;
+		mode |= 0004;
 	if (prot & FIBF_OTR_EXECUTE)
-		mode |= S_IXOTH;
+		mode |= 0001;
 
 	return mode;
 }
@@ -417,23 +417,23 @@ mode_to_prot(struct inode *inode)
 	u32 prot = AFFS_I(inode)->i_protect;
 	umode_t mode = inode->i_mode;
 
-	if (!(mode & S_IXUSR))
+	if (!(mode & 0100))
 		prot |= FIBF_NOEXECUTE;
-	if (!(mode & S_IRUSR))
+	if (!(mode & 0400))
 		prot |= FIBF_NOREAD;
-	if (!(mode & S_IWUSR))
+	if (!(mode & 0200))
 		prot |= FIBF_NOWRITE;
-	if (mode & S_IXGRP)
+	if (mode & 0010)
 		prot |= FIBF_GRP_EXECUTE;
-	if (mode & S_IRGRP)
+	if (mode & 0040)
 		prot |= FIBF_GRP_READ;
-	if (mode & S_IWGRP)
+	if (mode & 0020)
 		prot |= FIBF_GRP_WRITE;
-	if (mode & S_IXOTH)
+	if (mode & 0001)
 		prot |= FIBF_OTR_EXECUTE;
-	if (mode & S_IROTH)
+	if (mode & 0004)
 		prot |= FIBF_OTR_READ;
-	if (mode & S_IWOTH)
+	if (mode & 0002)
 		prot |= FIBF_OTR_WRITE;
 
 	AFFS_I(inode)->i_protect = prot;
-- 
2.25.1



