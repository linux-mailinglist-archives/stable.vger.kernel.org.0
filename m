Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65E106B10
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfKVKlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728551AbfKVKlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:41:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 045F22071F;
        Fri, 22 Nov 2019 10:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419259;
        bh=cz9yANBsZW2qAh4Evu4ZWcIfTP6aODRHbacB8e9E0Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A55ASMvHa35gPowENgN3BMwY+QAuebAv//FPP6bvjQJfTGLFd/rfGPiINdHTNMRSd
         jpGwoVZC1FoOpe46lohdbE1y5C32SesmIHex2WxUmSDErt81c5J0vG4bxLoiBDEpTj
         eXnrej2jpyPeNc0b5H8pjxaDS9DRTsXnZK4r4vh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 024/222] gfs2: Dont set GFS2_RDF_UPTODATE when the lvb is updated
Date:   Fri, 22 Nov 2019 11:26:04 +0100
Message-Id: <20191122100838.381317027@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 4f36cb36c9d14340bb200d2ad9117b03ce992cfe ]

The GFS2_RDF_UPTODATE flag in the rgrp is used to determine when
a rgrp buffer is valid. It's cleared when the glock is invalidated,
signifying that the buffer data is now invalid. But before this
patch, function update_rgrp_lvb was setting the flag when it
determined it had a valid lvb. But that's an invalid assumption:
just because you have a valid lvb doesn't mean you have valid
buffers. After all, another node may have made the lvb valid,
and this node just fetched it from the glock via dlm.

Consider this scenario:
1. The file system is mounted with RGRPLVB option.
2. In gfs2_inplace_reserve it locks the rgrp glock EX, but thanks
   to GL_SKIP, it skips the gfs2_rgrp_bh_get.
3. Since loops == 0 and the allocation target (ap->target) is
   bigger than the largest known chunk of blocks in the rgrp
   (rs->rs_rbm.rgd->rd_extfail_pt) it skips that rgrp and bypasses
   the call to gfs2_rgrp_bh_get there as well.
4. update_rgrp_lvb sees the lvb MAGIC number is valid, so bypasses
   gfs2_rgrp_bh_get, but it still sets sets GFS2_RDF_UPTODATE due
   to this invalid assumption.
5. The next time update_rgrp_lvb is called, it sees the bit is set
   and just returns 0, assuming both the lvb and rgrp are both
   uptodate. But since this is a smaller allocation, or space has
   been freed by another node, thus adjusting the lvb values,
   it decides to use the rgrp for allocations, with invalid rd_free
   due to the fact it was never updated.

This patch changes update_rgrp_lvb so it doesn't set the UPTODATE
flag anymore. That way, it has no choice but to fetch the latest
values.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 0731267072706..f77a38755aea6 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1211,7 +1211,7 @@ static int update_rgrp_lvb(struct gfs2_rgrpd *rgd)
 	rl_flags = be32_to_cpu(rgd->rd_rgl->rl_flags);
 	rl_flags &= ~GFS2_RDF_MASK;
 	rgd->rd_flags &= GFS2_RDF_MASK;
-	rgd->rd_flags |= (rl_flags | GFS2_RDF_UPTODATE | GFS2_RDF_CHECK);
+	rgd->rd_flags |= (rl_flags | GFS2_RDF_CHECK);
 	if (rgd->rd_rgl->rl_unlinked == 0)
 		rgd->rd_flags &= ~GFS2_RDF_CHECK;
 	rgd->rd_free = be32_to_cpu(rgd->rd_rgl->rl_free);
-- 
2.20.1



