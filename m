Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4913165850D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiL1RFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiL1REz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F0921E04
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:59:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC0F61558
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7428EC433D2;
        Wed, 28 Dec 2022 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246755;
        bh=zpUQ9nAi9tFdUUmnpPGcOyH7K4jnTIhrgBuAki78Sv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjcgF9qUipCV7RaGFJ4fLRwht6k94U/7nfhWDdHcLhl5LD6RJ73QC9rj/x/Kia5yw
         Ol6oMbf+Mk7V6GimhuYjqFBBCAwPzBdyyMXcxgCZiNzq0LiRq7wzIkK+tO0eXYIlMq
         Bd9PSIA14XSqu9zt/DWKX5xqb2tjbR6dk+FHhv9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrei Vagin <avagin@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 1127/1146] test_maple_tree: add test for mas_spanning_rebalance() on insufficient data
Date:   Wed, 28 Dec 2022 15:44:26 +0100
Message-Id: <20221228144400.756203147@linuxfoundation.org>
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

From: Liam Howlett <liam.howlett@oracle.com>

commit c5651b31f51584bd1199b3a552c8211a8523d6e1 upstream.

Add a test to the maple tree test suite for the spanning rebalance
insufficient node issue does not go undetected again.

Link: https://lkml.kernel.org/r/20221219161922.2708732-3-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_maple_tree.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index f425f169ef08..497fc93ccf9e 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2498,6 +2498,25 @@ static noinline void check_dup(struct maple_tree *mt)
 	}
 }
 
+static noinline void check_bnode_min_spanning(struct maple_tree *mt)
+{
+	int i = 50;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(9999);
+	mas_lock(&mas);
+	do {
+		mas_set_range(&mas, i*10, i*10+9);
+		mas_store(&mas, check_bnode_min_spanning);
+	} while (i--);
+
+	mas_set_range(&mas, 240, 509);
+	mas_store(&mas, NULL);
+	mas_unlock(&mas);
+	mas_destroy(&mas);
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2742,6 +2761,10 @@ static int maple_tree_seed(void)
 	check_dup(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_bnode_min_spanning(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
-- 
2.39.0



