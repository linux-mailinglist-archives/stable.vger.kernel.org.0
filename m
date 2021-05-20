Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE738A19E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhETJcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhETJaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35C3C613C1;
        Thu, 20 May 2021 09:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502867;
        bh=OqZjzTHcvVGSV/zJVpzoxHvBZ/8GXEM9zR/cxCAA5Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKha6fG6j1LzdMOTAAnq4xOvTzjU8XD5YAt7UVG5hYygZ0+jgUAvrihvhuj1DZakb
         IOI7Psewcb+ZKoiakx5+q4vn4NLJkR2v/BUwg936qvvR8DlsXYqeoZsyc4+y5RDNii
         bhALizv133NIJkHmlv5GjRS3cEpGnXAHrk9EM5cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/47] NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid
Date:   Thu, 20 May 2021 11:22:15 +0200
Message-Id: <20210520092054.106759529@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 50c7a7994dd20af56e4d47e90af10bab71b71001 ]

When we're looking to revalidate the page cache, we should just ensure
that we mark the change attribute invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 6e2e948f1475..dc2cbca98fb0 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -207,7 +207,8 @@ static void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 				| NFS_INO_INVALID_SIZE
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_INVALID_XATTR);
-	}
+	} else if (flags & NFS_INO_REVAL_PAGECACHE)
+		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
 	if (inode->i_mapping->nrpages == 0)
 		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
-- 
2.30.2



