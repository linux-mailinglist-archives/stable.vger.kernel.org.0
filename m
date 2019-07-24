Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83B74600
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391383AbfGYFp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbfGYFp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0201A21850;
        Thu, 25 Jul 2019 05:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033557;
        bh=bNKytZT2cjYnW3sutO9HlwN3gWCgRB7yjKRzehU6Ras=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMjufr/EGcqTwUXjBQpfzqRwg73HENiZgelvR2Ic+VU+wSVBHX/0scdB4WRYa8KWr
         u8oyS6PiXlK3hIM5iM09WbjcUzPfRcE4rf+xHtDogJ6R5fg/Q30grjjDNJxIgJEqBd
         jJJlj15I98PW58O+cedbfzvMA/6M+w4FAIB1OKyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 248/271] xfs: fix reporting supported extra file attributes for statx()
Date:   Wed, 24 Jul 2019 21:21:57 +0200
Message-Id: <20190724191716.449656898@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1b9598c8fb9965fff901c4caa21fed9644c34df3 upstream.

statx(2) notes that any attribute that is not indicated as supported by
stx_attributes_mask has no usable value. Commit 5f955f26f3d42d ("xfs: report
crtime and attribute flags to statx") added support for informing userspace
of extra file attributes but forgot to list these flags as supported
making reporting them rather useless for the pedantic userspace author.

$ git describe --contains 5f955f26f3d42d04aba65590a32eb70eedb7f37d
v4.11-rc6~5^2^2~2

Fixes: 5f955f26f3d42d ("xfs: report crtime and attribute flags to statx")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: add a comment reminding people to keep attributes_mask up to date]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1efef69a7f1c..74047bd0c1ae 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -531,6 +531,10 @@ xfs_vn_getattr(
 		}
 	}
 
+	/*
+	 * Note: If you add another clause to set an attribute flag, please
+	 * update attributes_mask below.
+	 */
 	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
@@ -538,6 +542,10 @@ xfs_vn_getattr(
 	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
+	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
+				  STATX_ATTR_APPEND |
+				  STATX_ATTR_NODUMP);
+
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
 	case S_IFCHR:
-- 
2.20.1



