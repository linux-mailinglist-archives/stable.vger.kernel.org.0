Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A904A41D8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359212AbiAaLGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:06:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359219AbiAaLEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:04:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB25B82A4E;
        Mon, 31 Jan 2022 11:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC15FC340E8;
        Mon, 31 Jan 2022 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627083;
        bh=SVOi54IO0O8pR2wEHYPHjVnXxF8fVBac/BX3gwFelaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wzKYjIrhiU8LZYoyE6NIWXFhJi06QelyQPwVDFM+nQ0JuLYJgc2F0upLjM7Cgkxq
         nxcP1RhzbszwZ3v0QGSbiOm95VOjMJSqC1BI2Bk+pgXZn1JtL46QiDi7i17HEUe3LH
         V56OYe52nq0tyvaw8o1qHGc2iBp9DJIoyFiiG2Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/100] NFS: Ensure the server has an up to date ctime before renaming
Date:   Mon, 31 Jan 2022 11:56:28 +0100
Message-Id: <20220131105222.683259865@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6ff9d99bb88faebf134ca668842349d9718e5464 ]

Renaming a file is required by POSIX to update the file ctime, so
ensure that the file data is synced to disk so that we don't clobber the
updated ctime by writing back after creating the hard link.

Fixes: f2c2c552f119 ("NFS: Move delegation recall into the NFSv4 callback for rename_setup()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2282,6 +2282,8 @@ int nfs_rename(struct inode *old_dir, st
 		}
 	}
 
+	if (S_ISREG(old_inode->i_mode))
+		nfs_sync_inode(old_inode);
 	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry, NULL);
 	if (IS_ERR(task)) {
 		error = PTR_ERR(task);


