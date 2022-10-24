Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D1360AB54
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiJXNuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiJXNtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:49:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B437B7F5C;
        Mon, 24 Oct 2022 05:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9029161337;
        Mon, 24 Oct 2022 12:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6421C433D7;
        Mon, 24 Oct 2022 12:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615259;
        bh=FbcxVwY/7eJdCs1CnPnHTjWAkBq5YTLaLO4bfjHS09k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pndMdStqkin35F4vM8Nxfv+5ICupSf1yXackU6ou4VA7jKRYatEP8EsxdyBQ/Wc30
         TB0Gu4OziYtNlUTLC64zCt9e5MS0r7aEI2gATkFjel5Wj+kNyGHEw4MeJwntsxDGuU
         riaa+Rf8V8BU79FH8E+eLOoZeDkiGuXtQdAePdaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Antoine Tenart <atenart@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/530] netfilter: conntrack: revisit the gc initial rescheduling bias
Date:   Mon, 24 Oct 2022 13:28:46 +0200
Message-Id: <20221024113053.266428760@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 2aa192757005f130b2dd3547dda6e462e761199f ]

The previous commit changed the way the rescheduling delay is computed
which has a side effect: the bias is now represented as much as the
other entries in the rescheduling delay which makes the logic to kick in
only with very large sets, as the initial interval is very large
(INT_MAX).

Revisit the GC initial bias to allow more frequent GC for smaller sets
while still avoiding wakeups when a machine is mostly idle. We're moving
from a large initial value to pretending we have 100 entries expiring at
the upper bound. This way only a few entries having a small timeout
won't impact much the rescheduling delay and non-idle machines will have
enough entries to lower the delay when needed. This also improves
readability as the initial bias is now linked to what is computed
instead of being an arbitrary large value.

Fixes: 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ee72da164190..9da5ee6c50cd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -86,10 +86,12 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 /* clamp timeouts to this value (TCP unacked) */
 #define GC_SCAN_INTERVAL_CLAMP	(300ul * HZ)
 
-/* large initial bias so that we don't scan often just because we have
- * three entries with a 1s timeout.
+/* Initial bias pretending we have 100 entries at the upper bound so we don't
+ * wakeup often just because we have three entries with a 1s timeout while still
+ * allowing non-idle machines to wakeup more often when needed.
  */
-#define GC_SCAN_INTERVAL_INIT	INT_MAX
+#define GC_SCAN_INITIAL_COUNT	100
+#define GC_SCAN_INTERVAL_INIT	GC_SCAN_INTERVAL_MAX
 
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
@@ -1450,7 +1452,7 @@ static void gc_worker(struct work_struct *work)
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
-		gc_work->count = 1;
+		gc_work->count = GC_SCAN_INITIAL_COUNT;
 		gc_work->start_time = start_time;
 	}
 
-- 
2.35.1



