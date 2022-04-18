Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0E45053C4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbiDRNCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiDRNAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B911B3153A;
        Mon, 18 Apr 2022 05:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2861C60FB6;
        Mon, 18 Apr 2022 12:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E07C385A8;
        Mon, 18 Apr 2022 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285707;
        bh=PRKKSlC++3tu0htGySyF7EK6m/IfUhB+bYRdOYfYruw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMKbI9dwnPxEWWOfe+ynqFLoB4+1GDXqHoiw+nkoqgiVYk7zZF6uau0DILP973hcW
         v2F4KYMem8odoR0ladnaWYjFYRrwBlWNwbuJMWazPqkGGu7P6u0P/Ul9e+1OErMOTx
         cZZiIwr69lazYQKU4bKp8wvAZrf0pKWavWWykm90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5.10 088/105] genirq/affinity: Consider that CPUs on nodes can be unbalanced
Date:   Mon, 18 Apr 2022 14:13:30 +0200
Message-Id: <20220418121149.133631295@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>

commit 08d835dff916bfe8f45acc7b92c7af6c4081c8a7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/affinity.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -269,8 +269,9 @@ static int __irq_build_affinity_masks(un
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


