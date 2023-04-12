Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C776DEFE1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjDLIzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjDLIzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:55:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2222E9EEE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798AE6316C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3B3C4339B;
        Wed, 12 Apr 2023 08:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289613;
        bh=cz/UZh8wTSpazZv4MYEVHK1rx+PABnXPGwacjTkpxsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXiBooJ6432dU6G3KR/KhTjTpSFY65lGweec2r3hOi5j6LbaXnl7zIiVpiv+bUGkE
         jDR0f/vsaKVrSlwPkcvruwN7MpJh9uUldYDuSKz1n38M7vHujtkk6kNEpKvxJ74HRc
         MGK5ixdcENhWaIJpTpJdy0D8pQe/1/TfMcbDFqrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stable@vger.kernel.org,
        Vernon Yang <vernon2gm@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 167/173] maple_tree: refine ma_state init from mas_start()
Date:   Wed, 12 Apr 2023 10:34:53 +0200
Message-Id: <20230412082844.914085876@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 46b345848261009477552d654cb2f65000c30e4d upstream.

If mas->node is an MAS_START, there are three cases, and they all assign
different values to mas->node and mas->offset.  So there is no need to set
them to a default value before updating.

Update them directly to make them easier to understand and for better
readability.

Link: https://lkml.kernel.org/r/20221221060058.609003-7-vernon2gm@gmail.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1339,7 +1339,7 @@ static void mas_node_count(struct ma_sta
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
  *
- * If mas->node == MAS_START, then set the min, max, depth, and offset to
+ * If mas->node == MAS_START, then set the min, max and depth to
  * defaults.
  *
  * Return:
@@ -1353,22 +1353,22 @@ static inline struct maple_enode *mas_st
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
-		mas->node = MAS_NONE;
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
-		mas->offset = 0;
 
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
+			mas->offset = 0;
 			return NULL;
 		}
 
 		/* empty tree */
 		if (unlikely(!root)) {
+			mas->node = MAS_NONE;
 			mas->offset = MAPLE_NODE_SLOTS;
 			return NULL;
 		}


