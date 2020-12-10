Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35192D601D
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391331AbgLJPlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391281AbgLJOkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:15 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 65/75] gfs2: Fix deadlock dumping resource group glocks
Date:   Thu, 10 Dec 2020 15:27:30 +0100
Message-Id: <20201210142609.235645522@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 16e6281b6b22b0178eab95c6a82502d7b10f67b8 upstream.

Commit 0e539ca1bbbe ("gfs2: Fix NULL pointer dereference in gfs2_rgrp_dump")
introduced additional locking in gfs2_rgrp_go_dump, which is also used for
dumping resource group glocks via debugfs.  However, on that code path, the
glock spin lock is already taken in dump_glock, and taking it again in
gfs2_glock2rgrp leads to deadlock.  This can be reproduced with:

  $ mkfs.gfs2 -O -p lock_nolock /dev/FOO
  $ mount /dev/FOO /mnt/foo
  $ touch /mnt/foo/bar
  $ cat /sys/kernel/debug/gfs2/FOO/glocks

Fix that by not taking the glock spin lock inside the go_dump callback.

Fixes: 0e539ca1bbbe ("gfs2: Fix NULL pointer dereference in gfs2_rgrp_dump")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/glops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -230,7 +230,7 @@ static void rgrp_go_inval(struct gfs2_gl
 static void gfs2_rgrp_go_dump(struct seq_file *seq, struct gfs2_glock *gl,
 			      const char *fs_id_buf)
 {
-	struct gfs2_rgrpd *rgd = gfs2_glock2rgrp(gl);
+	struct gfs2_rgrpd *rgd = gl->gl_object;
 
 	if (rgd)
 		gfs2_rgrp_dump(seq, rgd, fs_id_buf);


