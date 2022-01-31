Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4A44A4169
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358572AbiAaLDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359108AbiAaLC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6E8C061377;
        Mon, 31 Jan 2022 03:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D011260B2D;
        Mon, 31 Jan 2022 11:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0B7C340E8;
        Mon, 31 Jan 2022 11:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626877;
        bh=AW09Hw0O0tjN//AzuiSh6wQwxIaj6bNbvICHTQHbuRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kfqn8BU/gXhBhL2qnZ43+Kloo9Dxp3Fqp8A+mycZIQwtXQ7wYM3tSNMItIgRNGhS5
         IKzXzU4HhXTIrJK4zTIdCEbSjYF8o84ftJsLWr56J5hz7vtuZx9cjJp9BMht3ZxPQG
         BSBisKrvP7Hmh4AOYA/pJ9qQ8aBZMAphgAGdqTAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 41/64] NFSv4: nfs_atomic_open() can race when looking up a non-regular file
Date:   Mon, 31 Jan 2022 11:56:26 +0100
Message-Id: <20220131105217.063133700@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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
@@ -1643,12 +1643,17 @@ no_open:
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


