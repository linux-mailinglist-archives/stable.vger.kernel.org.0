Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8501AFCA26
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 16:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKNPoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 10:44:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56917 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726923AbfKNPoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 10:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573746239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hlZbpUIp7UPSUVUXq6bYyLVjB9cWtntSXjEHrzGR8Hg=;
        b=WJxclRNFIzEV2SBfHzuj5pCi0x4v3xW2SvlUVeFX0xsbVADBkdJAmv/CThEUGyNZ87TVLB
        ejlLVBD6GFsbAZzeBU7VtaZwS3yYqpv3xnKU5pKtJI2RCvI31olueou1caTRS3hh1nauY8
        pNLfaJeVwdQ93aqxIrpLKupfFRsA55M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-Hs7WJba2PkSuYM6qWmE-cQ-1; Thu, 14 Nov 2019 10:43:56 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 023AE593A1
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 15:43:56 +0000 (UTC)
Received: from max.com (unknown [10.40.206.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE635ED2C;
        Thu, 14 Nov 2019 15:43:54 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     rpeterso@redhat.com
Cc:     stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] gfs2: fix glock reference problem in gfs2_trans_remove_revoke
Date:   Thu, 14 Nov 2019 16:43:52 +0100
Message-Id: <20191114154352.10660-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Hs7WJba2PkSuYM6qWmE-cQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Commit 9287c6452d2b fixed a situation in which gfs2 could use a glock
after it had been freed. To do that, it temporarily added a new glock
reference by calling gfs2_glock_hold in function gfs2_add_revoke.
However, if the bd element was removed by gfs2_trans_remove_revoke, it
failed to drop the additional reference.

This patch adds logic to gfs2_trans_remove_revoke to properly drop the
additional glock reference.

Fixes: 9287c6452d2b ("gfs2: Fix occasional glock use-after-free")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/log.c   | 8 ++++++++
 fs/gfs2/log.h   | 1 +
 fs/gfs2/lops.c  | 5 +----
 fs/gfs2/trans.c | 2 ++
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4a7713c62f04..68af71eb28c6 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -611,6 +611,14 @@ void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2=
_bufdata *bd)
 =09list_add(&bd->bd_list, &sdp->sd_log_revokes);
 }
=20
+void gfs2_glock_remove_revoke(struct gfs2_glock *gl)
+{
+=09if (atomic_dec_return(&gl->gl_revokes) =3D=3D 0) {
+=09=09clear_bit(GLF_LFLUSH, &gl->gl_flags);
+=09=09gfs2_glock_queue_put(gl);
+=09}
+}
+
 void gfs2_write_revokes(struct gfs2_sbd *sdp)
 {
 =09struct gfs2_trans *tr;
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 2421181dbfb9..2ff163a8dce1 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -76,6 +76,7 @@ extern void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct =
writeback_control *wbc)
=20
 extern int gfs2_logd(void *data);
 extern void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)=
;
+extern void gfs2_glock_remove_revoke(struct gfs2_glock *gl);
 extern void gfs2_write_revokes(struct gfs2_sbd *sdp);
=20
 #endif /* __LOG_DOT_H__ */
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 313b83ef6657..55fed7daf2b1 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -883,10 +883,7 @@ static void revoke_lo_after_commit(struct gfs2_sbd *sd=
p, struct gfs2_trans *tr)
 =09=09bd =3D list_entry(head->next, struct gfs2_bufdata, bd_list);
 =09=09list_del_init(&bd->bd_list);
 =09=09gl =3D bd->bd_gl;
-=09=09if (atomic_dec_return(&gl->gl_revokes) =3D=3D 0) {
-=09=09=09clear_bit(GLF_LFLUSH, &gl->gl_flags);
-=09=09=09gfs2_glock_queue_put(gl);
-=09=09}
+=09=09gfs2_glock_remove_revoke(gl);
 =09=09kmem_cache_free(gfs2_bufdata_cachep, bd);
 =09}
 }
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 35e3059255fe..9d4227330de4 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -262,6 +262,8 @@ void gfs2_trans_remove_revoke(struct gfs2_sbd *sdp, u64=
 blkno, unsigned int len)
 =09=09=09list_del_init(&bd->bd_list);
 =09=09=09gfs2_assert_withdraw(sdp, sdp->sd_log_num_revoke);
 =09=09=09sdp->sd_log_num_revoke--;
+=09=09=09if (bd->bd_gl)
+=09=09=09=09gfs2_glock_remove_revoke(bd->bd_gl);
 =09=09=09kmem_cache_free(gfs2_bufdata_cachep, bd);
 =09=09=09tr->tr_num_revoke--;
 =09=09=09if (--n =3D=3D 0)
--=20
2.20.1

