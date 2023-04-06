Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8386D8C66
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbjDFBGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjDFBGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E121FF9;
        Wed,  5 Apr 2023 18:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D3226429B;
        Thu,  6 Apr 2023 01:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76429C433EF;
        Thu,  6 Apr 2023 01:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743206;
        bh=a33kL3h8SdXvpPsqZpMEd7ke+dq94jN89mPclMtZyuY=;
        h=Date:To:From:Subject:From;
        b=pPhN2riL1E14aXa54n/sOvpJoXQNo0rl9utFUBVpZPabBUO8J3jRsBCKxnc3rZ8/j
         qy2MQoyL3FoR/2Cpr3kK2vU/iNAnMoZQFAdk9DkoCNCGjKFNH+XaVjKxDFZXy8k2Mf
         kWCkwRUR7Y9vcUfwDdMcpFg4FGdtjE3lytLqs5GU=
Date:   Wed, 05 Apr 2023 18:06:45 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-detect-dead-nodes-in-mas_start.patch removed from -mm tree
Message-Id: <20230406010646.76429C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: detect dead nodes in mas_start()
has been removed from the -mm tree.  Its filename was
     maple_tree-detect-dead-nodes-in-mas_start.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: maple_tree: detect dead nodes in mas_start()
Date: Mon, 27 Feb 2023 09:36:01 -0800

When initially starting a search, the root node may already be in the
process of being replaced in RCU mode.  Detect and restart the walk if
this is the case.  This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-3-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/maple_tree.c~maple_tree-detect-dead-nodes-in-mas_start
+++ a/lib/maple_tree.c
@@ -1360,12 +1360,16 @@ static inline struct maple_enode *mas_st
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
 
+retry:
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
 			mas->offset = 0;
+			if (mte_dead_node(mas->node))
+				goto retry;
+
 			return NULL;
 		}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


