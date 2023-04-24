Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5706ECE91
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjDXNdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjDXNdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8474983E0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54D9061F13
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FDDC433EF;
        Mon, 24 Apr 2023 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343161;
        bh=0wJfMAum1yvWKuJd+v0oOt0cR8Z5A4nKexd+TetMkBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjGt6nxXGdbIdjc0LEiYus24T5riZsBBrbeqQDguVtxQti3xdw/c2PLEVpnRNO66f
         /Zlrz//I5/mZE6PWaetmX5a8qSXVp+eUTLgl+1v2p7wKIc8cxsj+HnQTbt6IkTRSfN
         Xb7Wc+voSFph+9RhwNBQ0HZqUjl8ieSpZP4Q58Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Zhang <zhangpeng.00@bytedance.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 070/110] maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
Date:   Mon, 24 Apr 2023 15:17:32 +0200
Message-Id: <20230424131139.010840370@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit 1f5f12ece722aacea1769fb644f27790ede339dc upstream.

In mas_alloc_nodes(), "node->node_count = 0" means to initialize the
node_count field of the new node, but the node may not be a new node.  It
may be a node that existed before and node_count has a value, setting it
to 0 will cause a memory leak.  At this time, mas->alloc->total will be
greater than the actual number of nodes in the linked list, which may
cause many other errors.  For example, out-of-bounds access in
mas_pop_node(), and mas_pop_node() may return addresses that should not be
used.  Fix it by initializing node_count only for new nodes.

Also, by the way, an if-else statement was removed to simplify the code.

Link: https://lkml.kernel.org/r/20230411041005.26205-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1298,26 +1298,21 @@ static inline void mas_alloc_nodes(struc
 	node = mas->alloc;
 	node->request_count = 0;
 	while (requested) {
-		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->node_count) {
-			unsigned int offset = node->node_count;
-
-			slots = (void **)&node->slot[offset];
-			max_req -= offset;
-		} else {
-			slots = (void **)&node->slot;
-		}
-
+		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
+		slots = (void **)&node->slot[node->node_count];
 		max_req = min(requested, max_req);
 		count = mt_alloc_bulk(gfp, max_req, slots);
 		if (!count)
 			goto nomem_bulk;
 
+		if (node->node_count == 0) {
+			node->slot[0]->node_count = 0;
+			node->slot[0]->request_count = 0;
+		}
+
 		node->node_count += count;
 		allocated += count;
 		node = node->slot[0];
-		node->node_count = 0;
-		node->request_count = 0;
 		requested -= count;
 	}
 	mas->alloc->total = allocated;


