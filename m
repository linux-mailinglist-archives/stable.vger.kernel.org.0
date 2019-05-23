Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C97D28A41
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388149AbfEWTLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388194AbfEWTL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 261D1217D7;
        Thu, 23 May 2019 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638688;
        bh=sBiEtL3xSL3LEDcQEkAfib4ojf4HSSTCLYJxCD6V/jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/2Agi0sm51ZnaNmQV6DpsDXXrxV+qfw93PIDDBjCiOjzsiy80Uyq7pOP0xkzD45c
         ZgyrexhjQQgV4vK4DaxteG2KSn3tj8pKHy7ZspmQ20aFEna07ZFvoqDM8QILMERjH4
         ArJZuFvs+V3qscWrMqIicRExMBoLZDDiw7kuq+qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio SJ Musumeci <trapexit@spawn.link>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.14 28/77] fuse: fix writepages on 32bit
Date:   Thu, 23 May 2019 21:05:46 +0200
Message-Id: <20190523181724.151094898@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 9de5be06d0a89ca97b5ab902694d42dfd2bb77d2 upstream.

Writepage requests were cropped to i_size & 0xffffffff, which meant that
mmaped writes to any file larger than 4G might be silently discarded.

Fix by storing the file size in a properly sized variable (loff_t instead
of size_t).

Reported-by: Antonio SJ Musumeci <trapexit@spawn.link>
Fixes: 6eaf4782eb09 ("fuse: writepages: crop secondary requests")
Cc: <stable@vger.kernel.org> # v3.13
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1525,7 +1525,7 @@ __acquires(fc->lock)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	size_t crop = i_size_read(inode);
+	loff_t crop = i_size_read(inode);
 	struct fuse_req *req;
 
 	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {


