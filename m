Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C982936780F
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 05:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhDVDnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 23:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhDVDnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 23:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1148D61004;
        Thu, 22 Apr 2021 03:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619062983;
        bh=OAEBgCXd1lB5OfYqUecTPVrcd3xaq+Z6Kb6YBQkSbck=;
        h=Date:From:To:Subject:From;
        b=nsoarWpyVRuxR6t113Q0pljRO7ebYaKVfadM8T7RuAzFDr8fVfKcQCPCT8TJzi5CZ
         CH3sv8/El/+h64RQMUqhexT6GorAUrji1Qb3FdVATThb7BTFDZkvNAqoR1xKj37QLy
         Bg6TZ+1bBaf+ybY05K3oTExYZ/myw082+uZFUYgA=
Date:   Wed, 21 Apr 2021 20:43:02 -0700
From:   akpm@linux-foundation.org
To:     christian.koenig@amd.com, jaharkes@cs.cmu.edu, jgg@ziepe.ca,
        miklos@szeredi.hu, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 coda-fix-reference-counting-in-coda_file_mmap-error-path.patch added to -mm
 tree
Message-ID: <20210422034302.yQ5OKt7Lt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coda: fix reference counting in coda_file_mmap error path
has been added to the -mm tree.  Its filename is
     coda-fix-reference-counting-in-coda_file_mmap-error-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-fix-reference-counting-i=
n-coda_file_mmap-error-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-fix-reference-counting-i=
n-coda_file_mmap-error-path.patch

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
Subject: coda: fix reference counting in coda_file_mmap error path

mmap_region() now calls fput() on the vma->vm_file.

So we need to drop the extra reference on the coda file instead of the
host file.

Link: https://lkml.kernel.org/r/20210421132012.82354-1-christian.koenig@amd=
.com
Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>	[5.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/coda/file.c~coda-fix-reference-counting-in-coda_file_mmap-error-pa=
th
+++ a/fs/coda/file.c
@@ -175,10 +175,10 @@ coda_file_mmap(struct file *coda_file, s
 	ret =3D call_mmap(vma->vm_file, vma);
=20
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
_

Patches currently in -mm which might be from christian.koenig@amd.com are

coda-fix-reference-counting-in-coda_file_mmap-error-path.patch
ovl-fix-reference-counting-in-ovl_mmap-error-path.patch

