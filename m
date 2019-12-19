Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7C8126BBE
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfLSSx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbfLSSxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C0F824679;
        Thu, 19 Dec 2019 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781634;
        bh=8cJPzHB9UBMtrpOt681rBiJ2VXcfE/kr+hGaYCA90oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koEV3Kk1NIRcWNXUk9XiDCchovTW6c1dVOdZnjIY1zy02GTpRjJ69FoG+aWXfQmHM
         pprE63J/u36hjyWZwVle95Pix/OQfYFN8hdyQg+dxH7cwvTXH36MOqOuv3VAxRA/oF
         lDXwSCkauzRFyWwFYJVI8V81OsPwEc164x3Ah95E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.4 18/80] gfs2: fix glock reference problem in gfs2_trans_remove_revoke
Date:   Thu, 19 Dec 2019 19:34:10 +0100
Message-Id: <20191219183056.023477756@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit fe5e7ba11fcf1d75af8173836309e8562aefedef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/log.c   |    8 ++++++++
 fs/gfs2/log.h   |    1 +
 fs/gfs2/lops.c  |    5 +----
 fs/gfs2/trans.c |    2 ++
 4 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -609,6 +609,14 @@ void gfs2_add_revoke(struct gfs2_sbd *sd
 	list_add(&bd->bd_list, &sdp->sd_log_revokes);
 }
 
+void gfs2_glock_remove_revoke(struct gfs2_glock *gl)
+{
+	if (atomic_dec_return(&gl->gl_revokes) == 0) {
+		clear_bit(GLF_LFLUSH, &gl->gl_flags);
+		gfs2_glock_queue_put(gl);
+	}
+}
+
 void gfs2_write_revokes(struct gfs2_sbd *sdp)
 {
 	struct gfs2_trans *tr;
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -77,6 +77,7 @@ extern void gfs2_ail1_flush(struct gfs2_
 extern void gfs2_log_shutdown(struct gfs2_sbd *sdp);
 extern int gfs2_logd(void *data);
 extern void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
+extern void gfs2_glock_remove_revoke(struct gfs2_glock *gl);
 extern void gfs2_write_revokes(struct gfs2_sbd *sdp);
 
 #endif /* __LOG_DOT_H__ */
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -882,10 +882,7 @@ static void revoke_lo_after_commit(struc
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
 		gl = bd->bd_gl;
-		if (atomic_dec_return(&gl->gl_revokes) == 0) {
-			clear_bit(GLF_LFLUSH, &gl->gl_flags);
-			gfs2_glock_queue_put(gl);
-		}
+		gfs2_glock_remove_revoke(gl);
 		kmem_cache_free(gfs2_bufdata_cachep, bd);
 	}
 }
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -262,6 +262,8 @@ void gfs2_trans_remove_revoke(struct gfs
 			list_del_init(&bd->bd_list);
 			gfs2_assert_withdraw(sdp, sdp->sd_log_num_revoke);
 			sdp->sd_log_num_revoke--;
+			if (bd->bd_gl)
+				gfs2_glock_remove_revoke(bd->bd_gl);
 			kmem_cache_free(gfs2_bufdata_cachep, bd);
 			tr->tr_num_revoke--;
 			if (--n == 0)


