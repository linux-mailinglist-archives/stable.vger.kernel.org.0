Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB456DEEF5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDLIqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjDLIqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E27729B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC54630E9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C04C433D2;
        Wed, 12 Apr 2023 08:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289171;
        bh=x3RKzflTQ3kBjUjp8AUnyg6r6p55qmEVROUsfh1YLpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jc8E3Gec9LbGdKUhH3W19fv/sGqemAZcq75oOFm1H3zOzNOfXjgpqvSOa84HNP2kT
         Klfh35or96P9zK8nNBSsQhuYdRXNfcxi//w5XKE3jDSec+5cN5hw6lERbz7Q3vEYLA
         6PlAH1je0FJf35Mg4ziz6xEVCVYrhnlKDyjxAmig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 162/164] maple_tree: add smp_rmb() to dead node detection
Date:   Wed, 12 Apr 2023 10:34:44 +0200
Message-Id: <20230412082843.507888500@linuxfoundation.org>
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

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 0a2b18d948838e16912b3b627b504ab062b7d02a upstream.

Add an smp_rmb() before reading the parent pointer to ensure that anything
read from the node prior to the parent pointer hasn't been reordered ahead
of this check.

The is necessary for RCU mode.

Link: https://lkml.kernel.org/r/20230227173632.3292573-7-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -529,9 +529,11 @@ static inline struct maple_node *mte_par
  */
 static inline bool ma_dead_node(const struct maple_node *node)
 {
-	struct maple_node *parent = (void *)((unsigned long)
-					     node->parent & ~MAPLE_NODE_MASK);
+	struct maple_node *parent;
 
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
+	parent = (void *)((unsigned long) node->parent & ~MAPLE_NODE_MASK);
 	return (parent == node);
 }
 
@@ -546,6 +548,8 @@ static inline bool mte_dead_node(const s
 	struct maple_node *parent, *node;
 
 	node = mte_to_node(enode);
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
 	parent = mte_parent(enode);
 	return (parent == node);
 }


