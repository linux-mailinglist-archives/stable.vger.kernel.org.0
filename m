Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3890369C09
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244006AbhDWV3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 17:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232466AbhDWV3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 17:29:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 710D46146D;
        Fri, 23 Apr 2021 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619213334;
        bh=T5RHb2YggDTpgWTv964Gu9/vr5TPsOYHkwyJI3FohCc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j/Gpgxk7xaTK0lvhYA4zQnaYFCMSiFALqvYrQ779w3g6UICb4+4BG4Cd/9rJjlWIy
         iUTB9alyY5GIM0rYi4SXJlQ0NbVEF9zO952AkaaWdnFbaV9RQr6A+a37L99Su+CuuR
         zYJYMrMKaj0mSrphilU9Hd3hlzb73RE6yuZ/Hbas=
Date:   Fri, 23 Apr 2021 14:28:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.koenig@amd.com,
        daniel.vetter@ffwll.ch, jaharkes@cs.cmu.edu, jgg@ziepe.ca,
        linux-mm@kvack.org, miklos@szeredi.hu, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 2/5] ovl: fix reference counting in ovl_mmap error
 path
Message-ID: <20210423212854.Tu-9GzF1K%akpm@linux-foundation.org>
In-Reply-To: <20210423142805.fd6d718ec3296452108b3ee0@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: Christian K=C3=B6nig <christian.koenig@amd.com>
Subject: ovl: fix reference counting in ovl_mmap error path

mmap_region() now calls fput() on the vma->vm_file.

Fix this by using vma_set_file() so it doesn't need to be handled manually
here any more.

Link: https://lkml.kernel.org/r/20210421132012.82354-2-christian.koenig@amd=
.com
Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>	[5.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/overlayfs/file.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/overlayfs/file.c~ovl-fix-reference-counting-in-ovl_mmap-error-path
+++ a/fs/overlayfs/file.c
@@ -430,20 +430,11 @@ static int ovl_mmap(struct file *file, s
 	if (WARN_ON(file !=3D vma->vm_file))
 		return -EIO;
=20
-	vma->vm_file =3D get_file(realfile);
+	vma_set_file(vma, realfile);
=20
 	old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
 	ret =3D call_mmap(vma->vm_file, vma);
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
=20
 	return ret;
_
