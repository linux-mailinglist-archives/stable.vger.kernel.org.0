Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22867540705
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbiFGRln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348412AbiFGRkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626FC11CB49;
        Tue,  7 Jun 2022 10:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB65C6157D;
        Tue,  7 Jun 2022 17:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD48FC385A5;
        Tue,  7 Jun 2022 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623222;
        bh=r+PiPBr4xTAxxMb9zWAk9Kk81bO+/sVjicksRNPqiGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlHkrWQlUdxp1ge34B9ZjzrhN7cA9rjuvZq4FoC6evka4ELCoM3+a8jVfByZHwiVQ
         UKkIzSvzGAogpobzWoMn2cnsLi1ZjDpb2EvS2oR6dm5stwkvM9q6kvbG70KtQpsU/3
         apCZujA2ZMX54oTQ7ulL7431yJpP13cVQDyQ1fkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/452] NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout
Date:   Tue,  7 Jun 2022 19:03:09 +0200
Message-Id: <20220607164918.452934740@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 3764a17e31d579cf9b4bd0a69894b577e8d75702 ]

Commit 587f03deb69b caused pnfs_update_layout() to stop returning ENOMEM
when the memory allocation fails, and hence causes it to fall back to
trying to do I/O through the MDS. There is no guarantee that this will
fare any better. If we're failing the pNFS layout allocation, then we
should just redirty the page and retry later.

Reported-by: Olga Kornievskaia <aglo@umich.edu>
Fixes: 587f03deb69b ("pnfs: refactor send_layoutget")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index b3b9eff5d572..8c0803d98008 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2006,6 +2006,7 @@ pnfs_update_layout(struct inode *ino,
 	lo = pnfs_find_alloc_layout(ino, ctx, gfp_flags);
 	if (lo == NULL) {
 		spin_unlock(&ino->i_lock);
+		lseg = ERR_PTR(-ENOMEM);
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				 PNFS_UPDATE_LAYOUT_NOMEM);
 		goto out;
@@ -2134,6 +2135,7 @@ pnfs_update_layout(struct inode *ino,
 
 	lgp = pnfs_alloc_init_layoutget_args(ino, ctx, &stateid, &arg, gfp_flags);
 	if (!lgp) {
+		lseg = ERR_PTR(-ENOMEM);
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, NULL,
 					 PNFS_UPDATE_LAYOUT_NOMEM);
 		nfs_layoutget_end(lo);
-- 
2.35.1



