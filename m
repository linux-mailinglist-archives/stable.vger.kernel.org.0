Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FCC6DEEDF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjDLIpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjDLIph (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824F17EEB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A24E630E8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D869C433EF;
        Wed, 12 Apr 2023 08:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289114;
        bh=8gfrCR1qp1VpjbBpK+SpbTH9F41a7WxNrjlNCn5vQHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHqlS0I47/yZJCoeVd8XgG2Z/4g3H2v5dsAf0TNzHQCz3O4Ip+lmWkKA2nteUuBVG
         YTou/i56EILdgXMOSVe1FZhfYX1hgevobttJPFRbojtIz0wTTY58sczTNe3yxW2nPs
         7Hj/LmbjaS4s8h/v7zTV0GQlj3SJVtPjFH9DkHxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Zhang <zhangpeng.00@bytedance.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 140/164] maple_tree: fix get wrong data_end in mtree_lookup_walk()
Date:   Wed, 12 Apr 2023 10:34:22 +0200
Message-Id: <20230412082842.560272854@linuxfoundation.org>
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

commit ec07967d7523adb3670f9dfee0232e3bc868f3de upstream.

if (likely(offset > end))
	max = pivots[offset];

The above code should be changed to if (likely(offset < end)), which is
correct.  This affects the correctness of ma_data_end().  Now it seems
that the final result will not be wrong, but it is best to change it.
This patch does not change the code as above, because it simplifies the
code by the way.

Link: https://lkml.kernel.org/r/20230314124203.91572-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230314124203.91572-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3870,18 +3870,13 @@ static inline void *mtree_lookup_walk(st
 		end = ma_data_end(node, type, pivots, max);
 		if (unlikely(ma_dead_node(node)))
 			goto dead_node;
-
-		if (pivots[offset] >= mas->index)
-			goto next;
-
 		do {
-			offset++;
-		} while ((offset < end) && (pivots[offset] < mas->index));
-
-		if (likely(offset > end))
-			max = pivots[offset];
+			if (pivots[offset] >= mas->index) {
+				max = pivots[offset];
+				break;
+			}
+		} while (++offset < end);
 
-next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
 		if (unlikely(ma_dead_node(node)))


