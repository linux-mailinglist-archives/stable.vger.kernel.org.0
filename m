Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73F541D4C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379021AbiFGWLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383971AbiFGWJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:09:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFDD258DE9;
        Tue,  7 Jun 2022 12:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C96B8237B;
        Tue,  7 Jun 2022 19:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7547C385A2;
        Tue,  7 Jun 2022 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629524;
        bh=w4J3lZlhPnZx1YGLY7PoiF1tfVbazPE3XFhfXp2RXdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMXB0oeVNNEInxqiEXUi3CKhXuPGOm10CD09fub8fA4V0uTXiBZ598cnTEw098gU+
         fqgA7JLRvdn6MzOoAzXYafcu3DPqLL0xJdUSYWvffJrgVxSL1kE206+mmg2JEzCWNR
         B7G/6m4c//reVnj+EwM0gKKbc7GAz5kW+7nREL+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 681/879] NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout
Date:   Tue,  7 Jun 2022 19:03:19 +0200
Message-Id: <20220607165022.614133384@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 856c962273c7..68a87be3e6f9 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2000,6 +2000,7 @@ pnfs_update_layout(struct inode *ino,
 	lo = pnfs_find_alloc_layout(ino, ctx, gfp_flags);
 	if (lo == NULL) {
 		spin_unlock(&ino->i_lock);
+		lseg = ERR_PTR(-ENOMEM);
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				 PNFS_UPDATE_LAYOUT_NOMEM);
 		goto out;
@@ -2128,6 +2129,7 @@ pnfs_update_layout(struct inode *ino,
 
 	lgp = pnfs_alloc_init_layoutget_args(ino, ctx, &stateid, &arg, gfp_flags);
 	if (!lgp) {
+		lseg = ERR_PTR(-ENOMEM);
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, NULL,
 					 PNFS_UPDATE_LAYOUT_NOMEM);
 		nfs_layoutget_end(lo);
-- 
2.35.1



