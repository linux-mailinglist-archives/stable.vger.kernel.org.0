Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983C7548D2A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiFMKZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244680AbiFMKYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:24:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66553201B0;
        Mon, 13 Jun 2022 03:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72A50CE1167;
        Mon, 13 Jun 2022 10:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFF5C3411C;
        Mon, 13 Jun 2022 10:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115497;
        bh=evjWngNGeNm6DvB7V1mSzF/NAi9a3OjoFJYLZg6iysE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1sHtrUs/g8EDSEnPAbIf0m+3YJEPOLOZ5AqUAv+eQRFOA3NRkQLlIcUNQbjZVHbB
         DiS8D/Xh28KpfPK6euWQGIexl9nF+Syd3g/AusF63xGWbm7oD98Cmy7D4N0XoeghbU
         2ap7pzXOeSMwrGQe8gQ3zSOeKDOpGdjWf8UTGCC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe de Dinechin <christophe@dinechin.org>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4.9 097/167] nodemask.h: fix compilation error with GCC12
Date:   Mon, 13 Jun 2022 12:09:31 +0200
Message-Id: <20220613094903.631747075@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe de Dinechin <dinechin@redhat.com>

commit 37462a920392cb86541650a6f4121155f11f1199 upstream.

With gcc version 12.0.1 20220401 (Red Hat 12.0.1-0), building with
defconfig results in the following compilation error:

|   CC      mm/swapfile.o
| mm/swapfile.c: In function `setup_swap_info':
| mm/swapfile.c:2291:47: error: array subscript -1 is below array bounds
|  of `struct plist_node[]' [-Werror=array-bounds]
|  2291 |                                 p->avail_lists[i].prio = 1;
|       |                                 ~~~~~~~~~~~~~~^~~
| In file included from mm/swapfile.c:16:
| ./include/linux/swap.h:292:27: note: while referencing `avail_lists'
|   292 |         struct plist_node avail_lists[]; /*
|       |                           ^~~~~~~~~~~

This is due to the compiler detecting that the mask in
node_states[__state] could theoretically be zero, which would lead to
first_node() returning -1 through find_first_bit.

I believe that the warning/error is legitimate.  I first tried adding a
test to check that the node mask is not emtpy, since a similar test exists
in the case where MAX_NUMNODES == 1.

However, adding the if statement causes other warnings to appear in
for_each_cpu_node_but, because it introduces a dangling else ambiguity.
And unfortunately, GCC is not smart enough to detect that the added test
makes the case where (node) == -1 impossible, so it still complains with
the same message.

This is why I settled on replacing that with a harmless, but relatively
useless (node) >= 0 test.  Based on the warning for the dangling else, I
also decided to fix the case where MAX_NUMNODES == 1 by moving the
condition inside the for loop.  It will still only be tested once.  This
ensures that the meaning of an else following for_each_node_mask or
derivatives would not silently have a different meaning depending on the
configuration.

Link: https://lkml.kernel.org/r/20220414150855.2407137-3-dinechin@redhat.com
Signed-off-by: Christophe de Dinechin <christophe@dinechin.org>
Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Segall <bsegall@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nodemask.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -365,14 +365,13 @@ static inline void __nodes_fold(nodemask
 }
 
 #if MAX_NUMNODES > 1
-#define for_each_node_mask(node, mask)			\
-	for ((node) = first_node(mask);			\
-		(node) < MAX_NUMNODES;			\
-		(node) = next_node((node), (mask)))
+#define for_each_node_mask(node, mask)				    \
+	for ((node) = first_node(mask);				    \
+	     (node >= 0) && (node) < MAX_NUMNODES;		    \
+	     (node) = next_node((node), (mask)))
 #else /* MAX_NUMNODES == 1 */
-#define for_each_node_mask(node, mask)			\
-	if (!nodes_empty(mask))				\
-		for ((node) = 0; (node) < 1; (node)++)
+#define for_each_node_mask(node, mask)                                  \
+	for ((node) = 0; (node) < 1 && !nodes_empty(mask); (node)++)
 #endif /* MAX_NUMNODES */
 
 /*


