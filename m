Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7519369C08
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbhDWV3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 17:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhDWV3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 17:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7303061468;
        Fri, 23 Apr 2021 21:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619213331;
        bh=FB56MfyUiyiTrXdyx5rMarSiOFlA48br4dGERILl08I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hU8Nf8iOca6LE/I1lpwtZcjVI5Szq16t8VpCuv2N5b0qZw5h7NcxQzQn2upMw+6py
         GEzXWQ9i7SC4CW9dWQ0zCAF6XxkpXR98Vt8/8+WDZP/PBjXVBkk6t1gmbgoee1XBWX
         7tvFeprWJlsZC2lkxGE5AwsF9gPmYgYz+erkA/+Q=
Date:   Fri, 23 Apr 2021 14:28:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.koenig@amd.com,
        daniel.vetter@ffwll.ch, jaharkes@cs.cmu.edu, jgg@ziepe.ca,
        linux-mm@kvack.org, miklos@szeredi.hu, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 1/5] coda: fix reference counting in
 coda_file_mmap error path
Message-ID: <20210423212851.EzTJf6Dwt%akpm@linux-foundation.org>
In-Reply-To: <20210423142805.fd6d718ec3296452108b3ee0@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
