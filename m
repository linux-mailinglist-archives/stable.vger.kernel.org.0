Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4F1527A7F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 00:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiEOWGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 18:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiEOWGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 18:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D209A205CD;
        Sun, 15 May 2022 15:06:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3928360FA1;
        Sun, 15 May 2022 22:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FEEC385B8;
        Sun, 15 May 2022 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652652373;
        bh=4gvrqCyCX8v3gxxry1yd/SgUpkcy3FmDeh9EJmvYMyI=;
        h=Date:To:From:Subject:From;
        b=KYkqJPGalPV83RS9W2l6QVzg8lfPP/GVmgX4WoEtBfkZm4RRRgoxGoPKD+K7w+S4N
         yPFz2IgZZt29ro1yNCtCGkm8TZUhJs8KNYlcXF0z7ebspj2pWwZwlmbNMuO+HgGG9D
         7YkgvE7uJuI4KXwaPxm/6XLfxBkzo5Pl1k1x3YJI=
Date:   Sun, 15 May 2022 15:06:12 -0700
To:     mm-commits@vger.kernel.org, vincent.guittot@linaro.org,
        thunder.leizhen@huawei.com, stable@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, pbonzini@redhat.com,
        mst@redhat.com, mingo@redhat.com, mgorman@suse.de,
        juri.lelli@redhat.com, jasowang@redhat.com,
        dietmar.eggemann@arm.com, christophe@dinechin.org,
        bsegall@google.com, bristot@redhat.com, akpm@linux-foundation.org,
        dinechin@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nodemaskh-fix-compilation-error-with-gcc12.patch added to mm-unstable branch
Message-Id: <20220515220613.90FEEC385B8@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nodemask.h: fix compilation error with GCC12
has been added to the -mm mm-unstable branch.  Its filename is
     nodemaskh-fix-compilation-error-with-gcc12.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nodemaskh-fix-compilation-error-with-gcc12.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christophe de Dinechin <dinechin@redhat.com>
Subject: nodemask.h: fix compilation error with GCC12
Date: Thu, 14 Apr 2022 17:08:54 +0200

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
---

 include/linux/nodemask.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/nodemask.h~nodemaskh-fix-compilation-error-with-gcc12
+++ a/include/linux/nodemask.h
@@ -375,14 +375,13 @@ static inline void __nodes_fold(nodemask
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
_

Patches currently in -mm which might be from dinechin@redhat.com are

nodemaskh-fix-compilation-error-with-gcc12.patch

