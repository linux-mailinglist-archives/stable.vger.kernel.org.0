Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470234A43D4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377624AbiAaLYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39258 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbiAaLVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:21:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DEADB82A60;
        Mon, 31 Jan 2022 11:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B0AC340EF;
        Mon, 31 Jan 2022 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628067;
        bh=WLQ26RHE/xOeDgBXZ1JjZPLrVq1aL2E3bOVJqLyonmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqEOgAc/1j8p6ShFzdN050h0vjPA9YIkokvLid/ibipjqklb9ztgTz1ktyPptnrBJ
         ZXcXGu6wV8aszFTr24ZG8OH3BTXUM9YmFI1xhKl44KEUJd2QK5e47WT/BMwzWUqCOd
         11MnLgppN/x008NfLLbHbxJ21dzA8ZznsFASPDTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyu Tao <tao.lyu@epfl.ch>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.16 114/200] NFSv4: Handle case where the lookup of a directory fails
Date:   Mon, 31 Jan 2022 11:56:17 +0100
Message-Id: <20220131105237.415872921@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit ac795161c93699d600db16c1a8cc23a65a1eceaf upstream.

If the application sets the O_DIRECTORY flag, and tries to open a
regular file, nfs_atomic_open() will punt to doing a regular lookup.
If the server then returns a regular file, we will happily return a
file descriptor with uninitialised open state.

The fix is to return the expected ENOTDIR error in these cases.

Reported-by: Lyu Tao <tao.lyu@epfl.ch>
Fixes: 0dd2b474d0b6 ("nfs: implement i_op->atomic_open()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1967,6 +1967,19 @@ out:
 
 no_open:
 	res = nfs_lookup(dir, dentry, lookup_flags);
+	if (!res) {
+		inode = d_inode(dentry);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode))
+			res = ERR_PTR(-ENOTDIR);
+	} else if (!IS_ERR(res)) {
+		inode = d_inode(res);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-ENOTDIR);
+		}
+	}
 	if (switched) {
 		d_lookup_done(dentry);
 		if (!res)


