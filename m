Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781434FB59F
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiDKILX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 04:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiDKILU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:11:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0556C3;
        Mon, 11 Apr 2022 01:09:06 -0700 (PDT)
Date:   Mon, 11 Apr 2022 08:09:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649664544;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Q/cLzqt8hbPDP/r8Xme0RmnOVKky9waF1u0fTBQPW8=;
        b=x52nZXb3Ti/QiUJVh16HQD0PYbZ/YoqbEg5M1SfYYvtWMra+3PNmAasov5wi3oO0OtA6dk
        026m9NxidHxiJpojzboh3cKUHihq2daZxFBQYJyYQc+pyGQNFjlW6XNPQQSlOX1vMA1zpW
        xTKYCEE3uAVhysK/7gwEr0WI4V+yqekKCUbvy7Qr1s4rNZ5jHeAo5qSgFTnNx0odO94eBa
        QhcS0m/kh0iy1PTQ2G4IDl1RIx3Tay+AOIFL+mOndDhiGyjjMf3bwdz70kS2LnKEuYB8yz
        SnsFHw0cQmkRSkH2kWJzgkcPjwmAHVINlnpaFnqrdRmw3Yl+oHY9IeaztCNPWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649664544;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Q/cLzqt8hbPDP/r8Xme0RmnOVKky9waF1u0fTBQPW8=;
        b=XCIKjdzpMmMgtZQLO6q2CLTsAEaouqCM43Lizmbcl7cI60y445sXG7BFs0nIqgGFIumOHQ
        f7AUnIMr5KDxtwCg==
From:   "tip-bot2 for Rei Yamamoto" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/affinity: Consider that CPUs on nodes can be
 unbalanced
Cc:     Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20220331003309.10891-1-yamamoto.rei@jp.fujitsu.com>
References: <20220331003309.10891-1-yamamoto.rei@jp.fujitsu.com>
MIME-Version: 1.0
Message-ID: <164966454348.4207.142052541335966473.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     08d835dff916bfe8f45acc7b92c7af6c4081c8a7
Gitweb:        https://git.kernel.org/tip/08d835dff916bfe8f45acc7b92c7af6c4081c8a7
Author:        Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
AuthorDate:    Thu, 31 Mar 2022 09:33:09 +09:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 11 Apr 2022 09:58:03 +02:00

genirq/affinity: Consider that CPUs on nodes can be unbalanced

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
---
 kernel/irq/affinity.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index f7ff891..fdf1704 100644
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
