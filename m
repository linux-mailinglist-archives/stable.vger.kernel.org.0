Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F0432E98E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCEMd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhCEMdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B65065029;
        Fri,  5 Mar 2021 12:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947587;
        bh=tR6maV4hjgw4KAzKfBTuxp6j9K+ET8kMZYsSUT9hE44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGMty+FcQKkn5T740QrFLivd1k68VLJ6DkRvTXSaLIlsLZ/tC3rYIexFXUZQfw9YW
         OfFddtWl2jxsE/b1YXYW+pnbwIM7GqCl4ghSW7sYxy/hnvarU/Op+CYygnLLtyr3l4
         snu+pVOL7/UAZQFMCdEO8rmO8oVLaef1vzq68Pfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yumei Huang <yuhuang@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 12/72] xfs: Fix assert failure in xfs_setattr_size()
Date:   Fri,  5 Mar 2021 13:21:14 +0100
Message-Id: <20210305120857.941815386@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
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
@@ -839,7 +839,7 @@ xfs_setattr_size(
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(inode->i_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+		ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
 
 	oldsize = inode->i_size;
 	newsize = iattr->ia_size;


