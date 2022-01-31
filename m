Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E44A41B8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243790AbiAaLFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:05:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52194 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359032AbiAaLEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:04:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE016B82A68;
        Mon, 31 Jan 2022 11:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB029C340E8;
        Mon, 31 Jan 2022 11:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627054;
        bh=q2Z8elQyrGNjcKvyqzotXwhcSaZaD3Bj681ehZS/2Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRZ/n3MBs/UzYYdiL56XlpJwKcbI04JdwApU1regGcDWWe8sybwpgzXYx+jYjFakv
         FnGhMVXrGg+HgDx34guoa852hJigodxVVy/fGpnkLj3KrUR+Kp0+VxcnULfpLfOfG7
         /c6662DkYgFPdwBGwYiQmnhLOPQJOtbRhO24mb7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.10 060/100] NFSv4: nfs_atomic_open() can race when looking up a non-regular file
Date:   Mon, 31 Jan 2022 11:56:21 +0100
Message-Id: <20220131105222.450508252@linuxfoundation.org>
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

commit 1751fc1db36f6f411709e143d5393f92d12137a9 upstream.

If the file type changes back to being a regular file on the server
between the failed OPEN and our LOOKUP, then we need to re-run the OPEN.

Fixes: 0dd2b474d0b6 ("nfs: implement i_op->atomic_open()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1782,12 +1782,17 @@ no_open:
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
 		    !S_ISDIR(inode->i_mode))
 			res = ERR_PTR(-ENOTDIR);
+		else if (inode && S_ISREG(inode->i_mode))
+			res = ERR_PTR(-EOPENSTALE);
 	} else if (!IS_ERR(res)) {
 		inode = d_inode(res);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
 		    !S_ISDIR(inode->i_mode)) {
 			dput(res);
 			res = ERR_PTR(-ENOTDIR);
+		} else if (inode && S_ISREG(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-EOPENSTALE);
 		}
 	}
 	if (switched) {


