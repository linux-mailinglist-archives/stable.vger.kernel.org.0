Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECED62ABB65
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733116AbgKINOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733112AbgKINOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA205208FE;
        Mon,  9 Nov 2020 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927659;
        bh=DpH6Zl8NC2Hf5I8h7XivIKwIo/+UNMm/LDKzUfcQhDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBZNqSzrq8htXCDdh1b3lLnlzrCGVQS+Zf4o82T+M9NEDL6dK4tb358oBrHGIccm5
         XiuA9zJPvYIaEarEtJqt1gvD8tjZYETJVUOUJldD4pZHnMELZTgKOZw2Dzl48t2hav
         OVTaOPy6wnQ8iMYVSlraIJEnbFjbxSqen9Quyh6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.4 33/85] gfs2: Wake up when sd_glock_disposal becomes zero
Date:   Mon,  9 Nov 2020 13:55:30 +0100
Message-Id: <20201109125024.178032482@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit da7d554f7c62d0c17c1ac3cc2586473c2d99f0bd upstream.

Commit fc0e38dae645 ("GFS2: Fix glock deallocation race") fixed a
sd_glock_disposal accounting bug by adding a missing atomic_dec
statement, but it failed to wake up sd_glock_wait when that decrement
causes sd_glock_disposal to reach zero.  As a consequence,
gfs2_gl_hash_clear can now run into a 10-minute timeout instead of
being woken up.  Add the missing wakeup.

Fixes: fc0e38dae645 ("GFS2: Fix glock deallocation race")
Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/glock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -873,7 +873,8 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 out_free:
 	kfree(gl->gl_lksb.sb_lvbptr);
 	kmem_cache_free(cachep, gl);
-	atomic_dec(&sdp->sd_glock_disposal);
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
 
 out:
 	return ret;


