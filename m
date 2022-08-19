Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2777559A3A5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353383AbiHSQkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353368AbiHSQjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:39:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BC49109E;
        Fri, 19 Aug 2022 09:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27050614DA;
        Fri, 19 Aug 2022 16:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDC2C433C1;
        Fri, 19 Aug 2022 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925249;
        bh=fw9i8RhpOoj2gMS4VBjk+TrGpw1xeKcJG7ORRDyhstA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKTZCeqYKL9PCZRiGqLG/i9SVut/pBxuoDQY19pfr1X4u6lAkwJiXGjv8E1XgUkAl
         e1glqmszu/fzqCiaAlXDRUernvl1Mjwm8Ml0hRbCxc5e4xT83C4lgxIPTScRDKFRwc
         zoKA5s8jyT5KDj6coD5cGAd9Y1rnJQSqtRlxlmIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddh Raman Pant <code@siddh.me>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/545] x86/numa: Use cpumask_available instead of hardcoded NULL check
Date:   Fri, 19 Aug 2022 17:43:21 +0200
Message-Id: <20220819153848.703712858@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit 625395c4a0f4775e0fe00f616888d2e6c1ba49db ]

GCC-12 started triggering a new warning:

  arch/x86/mm/numa.c: In function ‘cpumask_of_node’:
  arch/x86/mm/numa.c:916:39: warning: the comparison will always evaluate as ‘false’ for the address of ‘node_to_cpumask_map’ will never be NULL [-Waddress]
    916 |         if (node_to_cpumask_map[node] == NULL) {
        |                                       ^~

node_to_cpumask_map is of type cpumask_var_t[].

When CONFIG_CPUMASK_OFFSTACK is set, cpumask_var_t is typedef'd to a
pointer for dynamic allocation, else to an array of one element. The
"wicked game" can be checked on line 700 of include/linux/cpumask.h.

The original code in debug_cpumask_set_cpu() and cpumask_of_node() were
probably written by the original authors with CONFIG_CPUMASK_OFFSTACK=y
(i.e. dynamic allocation) in mind, checking if the cpumask was available
via a direct NULL check.

When CONFIG_CPUMASK_OFFSTACK is not set, GCC gives the above warning
while compiling the kernel.

Fix that by using cpumask_available(), which does the NULL check when
CONFIG_CPUMASK_OFFSTACK is set, otherwise returns true. Use it wherever
such checks are made.

Conditional definitions of cpumask_available() can be found along with
the definition of cpumask_var_t. Check the cpumask.h reference mentioned
above.

Fixes: c032ef60d1aa ("cpumask: convert node_to_cpumask_map[] to cpumask_var_t")
Fixes: de2d9445f162 ("x86: Unify node_to_cpumask_map handling between 32 and 64bit")
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20220731160913.632092-1-code@siddh.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e94da744386f..9dc31996c7ed 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -861,7 +861,7 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 		return;
 	}
 	mask = node_to_cpumask_map[node];
-	if (!mask) {
+	if (!cpumask_available(mask)) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
 		dump_stack();
 		return;
@@ -907,7 +907,7 @@ const struct cpumask *cpumask_of_node(int node)
 		dump_stack();
 		return cpu_none_mask;
 	}
-	if (node_to_cpumask_map[node] == NULL) {
+	if (!cpumask_available(node_to_cpumask_map[node])) {
 		printk(KERN_WARNING
 			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
 			node);
-- 
2.35.1



