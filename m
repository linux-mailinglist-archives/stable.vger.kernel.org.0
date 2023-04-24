Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D486ECE82
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjDXNdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjDXNc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BBD7ED1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34DA62360
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BA5C433D2;
        Mon, 24 Apr 2023 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343159;
        bh=wU7l1WxgOKmJcvbkvNXcbIxsbPMqPxBnFaOAgn4Wwoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+1X/YNLC6AgThwemNyJr3FmMbj3icVNpDWMliJqkjjS+GXb/xBgbtnzyteMsO3ge
         t1l028gAyPdQFhCdQ/ulfiAplnRQ5wRewaa1uT+aVg9W7QLzDgdhKbNlCPb46/kNsi
         mFjs7AsAO1E4rRu55Ue/zoME1Ho6eYjjIWaNwX4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 069/110] maple_tree: fix mas_empty_area() search
Date:   Mon, 24 Apr 2023 15:17:31 +0200
Message-Id: <20230424131138.959653030@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 06e8fd999334bcd76b4d72d7b9206d4aea89764e upstream.

The internal function of mas_awalk() was incorrectly skipping the last
entry in a node, which could potentially be NULL.  This is only a problem
for the left-most node in the tree - otherwise that NULL would not exist.

Fix mas_awalk() by using the metadata to obtain the end of the node for
the loop and the logical pivot as apposed to the raw pivot value.

Link: https://lkml.kernel.org/r/20230414145728.4067069-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5064,10 +5064,10 @@ static inline bool mas_anode_descend(str
 {
 	enum maple_type type = mte_node_type(mas->node);
 	unsigned long pivot, min, gap = 0;
-	unsigned char offset;
-	unsigned long *gaps;
-	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
-	void __rcu **slots = ma_slots(mas_mn(mas), type);
+	unsigned char offset, data_end;
+	unsigned long *gaps, *pivots;
+	void __rcu **slots;
+	struct maple_node *node;
 	bool found = false;
 
 	if (ma_is_dense(type)) {
@@ -5075,13 +5075,15 @@ static inline bool mas_anode_descend(str
 		return true;
 	}
 
-	gaps = ma_gaps(mte_to_node(mas->node), type);
+	node = mas_mn(mas);
+	pivots = ma_pivots(node, type);
+	slots = ma_slots(node, type);
+	gaps = ma_gaps(node, type);
 	offset = mas->offset;
 	min = mas_safe_min(mas, pivots, offset);
-	for (; offset < mt_slots[type]; offset++) {
-		pivot = mas_safe_pivot(mas, pivots, offset, type);
-		if (offset && !pivot)
-			break;
+	data_end = ma_data_end(node, type, pivots, mas->max);
+	for (; offset <= data_end; offset++) {
+		pivot = mas_logical_pivot(mas, pivots, offset, type);
 
 		/* Not within lower bounds */
 		if (mas->index > pivot)


