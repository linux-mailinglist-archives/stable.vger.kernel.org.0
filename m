Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54844A4397
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376832AbiAaLWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378572AbiAaLUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D10AC0604E1;
        Mon, 31 Jan 2022 03:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF81611D8;
        Mon, 31 Jan 2022 11:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92456C340E8;
        Mon, 31 Jan 2022 11:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627590;
        bh=/yQQiLT0m1y1/euz6bfN4ort1cviBYyUBTmrqAeAjP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eM09wiBTUjJ8h6nIJqN8N1BDG63/2yzna/J1eyPFZSxhijq76ClJONSOvR3qRwwvX
         TaAEtRw4wsmBvK57mAf8cbhLsfNoJkCyDuHpvMXoOHpDQCccJRcmjxcRpMQ6rAfB57
         Ojf6XmLnkeE1Crv3nLpB1vPMalLU8oP2zS1Bzz8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/171] NFS: Ensure the server has an up to date ctime before hardlinking
Date:   Mon, 31 Jan 2022 11:56:05 +0100
Message-Id: <20220131105233.433593413@linuxfoundation.org>
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

[ Upstream commit 204975036b34f55237bc44c8a302a88468ef21b5 ]

Creating a hard link is required by POSIX to update the file ctime, so
ensure that the file data is synced to disk so that we don't clobber the
updated ctime by writing back after creating the hard link.

Fixes: 9f7682728728 ("NFS: Move the delegation return down into nfs4_proc_link()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2400,6 +2400,8 @@ nfs_link(struct dentry *old_dentry, stru
 
 	trace_nfs_link_enter(inode, dir, dentry);
 	d_drop(dentry);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_inode(inode);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
 		ihold(inode);


