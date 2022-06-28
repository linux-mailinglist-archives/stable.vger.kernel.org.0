Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E4855CBA5
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244202AbiF1CXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244094AbiF1CXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CC22558B;
        Mon, 27 Jun 2022 19:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C22661881;
        Tue, 28 Jun 2022 02:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24278C34115;
        Tue, 28 Jun 2022 02:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382940;
        bh=Hd0S/dljPikqpRwvDn2bnlA41v1oEllWyud98o9ZumU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3A4xYhR46b3Bo/uWWBdnkGRDB2TDkeVrgCmD89fkhVEPtdNvVScTzcdh31W3Rwvc
         nvsaJXVIzyiO+q+vm3xHmLiplG0W71P4fWPR+ozOKnFGtHmBXeQczfhoMdbmMRxCOV
         cIgHntY/rPUBVIZsqTW6Fv5+WGcrT/oy9gp52Kpd+dQBucx3QNNr8dUTM/vIvydioH
         rA90Y0YHztB+BrnbrILPgvpDEgzTLAJEP4k7PbDriNghCcpMnlcPnD57/7OW2+87j3
         aiW8LT+g1cLmn13ngEDLc8f+S9hssOKEV6LsbMvzv6KF8a7ld5avNKte1bUqFm4i8a
         oPCZ2wj8f7nlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangtiezhu@loongson.cn,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/41] mips/pic32/pic32mzda: Fix refcount leak bugs
Date:   Mon, 27 Jun 2022 22:20:51 -0400
Message-Id: <20220628022100.595243-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit eb9e9bc4fa5fb489c92ec588b3fb35f042ba6d86 ]

of_find_matching_node(), of_find_compatible_node() and
of_find_node_by_path() will return node pointers with refcout
incremented. We should call of_node_put() when they are not
used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pic32/pic32mzda/init.c | 7 ++++++-
 arch/mips/pic32/pic32mzda/time.c | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index 764f2d022fae..b57384eeef66 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -106,13 +106,18 @@ static int __init pic32_of_prepare_platform_data(struct of_dev_auxdata *lookup)
 		np = of_find_compatible_node(NULL, NULL, lookup->compatible);
 		if (np) {
 			lookup->name = (char *)np->name;
-			if (lookup->phys_addr)
+			if (lookup->phys_addr) {
+				of_node_put(np);
 				continue;
+			}
 			if (!of_address_to_resource(np, 0, &res))
 				lookup->phys_addr = res.start;
+			of_node_put(np);
 		}
 	}
 
+	of_node_put(root);
+
 	return 0;
 }
 
diff --git a/arch/mips/pic32/pic32mzda/time.c b/arch/mips/pic32/pic32mzda/time.c
index 7174e9abbb1b..777b515c52c8 100644
--- a/arch/mips/pic32/pic32mzda/time.c
+++ b/arch/mips/pic32/pic32mzda/time.c
@@ -32,6 +32,9 @@ static unsigned int pic32_xlate_core_timer_irq(void)
 		goto default_map;
 
 	irq = irq_of_parse_and_map(node, 0);
+
+	of_node_put(node);
+
 	if (!irq)
 		goto default_map;
 
-- 
2.35.1

