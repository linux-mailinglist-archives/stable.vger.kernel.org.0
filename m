Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54254A44EA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244984AbiAaLe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379587AbiAaLa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869C7C0613A9;
        Mon, 31 Jan 2022 03:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27C9E612D6;
        Mon, 31 Jan 2022 11:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5C3C340E8;
        Mon, 31 Jan 2022 11:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628070;
        bh=Crhrdqqo8n0ShcPttMhWpgJayROc3hkNjS25OG7aPH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8M6X4do/ooBODDl+NvaElOlu2mndgQ0/ru8IXt/a8HMYvsDuJhBTkJ2zj1Q6rsiQ
         vFLEmtSAp1KTRzRQjbNn9hJvexplzfEFlPDX8Q8y39B9p3pNwAEjCWXQIwDS1dDhpx
         RgQOfFjfzlfpHSGeY2QCqGnlr4buuVuWOB7s/m8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.16 115/200] NFSv4: nfs_atomic_open() can race when looking up a non-regular file
Date:   Mon, 31 Jan 2022 11:56:18 +0100
Message-Id: <20220131105237.448604541@linuxfoundation.org>
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
@@ -1972,12 +1972,17 @@ no_open:
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


