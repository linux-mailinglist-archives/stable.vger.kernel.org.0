Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32896CC38C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjC1OzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbjC1Oy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:54:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABF5D510
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C4D6182C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7684CC433D2;
        Tue, 28 Mar 2023 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015295;
        bh=tx3Tgu7vQHll2Pkn5DHn5d+ikcMhPZGybTvWXh+Rtao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AnXbh0JDySAo14oiW0S2dJynJg8YYpO/tmVAwYcNMQhLPw+dTpUYF7TxpqqVpLD1
         2W0yXTNaECbwKR0z+32FNuGoTBsQaDV1bjN+t0i5URc++taiGS3Gy5/LEmU77I1aw1
         6HMNrjkdZI4K81A1iijxFU7NTFi/cEVntGRcLRZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Snild Dolkow <snild@sony.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 207/240] test_maple_tree: add more testing for mas_empty_area()
Date:   Tue, 28 Mar 2023 16:42:50 +0200
Message-Id: <20230328142628.306829114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 4bd6dded6318dc8e2514d74868c1f8fb38b61a60 upstream.

Test robust filling of an entire area of the tree, then test one beyond.
This is to test the walking back up the tree at the end of nodes and error
condition.  Test inspired by the reproducer code provided by Snild Dolkow.

The last test in the function tests for the case of a corrupted maple
state caused by the incorrect limits set during mas_skip_node().  There
needs to be a gap in the second last child and last child, but the search
must rule out the second last child's gap.  This would avoid correcting
the maple state to the correct max limit and return an error.

Link: https://lkml.kernel.org/r/20230307180247.2220303-3-Liam.Howlett@oracle.com
Cc: Snild Dolkow <snild@sony.com>
Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Fixes: e15e06a83923 ("lib/test_maple_tree: add testing for maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_maple_tree.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2602,6 +2602,49 @@ static noinline void check_empty_area_wi
 	rcu_read_unlock();
 }
 
+static noinline void check_empty_area_fill(struct maple_tree *mt)
+{
+	const unsigned long max = 0x25D78000;
+	unsigned long size;
+	int loop, shift;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(99999);
+	for (shift = 12; shift <= 16; shift++) {
+		loop = 5000;
+		size = 1 << shift;
+		while (loop--) {
+			mas_set(&mas, 0);
+			mas_lock(&mas);
+			MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != 0);
+			MT_BUG_ON(mt, mas.last != mas.index + size - 1);
+			mas_store_gfp(&mas, (void *)size, GFP_KERNEL);
+			mas_unlock(&mas);
+			mas_reset(&mas);
+		}
+	}
+
+	/* No space left. */
+	size = 0x1000;
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != -EBUSY);
+	rcu_read_unlock();
+
+	/* Fill a depth 3 node to the maximum */
+	for (unsigned long i = 629440511; i <= 629440800; i += 6)
+		mtree_store_range(mt, i, i + 5, (void *)i, GFP_KERNEL);
+	/* Make space in the second-last depth 4 node */
+	mtree_erase(mt, 631668735);
+	/* Make space in the last depth 4 node */
+	mtree_erase(mt, 629506047);
+	mas_reset(&mas);
+	/* Search from just after the gap in the second-last depth 4 */
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 629506048, 690000000, 0x5000) != 0);
+	rcu_read_unlock();
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2854,6 +2897,11 @@ static int maple_tree_seed(void)
 	check_empty_area_window(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_fill(&tree);
+	mtree_destroy(&tree);
+
+
 #if defined(BENCH)
 skip:
 #endif


