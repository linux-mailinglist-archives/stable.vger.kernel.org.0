Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F74F70A0
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238629AbiDGBV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240410AbiDGBT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E238C186897;
        Wed,  6 Apr 2022 18:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CB3561DA8;
        Thu,  7 Apr 2022 01:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF72C385A3;
        Thu,  7 Apr 2022 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294171;
        bh=k9BfgpKvVIA3UgPe+MlMeqso+kPxph2ukirEGUX0OWw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ltt68RcTRKnTsrw1USvb8qvTxtIskVAx5HyVTsMRF1t6UrcFClO6iwRP1zOegR4VP
         WfAuaCOT6HxYiTik5Jtn1GLTwCB8ncX1mw/Vrv5ZzKR7zvef00jGPmcLHTA3XQfqwo
         KZxIBwFdbHrfnuKt9/555cvIt6s+hwhj7x3zjNWmVXjrZM0q1lLoNko6GYCw6ckjYv
         Nf7MifW6AL21LTbL1MIYFV26vJWawIFmjPuWwy4ZAejXb6e/+48RRrz8Mc67gcosUB
         9cDQwsQnm039Plb+dQ3IYW0TMuh1cNNtN2zXjySOqPT95IS0rplI++UWWrWAWciIf6
         c+wZ8yrzFuqmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        syzbot+c6fd14145e2f62ca0784@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 01/11] gfs2: assign rgrp glock before compute_bitstructs
Date:   Wed,  6 Apr 2022 21:15:58 -0400
Message-Id: <20220407011609.115258-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 428f651cb80b227af47fc302e4931791f2fb4741 ]

Before this patch, function read_rindex_entry called compute_bitstructs
before it allocated a glock for the rgrp. But if compute_bitstructs found
a problem with the rgrp, it called gfs2_consist_rgrpd, and that called
gfs2_dump_glock for rgd->rd_gl which had not yet been assigned.

read_rindex_entry
   compute_bitstructs
      gfs2_consist_rgrpd
         gfs2_dump_glock <---------rgd->rd_gl was not set.

This patch changes read_rindex_entry so it assigns an rgrp glock before
calling compute_bitstructs so gfs2_dump_glock does not reference an
unassigned pointer. If an error is discovered, the glock must also be
put, so a new goto and label were added.

Reported-by: syzbot+c6fd14145e2f62ca0784@syzkaller.appspotmail.com
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 054fdfd4fb8b..76b11b33592d 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -926,15 +926,15 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	rgd->rd_bitbytes = be32_to_cpu(buf.ri_bitbytes);
 	spin_lock_init(&rgd->rd_rsspin);
 
-	error = compute_bitstructs(rgd);
-	if (error)
-		goto fail;
-
 	error = gfs2_glock_get(sdp, rgd->rd_addr,
 			       &gfs2_rgrp_glops, CREATE, &rgd->rd_gl);
 	if (error)
 		goto fail;
 
+	error = compute_bitstructs(rgd);
+	if (error)
+		goto fail_glock;
+
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~(GFS2_RDF_UPTODATE | GFS2_RDF_PREFERRED);
 	if (rgd->rd_data > sdp->sd_max_rg_data)
@@ -951,6 +951,7 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	}
 
 	error = 0; /* someone else read in the rgrp; free it and ignore it */
+fail_glock:
 	gfs2_glock_put(rgd->rd_gl);
 
 fail:
-- 
2.35.1

