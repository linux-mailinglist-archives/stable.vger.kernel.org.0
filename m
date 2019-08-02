Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8BF7F20E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391526AbfHBJoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405267AbfHBJog (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:44:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01739206A2;
        Fri,  2 Aug 2019 09:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739075;
        bh=q9sMUCzCjEnEdAMJ/VmD7ONcEsB2+1D51FFCJLn0kZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEOWuYcWFKoe5KtR0f0YhrrJMJMXmbKYMo8R/Nxy8tVBaUMXcjnY9OLAhG26Zwb2z
         w7AaS19djJdn5bLSFL2lZc88etWMqryCSfS1Yrh/jHHi+yZc740hZDk2C4J3E70q9N
         74b85Q43/u6if+rGEyspPw/MtdjIiOowYlRLL0HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.9 088/223] NFSv4: Handle the special Linux file open access mode
Date:   Fri,  2 Aug 2019 11:35:13 +0200
Message-Id: <20190802092244.762091182@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
@@ -950,6 +950,7 @@ int nfs_open(struct inode *inode, struct
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


