Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037DD59D9C1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352839AbiHWKCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242970AbiHWJ6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8FA1D4E;
        Tue, 23 Aug 2022 01:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3353611DD;
        Tue, 23 Aug 2022 08:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A979C433D6;
        Tue, 23 Aug 2022 08:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244478;
        bh=wlLI3R6AsjmybxTmr2wsmDEIhKG+ZcYSErdm8BeCEe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LB3tA9dtp8X2nhZfswl6/KsuhgsSR3GyUYstwcQc/amVgs+67ziYFSoyGkE5gUKXa
         UDr6fXTJonfAXtXZ6B54TK9DiDViBEQn+5BQkXkk8r2Pw7XInJ/qePd5TFjb8FXz5A
         c9w4r7WRCdAPR1oxIbLQ88LEk/TY0txKKVO5DfSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddh Raman Pant <code@siddh.me>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 143/229] x86/numa: Use cpumask_available instead of hardcoded NULL check
Date:   Tue, 23 Aug 2022 10:25:04 +0200
Message-Id: <20220823080058.782793063@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index 25504d5aa816..15661129794c 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -826,7 +826,7 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 		return;
 	}
 	mask = node_to_cpumask_map[node];
-	if (!mask) {
+	if (!cpumask_available(mask)) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
 		dump_stack();
 		return;
@@ -872,7 +872,7 @@ const struct cpumask *cpumask_of_node(int node)
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



