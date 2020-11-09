Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECB12ABA60
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732871AbgKINSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732513AbgKINSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4104D2083B;
        Mon,  9 Nov 2020 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927902;
        bh=HLMcZg+OeZn1+X+Sra4sGuFNXd1r46df3zQ3GoFXdLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4buvlArklwCS3XcD8CnIF3fDv5zeLUtuIkSq+4GOwWAPBGusQRS0mM3DTLgfA1Sn
         ozjX2qZKkD+0ynPSFW/kx0fqsPjrUpfnoauFe3FzSqeeU/je+RpQGbbliWw49b91P2
         rXiUTd83soYpF1MKHKgrCXEvoFtDNqbULiq3l3jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Ahring Oder Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 059/133] gfs2: Dont call cancel_delayed_work_sync from within delete work function
Date:   Mon,  9 Nov 2020 13:55:21 +0100
Message-Id: <20201109125033.568736123@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 6bd1c7bd4ee7b17980cdc347522dcb76feac9b98 upstream.

Right now, we can end up calling cancel_delayed_work_sync from within
delete_work_func via gfs2_lookup_by_inum -> gfs2_inode_lookup ->
gfs2_cancel_delete_work.  When that happens, it will result in a
deadlock.  Instead, gfs2_inode_lookup should skip the call to
gfs2_cancel_delete_work when called from delete_work_func (blktype ==
GFS2_BLKST_UNLINKED).

Reported-by: Alexander Ahring Oder Aring <aahringo@redhat.com>
Fixes: a0e3cc65fa29 ("gfs2: Turn gl_delete into a delayed work")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -180,7 +180,8 @@ struct inode *gfs2_inode_lookup(struct s
 		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 		if (unlikely(error))
 			goto fail;
-		gfs2_cancel_delete_work(ip->i_iopen_gh.gh_gl);
+		if (blktype != GFS2_BLKST_UNLINKED)
+			gfs2_cancel_delete_work(ip->i_iopen_gh.gh_gl);
 		glock_set_object(ip->i_iopen_gh.gh_gl, ip);
 		gfs2_glock_put(io_gl);
 		io_gl = NULL;


