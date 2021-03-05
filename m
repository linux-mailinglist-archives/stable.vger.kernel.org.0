Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D38332E8E2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCEM3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhCEM26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF08565004;
        Fri,  5 Mar 2021 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947338;
        bh=mK4aImsYU/krd3tVxtt0PdnSJGydkmNl7EX2fcPVp2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx3WZm+VftRsrkhTvXKGOGivDH0M15e8UEVdJx9s6j4dF8SujwN0OxKSuDnbLWqfi
         MYRYO4xvQuNkxfjTCf5CV/c/Wambx6tHJn4E8R7dkmJayIre+LEnEC+9OjRIOap7NB
         gC5gspeLlXHAuf7rAnPJz1iQQ3pA+xE5gCmSmTbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yumei Huang <yuhuang@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.10 012/102] xfs: Fix assert failure in xfs_setattr_size()
Date:   Fri,  5 Mar 2021 13:20:31 +0100
Message-Id: <20210305120903.874371510@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yumei Huang <yuhuang@redhat.com>

commit 88a9e03beef22cc5fabea344f54b9a0dfe63de08 upstream.

An assert failure is triggered by syzkaller test due to
ATTR_KILL_PRIV is not cleared before xfs_setattr_size.
As ATTR_KILL_PRIV is not checked/used by xfs_setattr_size,
just remove it from the assert.

Signed-off-by: Yumei Huang <yuhuang@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -865,7 +865,7 @@ xfs_setattr_size(
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(inode->i_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+		ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
 
 	oldsize = inode->i_size;
 	newsize = iattr->ia_size;


