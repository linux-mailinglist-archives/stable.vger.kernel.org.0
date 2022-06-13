Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992C0549460
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352835AbiFMLUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353349AbiFMLTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BF43AA51;
        Mon, 13 Jun 2022 03:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 759FB60FDB;
        Mon, 13 Jun 2022 10:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E20C3411C;
        Mon, 13 Jun 2022 10:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116870;
        bh=JBdysYnTCOqo85vNwlQFdf3X2vArao3AMOxh5xGOC+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPsDoHdaEzoYQV/7hhZfGcKybFS1sI5fryhc6tqDCydlR8DEXQyQOcLzmoZlzY7Rj
         TkBgGHkVNbrxqoxQT/38tDrX2FPQ0u67Hpw+URuQFbabBoo2CA39msluAKtNyvdNH/
         gZXGmhR27JjLTnWCkWd1wSdr+f0il1gy9jXvzRX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/411] NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout
Date:   Mon, 13 Jun 2022 12:07:56 +0200
Message-Id: <20220613094934.746280586@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 0471b6e0da16..2fe48982fbb4 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1961,6 +1961,7 @@ pnfs_update_layout(struct inode *ino,
 	lo = pnfs_find_alloc_layout(ino, ctx, gfp_flags);
 	if (lo == NULL) {
 		spin_unlock(&ino->i_lock);
+		lseg = ERR_PTR(-ENOMEM);
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				 PNFS_UPDATE_LAYOUT_NOMEM);
 		goto out;
@@ -2090,6 +2091,7 @@ pnfs_update_layout(struct inode *ino,
 
 	lgp = pnfs_alloc_init_layoutget_args(ino, ctx, &stateid, &arg, gfp_flags);
 	if (!lgp) {
+		lseg = ERR_PTR(-ENOMEM);
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, NULL,
 					 PNFS_UPDATE_LAYOUT_NOMEM);
 		nfs_layoutget_end(lo);
-- 
2.35.1



