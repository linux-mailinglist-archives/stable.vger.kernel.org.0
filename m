Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C2A540E1F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347192AbiFGSwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354619AbiFGSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FC83617F;
        Tue,  7 Jun 2022 11:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FC90B82354;
        Tue,  7 Jun 2022 18:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F072C3411C;
        Tue,  7 Jun 2022 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624953;
        bh=4LcXyfuHc79a6hvseTmi9YjVx5I21yjNoqRvw/FGBL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj1x32tNVD8yrtMaMiMKUHVSIT/a9v3nszWtyduVcRLndYbsnR0Yhqn1hCTRPZAeO
         EMFPRIOqEeViq6rCuAiuVHdx56PMSPjh1qL3nAbcEWfxABAbvEHbhykC4Tkjdxypw0
         K1UHFJLWLBxn+iXFmbJ8wAlJ5vX5Ynq3bvl5K4/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 512/667] NFS: Always initialise fattr->label in nfs_fattr_alloc()
Date:   Tue,  7 Jun 2022 19:02:57 +0200
Message-Id: <20220607164950.059295195@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit d4a95a7e5a4d3b68b26f70668cf77324a11b5718 ]

We're about to add a check in nfs_free_fattr() for whether or not the
label is non-zero.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f4f75db7a825..4ed75673adf6 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1581,8 +1581,10 @@ struct nfs_fattr *nfs_alloc_fattr(void)
 	struct nfs_fattr *fattr;
 
 	fattr = kmalloc(sizeof(*fattr), GFP_NOFS);
-	if (fattr != NULL)
+	if (fattr != NULL) {
 		nfs_fattr_init(fattr);
+		fattr->label = NULL;
+	}
 	return fattr;
 }
 EXPORT_SYMBOL_GPL(nfs_alloc_fattr);
-- 
2.35.1



