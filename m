Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515C436AE98
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhDZHps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233861AbhDZHoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E2C9613E5;
        Mon, 26 Apr 2021 07:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422858;
        bh=HenWS5x8f+ZywjTNGAoZzyt5nvnzhCejCDEqCln740g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH4rABC2UiWyV6UMZB/2S4eb5otw3isz4SAgwrAgHEqIT96VAcQYEuZo/zDgbPlZv
         WhM5A31od1uiSzy/xBd888ZkVlTOvD18+tQNkBUT4zQsCB1UBcRbrjaGAeFM+X0p7B
         Wkasq7IFRi+SDEw8UEEoeqPGfMYEb9msWKmgbrqk=
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
Subject: [PATCH 5.11 02/41] ovl: fix reference counting in ovl_mmap error path
Date:   Mon, 26 Apr 2021 09:29:49 +0200
Message-Id: <20210426072819.765051276@linuxfoundation.org>
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

commit 2896900e22f8212606a1837d89a6bbce314ceeda upstream.

mmap_region() now calls fput() on the vma->vm_file.

Fix this by using vma_set_file() so it doesn't need to be handled
manually here any more.

Link: https://lkml.kernel.org/r/20210421132012.82354-2-christian.koenig@amd.com
Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>	[5.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -430,20 +430,11 @@ static int ovl_mmap(struct file *file, s
 	if (WARN_ON(file != vma->vm_file))
 		return -EIO;
 
-	vma->vm_file = get_file(realfile);
+	vma_set_file(vma, realfile);
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = call_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
-
-	if (ret) {
-		/* Drop reference count from new vm_file value */
-		fput(realfile);
-	} else {
-		/* Drop reference count from previous vm_file value */
-		fput(file);
-	}
-
 	ovl_file_accessed(file);
 
 	return ret;


