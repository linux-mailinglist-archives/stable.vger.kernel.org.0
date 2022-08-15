Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90E594243
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349488AbiHOVsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349486AbiHOVoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:44:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3B110228B;
        Mon, 15 Aug 2022 12:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 486B8B81062;
        Mon, 15 Aug 2022 19:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0C6C433C1;
        Mon, 15 Aug 2022 19:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591787;
        bh=tSG5BZiS7wjhmXMXzV5/Gy6ukN5wWDyGwnZ1mUmPQps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TF5nKCizpYV1zk7jbvSLc46wrisoQGxdCeHMlHHLl+5j4nklmKNinWyMGqJ+GzdcM
         nUO5P9k6JDM1fnw8vT3mbfADwrjbTVaqnDq4o229B0MI/clSAwd+Os34Nbf3XqKBoC
         BTI053I2sPvA+s8yL5Jm5gMxQwW0rltnvCH4krtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0681/1095] RDMA/rxe: fix xa_alloc_cycle() error return value check again
Date:   Mon, 15 Aug 2022 20:01:20 +0200
Message-Id: <20220815180457.546859444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 1a685940e6200e9def6e34bbaa19dd31dc5aeaf8 ]

Currently rxe_alloc checks ret to indicate error, but 1 is also a valid
return and just indicates that the allocation succeeded with a wrap.

Fix this by modifying the check to be < 0.

Link: https://lore.kernel.org/r/20220609070656.1446121-1-dzm91@hust.edu.cn
Fixes: 3225717f6dfa ("RDMA/rxe: Replace red-black trees by xarrays")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 87066d04ed18..69db28944567 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -140,7 +140,7 @@ void *rxe_alloc(struct rxe_pool *pool)
 
 	err = xa_alloc_cyclic(&pool->xa, &elem->index, elem, pool->limit,
 			      &pool->next, GFP_KERNEL);
-	if (err)
+	if (err < 0)
 		goto err_free;
 
 	return obj;
@@ -168,7 +168,7 @@ int __rxe_add_to_pool(struct rxe_pool *pool, struct rxe_pool_elem *elem)
 
 	err = xa_alloc_cyclic(&pool->xa, &elem->index, elem, pool->limit,
 			      &pool->next, GFP_KERNEL);
-	if (err)
+	if (err < 0)
 		goto err_cnt;
 
 	return 0;
-- 
2.35.1



