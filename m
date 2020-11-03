Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84982A5903
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgKCUnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730770AbgKCUnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 669D4223BF;
        Tue,  3 Nov 2020 20:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436230;
        bh=ADtgA4H9r7suyCdg0j5Ry9PfZz6AqdcdG6fFiehr3i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xB2bqQ6nBUYRfW7S6GrFw1Fz+ZAkds9K5t3Pb2zbzX5Lm/A7WsXOIN9eoH6PUdsOO
         0PO0dWKNDPmY88OFwl52CnHBk15Qir3NX90mfWrpmc2s1MSL/crCTx0DeNHmxUXfmV
         wMA0pIGKmcnSQIn94PCyqWzSBz03dObnQ1pKTEJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+43fa87986bdd31df9de6@syzkaller.appspotmail.com,
        Andrew Price <anprice@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 159/391] gfs2: Fix NULL pointer dereference in gfs2_rgrp_dump
Date:   Tue,  3 Nov 2020 21:33:30 +0100
Message-Id: <20201103203357.562383496@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 0e539ca1bbbe85a86549c97a30a765ada4a09df9 ]

When an rindex entry is found to be corrupt, compute_bitstructs() calls
gfs2_consist_rgrpd() which calls gfs2_rgrp_dump() like this:

    gfs2_rgrp_dump(NULL, rgd->rd_gl, fs_id_buf);

gfs2_rgrp_dump then dereferences the gl without checking it and we get

    BUG: KASAN: null-ptr-deref in gfs2_rgrp_dump+0x28/0x280

because there's no rgrp glock involved while reading the rindex on mount.

Fix this by changing gfs2_rgrp_dump to take an rgrp argument.

Reported-by: syzbot+43fa87986bdd31df9de6@syzkaller.appspotmail.com
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 11 ++++++++++-
 fs/gfs2/rgrp.c  |  9 +++------
 fs/gfs2/rgrp.h  |  2 +-
 fs/gfs2/util.c  |  2 +-
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index de1d5f1d9ff85..c2c90747d79b5 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -227,6 +227,15 @@ static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 		rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 }
 
+static void gfs2_rgrp_go_dump(struct seq_file *seq, struct gfs2_glock *gl,
+			      const char *fs_id_buf)
+{
+	struct gfs2_rgrpd *rgd = gfs2_glock2rgrp(gl);
+
+	if (rgd)
+		gfs2_rgrp_dump(seq, rgd, fs_id_buf);
+}
+
 static struct gfs2_inode *gfs2_glock2inode(struct gfs2_glock *gl)
 {
 	struct gfs2_inode *ip;
@@ -712,7 +721,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_sync = rgrp_go_sync,
 	.go_inval = rgrp_go_inval,
 	.go_lock = gfs2_rgrp_go_lock,
-	.go_dump = gfs2_rgrp_dump,
+	.go_dump = gfs2_rgrp_go_dump,
 	.go_type = LM_TYPE_RGRP,
 	.go_flags = GLOF_LVB,
 };
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 074f228ea8390..1bba5a9d45fa3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2209,20 +2209,17 @@ static void rgblk_free(struct gfs2_sbd *sdp, struct gfs2_rgrpd *rgd,
 /**
  * gfs2_rgrp_dump - print out an rgrp
  * @seq: The iterator
- * @gl: The glock in question
+ * @rgd: The rgrp in question
  * @fs_id_buf: pointer to file system id (if requested)
  *
  */
 
-void gfs2_rgrp_dump(struct seq_file *seq, struct gfs2_glock *gl,
+void gfs2_rgrp_dump(struct seq_file *seq, struct gfs2_rgrpd *rgd,
 		    const char *fs_id_buf)
 {
-	struct gfs2_rgrpd *rgd = gl->gl_object;
 	struct gfs2_blkreserv *trs;
 	const struct rb_node *n;
 
-	if (rgd == NULL)
-		return;
 	gfs2_print_dbg(seq, "%s R: n:%llu f:%02x b:%u/%u i:%u r:%u e:%u\n",
 		       fs_id_buf,
 		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
@@ -2253,7 +2250,7 @@ static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
 		(unsigned long long)rgd->rd_addr);
 	fs_warn(sdp, "umount on all nodes and run fsck.gfs2 to fix the error\n");
 	sprintf(fs_id_buf, "fsid=%s: ", sdp->sd_fsname);
-	gfs2_rgrp_dump(NULL, rgd->rd_gl, fs_id_buf);
+	gfs2_rgrp_dump(NULL, rgd, fs_id_buf);
 	rgd->rd_flags |= GFS2_RDF_ERROR;
 }
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index a1d7e14fc55b9..9a587ada51eda 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -67,7 +67,7 @@ extern void gfs2_rlist_add(struct gfs2_inode *ip, struct gfs2_rgrp_list *rlist,
 extern void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist);
 extern void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
 extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
-extern void gfs2_rgrp_dump(struct seq_file *seq, struct gfs2_glock *gl,
+extern void gfs2_rgrp_dump(struct seq_file *seq, struct gfs2_rgrpd *rgd,
 			   const char *fs_id_buf);
 extern int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				   struct buffer_head *bh,
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 1cd0328cae20a..0fba3bf641890 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -419,7 +419,7 @@ void gfs2_consist_rgrpd_i(struct gfs2_rgrpd *rgd,
 	char fs_id_buf[sizeof(sdp->sd_fsname) + 7];
 
 	sprintf(fs_id_buf, "fsid=%s: ", sdp->sd_fsname);
-	gfs2_rgrp_dump(NULL, rgd->rd_gl, fs_id_buf);
+	gfs2_rgrp_dump(NULL, rgd, fs_id_buf);
 	gfs2_lm(sdp,
 		"fatal: filesystem consistency error\n"
 		"  RG = %llu\n"
-- 
2.27.0



