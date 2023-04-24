Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8E6ECDC3
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjDXN0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjDXN0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:26:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9435FF6
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 268EC62207
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0CAC433EF;
        Mon, 24 Apr 2023 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342790;
        bh=ONCt3OR/vxf6iAPQ0lpcmGNw8LVVdg8UNCKm8wxvi/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwXL5er8Nl9Wfia/G7cOcTidd/gmjhBpi0/W/rzMbu/xLUaU/JyDzpgZtRtXJ9tvw
         sUhZsuE8M+yeWh6AAfRFEPRchehJHlAms42NuRmi4RXvwiKFnyy5eEBTQy7WySuaQ3
         8t/wqLGQ3aCcfn01SYZecakAT8zQfjlyRC0xKAXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 59/98] maple_tree: fix mas_empty_area() search
Date:   Mon, 24 Apr 2023 15:17:22 +0200
Message-Id: <20230424131136.155716603@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
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
@@ -5059,10 +5059,10 @@ static inline bool mas_anode_descend(str
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
@@ -5070,13 +5070,15 @@ static inline bool mas_anode_descend(str
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


