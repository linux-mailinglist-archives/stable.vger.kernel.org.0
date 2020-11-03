Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D392A51C2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgKCUnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730746AbgKCUns (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22C8B223C7;
        Tue,  3 Nov 2020 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436228;
        bh=Gxs+a/5rB+S6Anu0e2/DYdzcbVHZv8rkc7/h0fbF9lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXeup5CuEcVi6eLuGG2CLxPhjF/TQMuzBouwprK0/M9aqBHcFuoNb9vVDnFE6pOK3
         jj4+03ahqrYf/MQmnP/DxQhlAo4VzBI2zzxUZnogSEqKoHXESudiJB1wbHn3+2Fw/O
         Yc1XIO+ApDznkH1B4G72/0E+PMShtDEt2IJ76U3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 158/391] gfs2: call truncate_inode_pages_final for address space glocks
Date:   Tue,  3 Nov 2020 21:33:29 +0100
Message-Id: <20201103203357.494654983@linuxfoundation.org>
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

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit ee1e2c773e4f4ce2213f9d77cc703b669ca6fa3f ]

Before this patch, we were not calling truncate_inode_pages_final for the
address space for glocks, which left the possibility of a leak. We now
take care of the problem instead of complaining, and we do it during
glock tear-down..

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f13b136654cae..3554e71be06ec 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -270,7 +270,12 @@ static void __gfs2_glock_put(struct gfs2_glock *gl)
 	gfs2_glock_remove_from_lru(gl);
 	spin_unlock(&gl->gl_lockref.lock);
 	GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
-	GLOCK_BUG_ON(gl, mapping && mapping->nrpages && !gfs2_withdrawn(sdp));
+	if (mapping) {
+		truncate_inode_pages_final(mapping);
+		if (!gfs2_withdrawn(sdp))
+			GLOCK_BUG_ON(gl, mapping->nrpages ||
+				     mapping->nrexceptional);
+	}
 	trace_gfs2_glock_put(gl);
 	sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
 }
-- 
2.27.0



