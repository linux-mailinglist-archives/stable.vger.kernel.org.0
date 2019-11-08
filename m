Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169E0F4BF7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfKHMiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:38:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726199AbfKHMiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 07:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573216702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+qGZKTynsT8+tlXJru7A+ZjufiUpA02K1rrJMH/k/+Y=;
        b=MHYayCleHbHcolyskIdm5xC2eJQ8BPx463eUhH0V0MPI6lshp+aUNYSD8vJh4Z3I6LFEgR
        EZb99NCOCF1kfGppduRj9u4Ncg7Rs34hyGEPkVIC+IfphFu205hmuykZ7R9tmaPEuOaLx4
        8M/nzmgZOhxqMKHCRhG2m5Ts7XnTf5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-m-rA_OdeMXieg1mOSWDC8A-1; Fri, 08 Nov 2019 07:38:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF42A107ACC3
        for <stable@vger.kernel.org>; Fri,  8 Nov 2019 12:38:19 +0000 (UTC)
Received: from max.com (unknown [10.40.206.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3F3A6084E;
        Fri,  8 Nov 2019 12:38:16 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] gfs2: Multi-block allocations in gfs2_page_mkwrite
Date:   Fri,  8 Nov 2019 13:38:13 +0100
Message-Id: <20191108123814.5138-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: m-rA_OdeMXieg1mOSWDC8A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In gfs2_page_mkwrite's gfs2_allocate_page_backing helper, try to
allocate as many blocks at once as we need.  Pass in the size of the
requested allocation.

Fixes: 35af80aef99b ("gfs2: don't use buffer_heads in gfs2_allocate_page_ba=
cking")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/file.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 33ace1832294..30b857017fd3 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -381,27 +381,28 @@ static void gfs2_size_hint(struct file *filep, loff_t=
 offset, size_t size)
 /**
  * gfs2_allocate_page_backing - Allocate blocks for a write fault
  * @page: The (locked) page to allocate backing for
+ * @length: Size of the allocation
  *
  * We try to allocate all the blocks required for the page in one go.  Thi=
s
  * might fail for various reasons, so we keep trying until all the blocks =
to
  * back this page are allocated.  If some of the blocks are already alloca=
ted,
  * that is ok too.
  */
-static int gfs2_allocate_page_backing(struct page *page)
+static int gfs2_allocate_page_backing(struct page *page, unsigned int leng=
th)
 {
 =09u64 pos =3D page_offset(page);
-=09u64 size =3D PAGE_SIZE;
=20
 =09do {
 =09=09struct iomap iomap =3D { };
=20
-=09=09if (gfs2_iomap_get_alloc(page->mapping->host, pos, 1, &iomap))
+=09=09if (gfs2_iomap_get_alloc(page->mapping->host, pos, length, &iomap))
 =09=09=09return -EIO;
=20
-=09=09iomap.length =3D min(iomap.length, size);
-=09=09size -=3D iomap.length;
+=09=09if (length < iomap.length)
+=09=09=09iomap.length =3D length;
+=09=09length -=3D iomap.length;
 =09=09pos +=3D iomap.length;
-=09} while (size > 0);
+=09} while (length > 0);
=20
 =09return 0;
 }
@@ -501,7 +502,7 @@ static vm_fault_t gfs2_page_mkwrite(struct vm_fault *vm=
f)
 =09if (gfs2_is_stuffed(ip))
 =09=09ret =3D gfs2_unstuff_dinode(ip, page);
 =09if (ret =3D=3D 0)
-=09=09ret =3D gfs2_allocate_page_backing(page);
+=09=09ret =3D gfs2_allocate_page_backing(page, PAGE_SIZE);
=20
 out_trans_end:
 =09if (ret)
--=20
2.20.1

