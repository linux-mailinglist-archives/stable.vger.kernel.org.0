Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028D0377461
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 00:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhEHWjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 18:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 18:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7587F613E8;
        Sat,  8 May 2021 22:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513521;
        bh=cR3QH7Y2U9Hv+yhn9D2Jc07PvejJ9mO0KNXxDuhR/lI=;
        h=Date:From:To:Subject:From;
        b=Acew8q7X+mqpIYOdJi1JU0klWF3ORGFgx2txEEBUuM03ZcQzF/mdvZvSWBOTHKgg1
         132Dg4WbUEL39BzTzOqOggZcHYrUc01tPW/cQx3XcD9GRLZV0uF0llftG24k26OpCg
         aPoaukmE7TGR2Yo0fod1pd2GRTcwCLuqQeaGG1VU=
Date:   Sat, 08 May 2021 15:38:41 -0700
From:   akpm@linux-foundation.org
To:     christian.koenig@amd.com, daniel.vetter@ffwll.ch,
        jaharkes@cs.cmu.edu, jgg@ziepe.ca, miklos@szeredi.hu,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 coda-fix-reference-counting-in-coda_file_mmap-error-path.patch removed from
 -mm tree
Message-ID: <20210508223841.ohzKO1QvQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coda: fix reference counting in coda_file_mmap error path
has been removed from the -mm tree.  Its filename was
     coda-fix-reference-counting-in-coda_file_mmap-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>
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


