Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3628504E49
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiDRJTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiDRJTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:19:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA2115A02
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFADB80E40
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E56C385A1;
        Mon, 18 Apr 2022 09:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650273380;
        bh=sW95QT6EFkHn8ijOC7sZoHL+FD5oEIwCqxaYVwaKq24=;
        h=Subject:To:Cc:From:Date:From;
        b=yQCGiO8S6KPid7UuMzcAvKmV6NxjDDQm4W/6r5ddyVIUIIiRKw7o4v+Y9Q2PuA9F3
         BOdWKWYR4S6k+7PGBVQojU4W2MteWCzdkNZKOA3JCke+SJa5Y+4Q3/hSTiEsRXRwMa
         Q4qd7kTHUK4zNb4y22/byj9CfliGDAxp2LnvT+5o=
Subject: FAILED: patch "[PATCH] genirq/affinity: Consider that CPUs on nodes can be" failed to apply to 4.19-stable tree
To:     yamamoto.rei@jp.fujitsu.com, ming.lei@redhat.com,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:16:17 +0200
Message-ID: <1650273377171241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 08d835dff916bfe8f45acc7b92c7af6c4081c8a7 Mon Sep 17 00:00:00 2001
From: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Date: Thu, 31 Mar 2022 09:33:09 +0900
Subject: [PATCH] genirq/affinity: Consider that CPUs on nodes can be
 unbalanced

If CPUs on a node are offline at boot time, the number of nodes is
different when building affinity masks for present cpus and when building
affinity masks for possible cpus. This causes the following problem:

In the case that the number of vectors is less than the number of nodes
there are cases where bits of masks for present cpus are overwritten when
building masks for possible cpus.

Fix this by excluding CPUs, which are not part of the current build mask
(present/possible).

[ tglx: Massaged changelog and added comment ]

Fixes: b82592199032 ("genirq/affinity: Spread IRQs to all available NUMA nodes")
Signed-off-by: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220331003309.10891-1-yamamoto.rei@jp.fujitsu.com

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index f7ff8919dc9b..fdf170404650 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -269,8 +269,9 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 	 */
 	if (numvecs <= nodes) {
 		for_each_node_mask(n, nodemsk) {
-			cpumask_or(&masks[curvec].mask, &masks[curvec].mask,
-				   node_to_cpumask[n]);
+			/* Ensure that only CPUs which are in both masks are set */
+			cpumask_and(nmsk, cpu_mask, node_to_cpumask[n]);
+			cpumask_or(&masks[curvec].mask, &masks[curvec].mask, nmsk);
 			if (++curvec == last_affv)
 				curvec = firstvec;
 		}

