Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCB24A4398
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376844AbiAaLWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378574AbiAaLUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353CFC061748;
        Mon, 31 Jan 2022 03:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCBC4611D8;
        Mon, 31 Jan 2022 11:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2EDC340E8;
        Mon, 31 Jan 2022 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627593;
        bh=CtmX/A58SH25qW4/T+m5wAWeHt9TEkel110jnyl9Uao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAUCmZk8cz563654exYmY7Gikc+5ppXjxnQw1EmMpr0pNHdbtOVQITn+/dUIKmMt8
         5Iv8eGAOnF0CxA29VVRswDkRruUOpGrTGSu7LKzvH0gKgbMytLD58IMfvY/6uA5jcL
         rZyO3VwfftuijiDS/g5Npu9TAM1hKYNwWmTU08po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/171] NFS: Ensure the server has an up to date ctime before renaming
Date:   Mon, 31 Jan 2022 11:56:06 +0100
Message-Id: <20220131105233.463646276@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -2490,6 +2490,8 @@ int nfs_rename(struct user_namespace *mn
 		}
 	}
 
+	if (S_ISREG(old_inode->i_mode))
+		nfs_sync_inode(old_inode);
 	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry, NULL);
 	if (IS_ERR(task)) {
 		error = PTR_ERR(task);


