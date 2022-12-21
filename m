Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC016538AF
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 23:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbiLUWdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 17:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiLUWck (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 17:32:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7132DE2;
        Wed, 21 Dec 2022 14:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C95EB81B05;
        Wed, 21 Dec 2022 22:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8B4C433D2;
        Wed, 21 Dec 2022 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661955;
        bh=o4IqpQNFoUcl/W0xGIxhzJjxDtYQA/JCv2l+lu7j8hE=;
        h=Date:To:From:Subject:From;
        b=zNu+AcWlFAgWB6O1us5DLcKgzWJiLrcwiX2mYw0aYDzWoRwAvY8BiayTOtr38b18r
         S7rXnsrc4l6sPvy0oI53GCfyzHXgBUxfO4yC9HbNaa8if2CVye16h4oYThCXktYR3x
         T1wNNhYJiC8DxYIqTL6eBi+8vS035XM2cA5QBCOc=
Date:   Wed, 21 Dec 2022 14:32:34 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, rppt@kernel.org, Liam.Howlett@oracle.com,
        avagin@gmail.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] test_maple_tree-add-test-for-mas_spanning_rebalance-on-insufficient-data.patch removed from -mm tree
Message-Id: <20221221223235.0F8B4C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: test_maple_tree: add test for mas_spanning_rebalance() on insufficient data
has been removed from the -mm tree.  Its filename was
     test_maple_tree-add-test-for-mas_spanning_rebalance-on-insufficient-data.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: test_maple_tree: add test for mas_spanning_rebalance() on insufficient data
Date: Mon, 19 Dec 2022 16:20:15 +0000

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
---

 lib/test_maple_tree.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-add-test-for-mas_spanning_rebalance-on-insufficient-data
+++ a/lib/test_maple_tree.c
@@ -2498,6 +2498,25 @@ static noinline void check_dup(struct ma
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
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


