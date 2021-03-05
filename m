Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F8332E7E1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhCEMXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCEMXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B0965019;
        Fri,  5 Mar 2021 12:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614946997;
        bh=vV+1qUBohdE8LNh61OwUIUHrWAB4NKckoup9J+fGUJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuvZaXo+zmrW15Jw7cS4W2u08xJLK0AxpGo1KTXMmHR4r33pF+Ch6w0olLU7pjgy4
         ptKuEsga1EicWQMbMF3fove/9zGnNZLWk6iH7aOQP7yJ4uWJ2Ji8plVmysR5DZWJSK
         0QIgYjMYnk0boZ2qo1kCZFVNLHrNNKUm0b2yA6/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yumei Huang <yuhuang@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.11 011/104] xfs: Fix assert failure in xfs_setattr_size()
Date:   Fri,  5 Mar 2021 13:20:16 +0100
Message-Id: <20210305120903.742411620@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
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
@@ -846,7 +846,7 @@ xfs_setattr_size(
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(inode->i_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+		ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
 
 	oldsize = inode->i_size;
 	newsize = iattr->ia_size;


