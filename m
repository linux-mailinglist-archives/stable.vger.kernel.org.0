Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BAF2AB979
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgKINJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbgKINJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA0AA20867;
        Mon,  9 Nov 2020 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927379;
        bh=65Sq76VAYAD0eVL2bxrHe53cS28VuwSk6Wn7trAvsUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsDMMKo+DwQJtOGuNnIKb40SQRlWWxMcDMrDw/KI94l35VlWh1psqTNCznaqLmGW9
         PVyyhgEwxQ2DLkErTH04vAHe33qlRKI92hiuWd89fRaJ6HnvY3JYE8hPb+zHGAHLq2
         WqXVCf14sx1oPtyk/bf6p6VEtd0bmdD5n418t15s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4.19 40/71] gfs2: Wake up when sd_glock_disposal becomes zero
Date:   Mon,  9 Nov 2020 13:55:34 +0100
Message-Id: <20201109125021.790613913@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
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
@@ -870,7 +870,8 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 out_free:
 	kfree(gl->gl_lksb.sb_lvbptr);
 	kmem_cache_free(cachep, gl);
-	atomic_dec(&sdp->sd_glock_disposal);
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
 
 out:
 	return ret;


