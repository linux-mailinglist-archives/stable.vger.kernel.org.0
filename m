Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4894F4521A8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346561AbhKPBF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245456AbhKOTUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B04B6353E;
        Mon, 15 Nov 2021 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001299;
        bh=+OD0D2TZMT1XPeGXqGBv0aMwt/RIOkOeDyIfPGgWW1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPUM9Rw3kXeFwVPrXn+GY4Rj1SRzZaOLkJtIYU1ZHM4KNwRRDof8cwas7/u7mDRDS
         yBryjfGgs0paj/hZhnCCy9eM+pMBB8mhubeztEuNdYa6gOkta9LJhWtH0i57dHoHBo
         02MRXAAQourB6ueEtZnwFiunZLc8+XcQs/8LrVEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 138/917] ovl: fix use after free in struct ovl_aio_req
Date:   Mon, 15 Nov 2021 17:53:53 +0100
Message-Id: <20211115165433.449951285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 9a254403760041528bc8f69fe2f5e1ef86950991 upstream.

Example for triggering use after free in a overlay on ext4 setup:

aio_read
  ovl_read_iter
    vfs_iter_read
      ext4_file_read_iter
        ext4_dio_read_iter
          iomap_dio_rw -> -EIOCBQUEUED
          /*
	   * Here IO is completed in a separate thread,
	   * ovl_aio_cleanup_handler() frees aio_req which has iocb embedded
	   */
          file_accessed(iocb->ki_filp); /**BOOM**/

Fix by introducing a refcount in ovl_aio_req similarly to aio_kiocb.  This
guarantees that iocb is only freed after vfs_read/write_iter() returns on
underlying fs.

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/r/20210930032228.3199690-3-yangerkun@huawei.com/
Cc: <stable@vger.kernel.org> # v5.6
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -17,6 +17,7 @@
 
 struct ovl_aio_req {
 	struct kiocb iocb;
+	refcount_t ref;
 	struct kiocb *orig_iocb;
 	struct fd fd;
 };
@@ -252,6 +253,14 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
 	return flags;
 }
 
+static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
+{
+	if (refcount_dec_and_test(&aio_req->ref)) {
+		fdput(aio_req->fd);
+		kmem_cache_free(ovl_aio_request_cachep, aio_req);
+	}
+}
+
 static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 {
 	struct kiocb *iocb = &aio_req->iocb;
@@ -268,8 +277,7 @@ static void ovl_aio_cleanup_handler(stru
 	}
 
 	orig_iocb->ki_pos = iocb->ki_pos;
-	fdput(aio_req->fd);
-	kmem_cache_free(ovl_aio_request_cachep, aio_req);
+	ovl_aio_put(aio_req);
 }
 
 static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
@@ -319,7 +327,9 @@ static ssize_t ovl_read_iter(struct kioc
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
+		refcount_set(&aio_req->ref, 2);
 		ret = vfs_iocb_iter_read(real.file, &aio_req->iocb, iter);
+		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
 	}
@@ -390,7 +400,9 @@ static ssize_t ovl_write_iter(struct kio
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
+		refcount_set(&aio_req->ref, 2);
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
+		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
 	}


