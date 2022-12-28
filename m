Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0432D657955
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiL1PAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiL1O7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:59:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE899120B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5926A6154E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A26AC433EF;
        Wed, 28 Dec 2022 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239592;
        bh=zPd9wA/Kfd+TTI/wzCKaqIq+arnjdtnw2EMi6MkCHdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CKTVszR0zBBWJEjl5b48zvRUF9Lc5UMxyvoAPqgtsclhQGqt/M/RZuDcpSNVrbZL
         QothmCruF96Wmnh0ZtXAydbmcRSU6G9kO980k404Ns/+11YfEIrILxfSk/c6hdXjJb
         OIioYjq9uxrNFROd1pLGxfqqIyvEjPsWyVEEPHzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/731] NFSv4: Fix a credential leak in _nfs4_discover_trunking()
Date:   Wed, 28 Dec 2022 15:35:54 +0100
Message-Id: <20221228144303.722324146@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e83458fce080dc23c25353a1af90bfecf79c7369 ]

Fixes: 4f40a5b55446 ("NFSv4: Add an fattr allocation to _nfs4_discover_trunking()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index dcc0677d1546..3c9ed63710a9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3987,7 +3987,7 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
-		return -ENOMEM;
+		goto out_put_cred;
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
 	if (!locations)
 		goto out_free;
@@ -4003,6 +4003,8 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 	kfree(locations);
 out_free:
 	__free_page(page);
+out_put_cred:
+	put_cred(cred);
 	return status;
 }
 
-- 
2.35.1



