Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6AE1BDADD
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD2LmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 07:42:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22917 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbgD2LmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 07:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588160529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9cT1mXLJeo67aI/nDrhq7xrwHQapayokq+dAE+1PfKQ=;
        b=TEzy5IZIDRYMElGxiJ9uDNHQ4yaow9jgJvdj9WSyf+3JXZ4yq/rzlo+0IVkt3H//F4JTn2
        8Kvk9cQIH6DuFZqAN+BuHEv7y53OS3fLvA6+f+G6dUdX0I4d5cFT1cAu+3bdGBsMT/Mku/
        zmJJBzWY42wEqd8LP+lou9IbTSD911o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-gVdv0aFkMn6TIRgNvQxNGg-1; Wed, 29 Apr 2020 07:42:07 -0400
X-MC-Unique: gVdv0aFkMn6TIRgNvQxNGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F4A3107ACF7
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 11:42:06 +0000 (UTC)
Received: from max.home.com (ovpn-114-63.ams2.redhat.com [10.36.114.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AF995D76A;
        Wed, 29 Apr 2020 11:42:02 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: Another gfs2_walk_metadata fix
Date:   Wed, 29 Apr 2020 13:42:00 +0200
Message-Id: <20200429114200.232971-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure we don't walk past the end of the metadata in gfs2_walk_metadat=
a: the
inode holds fewer pointers than indirect blocks.

Slightly clean up gfs2_iomap_get.

Fixes: a27a0c9b6a20 ("gfs2: gfs2_walk_metadata fix")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/bmap.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 936a8ec6b48e..6306eaae378b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -528,10 +528,12 @@ static int gfs2_walk_metadata(struct inode *inode, =
struct metapath *mp,
=20
 		/* Advance in metadata tree. */
 		(mp->mp_list[hgt])++;
-		if (mp->mp_list[hgt] >=3D sdp->sd_inptrs) {
-			if (!hgt)
+		if (hgt) {
+			if (mp->mp_list[hgt] >=3D sdp->sd_inptrs)
+				goto lower_metapath;
+		} else {
+			if (mp->mp_list[hgt] >=3D sdp->sd_diptrs)
 				break;
-			goto lower_metapath;
 		}
=20
 fill_up_metapath:
@@ -876,10 +878,9 @@ static int gfs2_iomap_get(struct inode *inode, loff_=
t pos, loff_t length,
 					ret =3D -ENOENT;
 					goto unlock;
 				} else {
-					/* report a hole */
 					iomap->offset =3D pos;
 					iomap->length =3D length;
-					goto do_alloc;
+					goto hole_found;
 				}
 			}
 			iomap->length =3D size;
@@ -933,8 +934,6 @@ static int gfs2_iomap_get(struct inode *inode, loff_t=
 pos, loff_t length,
 	return ret;
=20
 do_alloc:
-	iomap->addr =3D IOMAP_NULL_ADDR;
-	iomap->type =3D IOMAP_HOLE;
 	if (flags & IOMAP_REPORT) {
 		if (pos >=3D size)
 			ret =3D -ENOENT;
@@ -956,6 +955,9 @@ static int gfs2_iomap_get(struct inode *inode, loff_t=
 pos, loff_t length,
 		if (pos < size && height =3D=3D ip->i_height)
 			ret =3D gfs2_hole_size(inode, lblock, len, mp, iomap);
 	}
+hole_found:
+	iomap->addr =3D IOMAP_NULL_ADDR;
+	iomap->type =3D IOMAP_HOLE;
 	goto out;
 }
=20

base-commit: fbe051ea4adf66950e2f23e71ace8eeb4e0e1c73
--=20
2.25.3

