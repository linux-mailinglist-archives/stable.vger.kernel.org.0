Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C2367810
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 05:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhDVDnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 23:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhDVDnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 23:43:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E09161445;
        Thu, 22 Apr 2021 03:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619062986;
        bh=QVf8Te4UrFuvOr7OZoN2/0d7/TcKVx8UAau92PSsAXg=;
        h=Date:From:To:Subject:From;
        b=COL5aGwjmX/GSmO0VI+rEQnkq7LGDwFsJ6dADXcEFsE4cfAtOJTU0OVUjbzy0ITJa
         OQbPSCHYc5NAl5iUcJ0UBze4cp8f5HnQZlmeZz6tKIq9sPsLWJcGF/qdLOk9GzjX5D
         CNFq7eVI4bOM54+0tZg/vFLZx55ilBt3HrfSqArQ=
Date:   Wed, 21 Apr 2021 20:43:05 -0700
From:   akpm@linux-foundation.org
To:     christian.koenig@amd.com, jaharkes@cs.cmu.edu, jgg@ziepe.ca,
        miklos@szeredi.hu, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  + ovl-fix-reference-counting-in-ovl_mmap-error-path.patch
 added to -mm tree
Message-ID: <20210422034305.e3mRIeWWu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ovl: fix reference counting in ovl_mmap error path
has been added to the -mm tree.  Its filename is
     ovl-fix-reference-counting-in-ovl_mmap-error-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ovl-fix-reference-counting-in=
-ovl_mmap-error-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ovl-fix-reference-counting-in=
-ovl_mmap-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

coda-fix-reference-counting-in-coda_file_mmap-error-path.patch
ovl-fix-reference-counting-in-ovl_mmap-error-path.patch

