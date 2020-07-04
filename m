Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5927214433
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 07:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgGDFSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 01:18:25 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17182 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbgGDFSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jul 2020 01:18:25 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1593839800; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=cH3fMM6AxZDpl2d4rcfQgWTFHbPslMi4bGf4duyX7Qc91mw5AHEv3mVV+PeyLr2Icu3qe4cODK8lGv6s+l+DLEU0AHIHYlUmpZLUWWGM0NDgKwonKM+D5Gw48gfGyEFtKFTfBZY7aEeXTWduqPUYv058J8H2M1s5rjLSy02GFm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1593839800; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=YLLrDOGqgYXy/vTV2s26TY2MvCGLpgiKnFBxKuZSfnA=; 
        b=Sr0NHB9qdVnnccVWGJ9gqLNfhhyMQ+ON533z5WumqcDY/Rn6TZ4njs3UtcgPgZ3K796XZXhHRtXzoz3T3n1XahrX+mCxL94W8u85rhBWrzrtR1aRGgu6hTeLc0TeWx+T3T3rrTNG/lnvDgkUk7eS4WbDnKHl+mQjSQsM4s0DxxM=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1593839800;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=YLLrDOGqgYXy/vTV2s26TY2MvCGLpgiKnFBxKuZSfnA=;
        b=fmmRnkgGdb1szMvzCNmc5QXMnKmcImGzkbijeZAqvIQChNctap7ZN4o77i7ql0hj
        wIm9iIHXNlqwnM/9n/iEC1Wq9wk+FYXot+2fBIaOlAcFaruwOotR1bTckmqCpE0fndQ
        O1u7RQ8cxPCMwQ0cn6a1KThzwjhYnUdiIV/bEv34=
Received: from localhost.localdomain (113.116.49.35 [113.116.49.35]) by mx.zoho.com.cn
        with SMTPS id 1593839798113132.82200331545323; Sat, 4 Jul 2020 13:16:38 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     akpm@linux-foundation.org
Cc:     stable@vger.kernel.org, dxu@dxuuu.xyz, chris@chrisdown.name,
        adilger@dilger.ca, gregkh@linuxfoundation.org, tj@kernel.org,
        viro@zeniv.linux.org.uk, hughd@google.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200704051608.15043-1-cgxu519@mykernel.net>
Subject: [PATCH v2] vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way
Date:   Sat,  4 Jul 2020 13:16:08 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit fdc85222d58e ("kernfs: kvmalloc xattr value
instead of kmalloc"), simple xattr entry is allocated with
kvmalloc() instead of kmalloc(), so we should release it
with kvfree() instead of kfree().

Cc: stable@vger.kernel.org # v5.7
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Chris Down <chris@chrisdown.name>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Fixes: fdc85222d58e ("kernfs: kvmalloc xattr value instead of kmalloc")
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
v1->v2:
- Fix freeing issue in simple_xattrs_free().
- Change patch subject.

 include/linux/xattr.h | 3 ++-
 mm/shmem.c            | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 47eaa34f8761..c5afaf8ca7a2 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/mm.h>
 #include <uapi/linux/xattr.h>
=20
 struct inode;
@@ -94,7 +95,7 @@ static inline void simple_xattrs_free(struct simple_xattr=
s *xattrs)
=20
 =09list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
 =09=09kfree(xattr->name);
-=09=09kfree(xattr);
+=09=09kvfree(xattr);
 =09}
 }
=20
diff --git a/mm/shmem.c b/mm/shmem.c
index a0dbe62f8042..b2abca3f7f33 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3178,7 +3178,7 @@ static int shmem_initxattrs(struct inode *inode,
 =09=09new_xattr->name =3D kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
 =09=09=09=09=09  GFP_KERNEL);
 =09=09if (!new_xattr->name) {
-=09=09=09kfree(new_xattr);
+=09=09=09kvfree(new_xattr);
 =09=09=09return -ENOMEM;
 =09=09}
=20
--=20
2.20.1


