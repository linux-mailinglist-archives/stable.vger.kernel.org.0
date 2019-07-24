Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BE874586
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390425AbfGYFni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391061AbfGYFng (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8442021880;
        Thu, 25 Jul 2019 05:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033415;
        bh=EEMkZdrmz4xgZdJjlrYw+g+ONXr9nSokfarp7hTEMpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yixGxMCJKoyv180EcQRdrL8rmNJPYQfOhvnyAZ8UmH3Mz/Qa9Auld7kZuNoR65gdu
         niQn9LU62TDIcH2iIZenfD0/Ec9spWHkWZJGBNzBa2AXSEiQkUPWp02PJOBIEGboNm
         Pxgco7iVXH7OhhXkoMUjtOMMPDKsp9eXqEWHIKAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 199/271] NFSv4: Handle the special Linux file open access mode
Date:   Wed, 24 Jul 2019 21:21:08 +0200
Message-Id: <20190724191712.165386730@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 44942b4e457beda00981f616402a1a791e8c616e upstream.

According to the open() manpage, Linux reserves the access mode 3
to mean "check for read and write permission on the file and return
a file descriptor that can't be used for reading or writing."

Currently, the NFSv4 code will ask the server to open the file,
and will use an incorrect share access mode of 0. Since it has
an incorrect share access mode, the client later forgets to send
a corresponding close, meaning it can leak stateids on the server.

Fixes: ce4ef7c0a8a05 ("NFS: Split out NFS v4 file operations")
Cc: stable@vger.kernel.org # 3.6+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/inode.c    |    1 +
 fs/nfs/nfs4file.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1100,6 +1100,7 @@ int nfs_open(struct inode *inode, struct
 	nfs_fscache_open_file(inode, filp);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfs_open);
 
 /*
  * This function is called whenever some part of NFS notices that
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -49,7 +49,7 @@ nfs4_file_open(struct inode *inode, stru
 		return err;
 
 	if ((openflags & O_ACCMODE) == 3)
-		openflags--;
+		return nfs_open(inode, filp);
 
 	/* We can't create new files here */
 	openflags &= ~(O_CREAT|O_EXCL);


