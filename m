Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D3A6DEEE0
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjDLIpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjDLIpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BD76EB3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9162630EB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8801C433D2;
        Wed, 12 Apr 2023 08:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289117;
        bh=LMx+8hQcBlHW1IGjmfXYERjJ107BbGJVFMGasEWoeV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwFL+L4yDiGs9DVRIvaz8fzMLHbqdNC+qlAN0oDaY2PXE9Yj16LX41e5zb2GcUX5T
         d8+NCNNTNiN3QkerFA75OyLdCwZp+5ohBDinT0mvV5xzp+poF8T9zMHZOwYzuLrF1D
         0tUHyO5qBPtGtAECIYzM5ElNICdc0v8i3+6o+bRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Zhang <zhangpeng.00@bytedance.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 141/164] maple_tree: fix a potential concurrency bug in RCU mode
Date:   Wed, 12 Apr 2023 10:34:23 +0200
Message-Id: <20230412082842.597469761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit c45ea315a602d45569b08b93e9ab30f6a63a38aa upstream.

There is a concurrency bug that may cause the wrong value to be loaded
when a CPU is modifying the maple tree.

CPU1:
mtree_insert_range()
  mas_insert()
    mas_store_root()
      ...
      mas_root_expand()
        ...
        rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
        ma_set_meta(node, maple_leaf_64, 0, slot);    <---IP

CPU2:
mtree_load()
  mtree_lookup_walk()
    ma_data_end();

When CPU1 is about to execute the instruction pointed to by IP, the
ma_data_end() executed by CPU2 may return the wrong end position, which
will cause the value loaded by mtree_load() to be wrong.

An example of triggering the bug:

Add mdelay(100) between rcu_assign_pointer() and ma_set_meta() in
mas_root_expand().

static DEFINE_MTREE(tree);
int work(void *p) {
	unsigned long val;
	for (int i = 0 ; i< 30; ++i) {
		val = (unsigned long)mtree_load(&tree, 8);
		mdelay(5);
		pr_info("%lu",val);
	}
	return 0;
}

mt_init_flags(&tree, MT_FLAGS_USE_RCU);
mtree_insert(&tree, 0, (void*)12345, GFP_KERNEL);
run_thread(work)
mtree_insert(&tree, 1, (void*)56789, GFP_KERNEL);

In RCU mode, mtree_load() should always return the value before or after
the data structure is modified, and in this example mtree_load(&tree, 8)
may return 56789 which is not expected, it should always return NULL.  Fix
it by put ma_set_meta() before rcu_assign_pointer().

Link: https://lkml.kernel.org/r/20230314124203.91572-4-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3654,10 +3654,9 @@ static inline int mas_root_expand(struct
 		slot++;
 	mas->depth = 1;
 	mas_set_height(mas);
-
+	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	ma_set_meta(node, maple_leaf_64, 0, slot);
 	return slot;
 }
 


