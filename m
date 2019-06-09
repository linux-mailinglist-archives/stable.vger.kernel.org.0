Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223C03A743
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbfFIQsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbfFIQsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:48:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28545205ED;
        Sun,  9 Jun 2019 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098880;
        bh=j8+0werx+ueP1SttlAq1Hd3V5fyJGBI9OfJYTnaDHTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlbIGjRr2hFcDYMJ4vGzEe9cmc3sx4EXaC1tyB3/i+BSklDrY5CUXNaZDcV0kDpfv
         CQoYGwNswGKZKJhJ/vwj/87cQ08b1jJorrvmjmgA6JvCqqxZBa3UD39hNfNAK7Fumu
         6Dcl+JT50nZLe3fYcdvEK9iTmd+DQMboZf/HJBbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 22/51] fuse: fallocate: fix return with locked inode
Date:   Sun,  9 Jun 2019 18:42:03 +0200
Message-Id: <20190609164128.380174810@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 35d6fcbb7c3e296a52136347346a698a35af3fda upstream.

Do the proper cleanup in case the size check fails.

Tested with xfstests:generic/228

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 0cbade024ba5 ("fuse: honor RLIMIT_FSIZE in fuse_file_fallocate")
Cc: Liu Bo <bo.liu@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # v3.5
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2981,7 +2981,7 @@ static long fuse_file_fallocate(struct f
 	    offset + length > i_size_read(inode)) {
 		err = inode_newsize_ok(inode, offset + length);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE))


