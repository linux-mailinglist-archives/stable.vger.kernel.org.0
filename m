Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F86B4AFC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbjCJP3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbjCJP2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C401222FA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49EBB61A56
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E788C4339C;
        Fri, 10 Mar 2023 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460059;
        bh=kwn0y1B1ewLe4Hr14QqAaLoYZCjhgovCh2Nx2YT2gMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDZvpj/ZzjdcBGWOdsg3X0yT+FoDtBv6WSLsH1M+vPVRw6teTcHqJqKeC8LBmizOk
         X4nuRpBfIRnT4GZeiqSwZuqWwemSzt+ahRbch8rECymTgo9OWpl27+7+8ySb/ygPdD
         IXIm8VVZ+3uF2UkwTmqo5tC0hXaE423eG90rYg4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/529] NFS: Fix up handling of outstanding layoutcommit in nfs_update_inode()
Date:   Fri, 10 Mar 2023 14:35:52 +0100
Message-Id: <20230310133814.698472093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 709fa5769914b377af87962bbe4ff81ffb019b2d ]

If there is an outstanding layoutcommit, then the list of attributes
whose values are expected to change is not the full set. So let's
be explicit about the full list.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: b46d80bd2d6e ("nfs4trace: fix state manager flag printing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 1adece1cff3ed..36f415278c042 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1906,7 +1906,11 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	nfs_wcc_update_inode(inode, fattr);
 
 	if (pnfs_layoutcommit_outstanding(inode)) {
-		nfsi->cache_validity |= save_cache_validity & NFS_INO_INVALID_ATTR;
+		nfsi->cache_validity |=
+			save_cache_validity &
+			(NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_CTIME |
+			 NFS_INO_INVALID_MTIME | NFS_INO_INVALID_SIZE |
+			 NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
 
-- 
2.39.2



