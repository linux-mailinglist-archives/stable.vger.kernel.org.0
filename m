Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7033836AEA0
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhDZHpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233998AbhDZHok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B7B611C1;
        Mon, 26 Apr 2021 07:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422869;
        bh=vJoycszaeIqNNiuqQYU/Ee9eUtjvNQbOEef7Um3ihps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMjd5qZQlFcrlp23APZ/T2aAciB2kwBD56Fsz+Lvw9TxFeU4lbd0hyYS9Ukq8/P3z
         ezq8VAt5DfgoTjig4KHClJ22LY2JHrjtt9p5aeG9fRMYWkdy8j6BZDmMH6HOM/kEJn
         akX/b7SDVZFAr9BXi53RZJL8/ifsxy7u7ovQmrFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 03/41] coda: fix reference counting in coda_file_mmap error path
Date:   Mon, 26 Apr 2021 09:29:50 +0200
Message-Id: <20210426072819.798152252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 9da29c7f77cd04e5c9150e30f047521b6f20a918 upstream.

mmap_region() now calls fput() on the vma->vm_file.

So we need to drop the extra reference on the coda file instead of the
host file.

Link: https://lkml.kernel.org/r/20210421132012.82354-1-christian.koenig@amd.com
Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>	[5.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coda/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -175,10 +175,10 @@ coda_file_mmap(struct file *coda_file, s
 	ret = call_mmap(vma->vm_file, vma);
 
 	if (ret) {
-		/* if call_mmap fails, our caller will put coda_file so we
-		 * should drop the reference to the host_file that we got.
+		/* if call_mmap fails, our caller will put host_file so we
+		 * should drop the reference to the coda_file that we got.
 		 */
-		fput(host_file);
+		fput(coda_file);
 		kfree(cvm_ops);
 	} else {
 		/* here we add redirects for the open/close vm_operations */


