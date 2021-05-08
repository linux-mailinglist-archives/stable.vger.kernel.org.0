Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4DE377462
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 00:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEHWjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 18:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 18:39:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F58610D2;
        Sat,  8 May 2021 22:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513523;
        bh=lsDyGqCAzwAml6nr5+7RdkLOT9pIkwXS/4IiGFppkxU=;
        h=Date:From:To:Subject:From;
        b=vgQ5Rq5oku46nQ101FddcWNVBnQ8Zx/ZxRwkmpeVIQ/C4JNtMXWIb3AnaU6OgCu1q
         +mmUEnwY7kf1+/YvBbk7boXarOvx3eQmUJMPK2FQJ7NNFgIiagkmptPfVfjzDHDya8
         93qrWQB6ez0jA2lNy2MwBA5M9z08ldQlmyOZFTAk=
Date:   Sat, 08 May 2021 15:38:43 -0700
From:   akpm@linux-foundation.org
To:     christian.koenig@amd.com, daniel.vetter@ffwll.ch,
        jaharkes@cs.cmu.edu, jgg@ziepe.ca, miklos@szeredi.hu,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 ovl-fix-reference-counting-in-ovl_mmap-error-path.patch removed from -mm
 tree
Message-ID: <20210508223843.GqJ8DqJDC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ovl: fix reference counting in ovl_mmap error path
has been removed from the -mm tree.  Its filename was
     ovl-fix-reference-counting-in-ovl_mmap-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from christian.koenig@amd.com are


