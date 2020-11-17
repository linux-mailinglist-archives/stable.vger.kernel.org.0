Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D072B6564
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgKQNYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbgKQNYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:24:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C29BA20781;
        Tue, 17 Nov 2020 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619485;
        bh=AXGl4i0sd3uZ4N/wxzz1HS67eCR7OMtrahG+cUobNRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sc0G6CmQU5DgazJpBszqQdjggFj1df4VgDpWEUWR38KQ4//xPccLOnt6HZfBTW/KR
         TvaC4LOIX5Df2uGqKNwzGLo5zq7NAdY4ErYip2rX8Wx1r4iEkqSyCIAQYG44GikSis
         tU5g7dDeYZW73l0ovz7vrcOAeCuKm/vR7tnIv1PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/151] gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
Date:   Tue, 17 Nov 2020 14:04:45 +0100
Message-Id: <20201117122124.112290775@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit d0f17d3883f1e3f085d38572c2ea8edbd5150172 ]

Function gfs2_clear_rgrpd calls kfree(rgd->rd_bits) before calling
return_all_reservations, but return_all_reservations still dereferences
rgd->rd_bits in __rs_deltree.  Fix that by moving the call to kfree below the
call to return_all_reservations.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2466bb44a23c5..e23735084ad17 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -736,9 +736,9 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_free_clones(rgd);
+		return_all_reservations(rgd);
 		kfree(rgd->rd_bits);
 		rgd->rd_bits = NULL;
-		return_all_reservations(rgd);
 		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
 }
-- 
2.27.0



