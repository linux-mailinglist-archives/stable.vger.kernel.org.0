Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4432D4F27F2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiDEIJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiDEH5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB92B522FA;
        Tue,  5 Apr 2022 00:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16D91B81B9C;
        Tue,  5 Apr 2022 07:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586E7C340EE;
        Tue,  5 Apr 2022 07:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145085;
        bh=dO3M0HpD6K1VgvkxLUeUlcOZFqCcXETf1sgvAHlNr/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXnv2K+rKzfM33/NofFptZ9Ta2N+aUyT2opZ88aonR5DBsX0bLDfAqfeu6mRBmJXm
         iOgAsTTceysEkZs2xbIJOpgrLYDdTi7jA5+/trioolRw0ygVO7TL/q8errCf1HzXiz
         ixCbtUWCsYaMzzTPKBPNZvGIrS2ZitZbpdDR1N+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0279/1126] nfsd: more robust allocation failure handling in nfsd_file_cache_init
Date:   Tue,  5 Apr 2022 09:17:06 +0200
Message-Id: <20220405070415.799417870@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 4d2eeafecd6c83b4444db3dc0ada201c89b1aa44 ]

The nfsd file cache table can be pretty large and its allocation
may require as many as 80 contigious pages.

Employ the same fix that was employed for similar issue that was
reported for the reply cache hash table allocation several years ago
by commit 8f97514b423a ("nfsd: more robust allocation failure handling
in nfsd_reply_cache_init").

Fixes: 65294c1f2c5e ("nfsd: add a new struct file caching facility to nfsd")
Link: https://lore.kernel.org/linux-nfs/e3cdaeec85a6cfec980e87fc294327c0381c1778.camel@kernel.org/
Suggested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 8bc807c5fea4..cc2831cec669 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -632,7 +632,7 @@ nfsd_file_cache_init(void)
 	if (!nfsd_filecache_wq)
 		goto out;
 
-	nfsd_file_hashtbl = kcalloc(NFSD_FILE_HASH_SIZE,
+	nfsd_file_hashtbl = kvcalloc(NFSD_FILE_HASH_SIZE,
 				sizeof(*nfsd_file_hashtbl), GFP_KERNEL);
 	if (!nfsd_file_hashtbl) {
 		pr_err("nfsd: unable to allocate nfsd_file_hashtbl\n");
@@ -700,7 +700,7 @@ nfsd_file_cache_init(void)
 	nfsd_file_slab = NULL;
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kfree(nfsd_file_hashtbl);
+	kvfree(nfsd_file_hashtbl);
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
@@ -811,7 +811,7 @@ nfsd_file_cache_shutdown(void)
 	fsnotify_wait_marks_destroyed();
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kfree(nfsd_file_hashtbl);
+	kvfree(nfsd_file_hashtbl);
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
-- 
2.34.1



