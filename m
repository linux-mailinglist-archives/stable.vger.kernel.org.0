Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E719A106380
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbfKVF4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbfKVF4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860042070A;
        Fri, 22 Nov 2019 05:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402199;
        bh=hwMKDedI4CD9yAqhIKGCn9TEnS8XMjv6ngS0mRYmE40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrKwozowY3KGd/jtuFkk4LbezkvXfWmzrdv+Ulr+TIist9yVD1fo1w2KU/oUoaznu
         /drBO7OOGj/KA3ntEjZRwIpUoEwYB1rzOn8tuASLDoOPyv6SlTlA0iVrsXabAfcZP/
         HJfC4ipRGhO900XKrST7/0mnd2DA+tEUsF5nhJtU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 048/127] xfs: Align compat attrlist_by_handle with native implementation.
Date:   Fri, 22 Nov 2019 00:54:26 -0500
Message-Id: <20191122055544.3299-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

[ Upstream commit c456d64449efe37da50832b63d91652a85ea1d20 ]

While inspecting the ioctl implementations, I noticed that the compat
implementation of XFS_IOC_ATTRLIST_BY_HANDLE does not do exactly the
same thing as the native implementation.  Specifically, the "cursor"
does not appear to be written out to userspace on the compat path,
like it is on the native path.

This adjusts the compat implementation to copy out the cursor just
like the native implementation does.  The attrlist cursor does not
require any special compat handling.  This fixes xfstests xfs/269
on both IA-32 and x32 userspace, when running on an amd64 kernel.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
Fixes: 0facef7fb053b ("xfs: in _attrlist_by_handle, copy the cursor back to userspace")
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl32.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fa0bc4d46065a..d3c0e4b8bf421 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -347,6 +347,7 @@ xfs_compat_attrlist_by_handle(
 {
 	int			error;
 	attrlist_cursor_kern_t	*cursor;
+	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
 	char			*kbuf;
@@ -381,6 +382,11 @@ xfs_compat_attrlist_by_handle(
 	if (error)
 		goto out_kfree;
 
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
+		error = -EFAULT;
+		goto out_kfree;
+	}
+
 	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
 		error = -EFAULT;
 
-- 
2.20.1

