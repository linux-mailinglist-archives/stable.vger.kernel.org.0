Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C960B59DCCD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355921AbiHWKsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355645AbiHWKo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:44:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC88E6CD2E;
        Tue, 23 Aug 2022 02:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2490B81C63;
        Tue, 23 Aug 2022 09:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B21C433C1;
        Tue, 23 Aug 2022 09:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245846;
        bh=DL8DDS1N7fZYVKITeuH0f7IEW0g5uIjiciMQzAzvZsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/hFJSCFpK0IFP64+OF8lJ9qC0b1ErmG2RWKkGUKV2ItM+RsKFNnutZoW8UqWYnh7
         tvAyGng2yp0AY8f20cEPBTbzSAMtD6TRsG+AZtoFNXVFtFoCMdCM8JsqFIVUxlWArk
         k0+nx/GWhrljsq4nB2W0+c3pSzX/cvw8Ow8dWVMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddh Raman Pant <code@siddh.me>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/287] x86/numa: Use cpumask_available instead of hardcoded NULL check
Date:   Tue, 23 Aug 2022 10:25:47 +0200
Message-Id: <20220823080106.765499324@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index fa150855647c..b4ff063a4371 100644
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



