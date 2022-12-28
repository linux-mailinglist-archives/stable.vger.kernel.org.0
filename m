Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015AB65822F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbiL1Qdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiL1QdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEBC19022
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FE09B81888
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B869C433D2;
        Wed, 28 Dec 2022 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245053;
        bh=N7E2SRwYkQ21JYEy9MXkODJLsG2TrZGxGZHcYLdxbTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHdF9HDDAZa2KactUxzpWkAHc4RC7WpOAjHtTOiMzGCaseBWsgnFJZSbKeWbAotTM
         RTl+HHkCcjVCyfMoEgb9myolFuR/TIdCYaKjoI0pCxyVQL0H/BlxUbyz4R2DFCUrMf
         US1SVjTsRjO5Lo7I0iLi0Gqyt/5bP27ZBYSH0leQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0784/1146] gfs2: Partially revert gfs2_inode_lookup change
Date:   Wed, 28 Dec 2022 15:38:43 +0100
Message-Id: <20221228144351.442248574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 88f4a9f813c549f6b8a6fbf12030949b48a4d5a4 ]

Commit c412a97cf6c5 changed delete_work_func() to always perform an
inode lookup when gfs2_try_evict() fails.  This doesn't make sense as a
gfs2_try_evict() failure indicates that the inode is likely still in
use.  Revert that change.

Fixes: c412a97cf6c5 ("gfs2: Use TRY lock in gfs2_inode_lookup for UNLINKED inodes")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index df335c258eb0..235a0948f6cc 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1039,6 +1039,7 @@ static void delete_work_func(struct work_struct *work)
 			if (gfs2_queue_delete_work(gl, 5 * HZ))
 				return;
 		}
+		goto out;
 	}
 
 	inode = gfs2_lookup_by_inum(sdp, no_addr, gl->gl_no_formal_ino,
@@ -1051,6 +1052,7 @@ static void delete_work_func(struct work_struct *work)
 		d_prune_aliases(inode);
 		iput(inode);
 	}
+out:
 	gfs2_glock_put(gl);
 }
 
-- 
2.35.1



