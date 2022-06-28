Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA93355D511
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244168AbiF1CXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244058AbiF1CWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E48625297;
        Mon, 27 Jun 2022 19:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9F6A61799;
        Tue, 28 Jun 2022 02:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B7EC34115;
        Tue, 28 Jun 2022 02:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382931;
        bh=8k2vcbzkNM3k8JQPRjM/5Y6iomxm4JucjrAtP0hNdZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXG0gGTQONvZe/4Qog8zEVyOxviI58yrqbEVYneCGHVeDdt8brZEsrBBXeHQkZ1Zq
         vVKGkhoMwQdxDuqsKy6oFtcow9/0SwPHMvHXYql7xvc7i5Kxij6Hpcv1R0YJOHzw2/
         SXN+us2zZ/u4rboggSlfDzX2ppfMWsllTmzgANJmGtZMcPhNsuDlJ5JcPRjllJIDnu
         HvDNgyfsFF3Dt/ScpQr0Hd27/Tv5nd2Xhh3rQbTx5XQziczk3srQ+seHL65z1oeNxU
         JrODVBvrEsyEKE7iezs3ZlKxaBzwt6KN4L4cn7djbYgROlrDqqrRcLTBuK9tF2zwmg
         NllbiFs0EU0rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/41] mips: ralink: Fix refcount leak in of.c
Date:   Mon, 27 Jun 2022 22:20:48 -0400
Message-Id: <20220628022100.595243-29-sashal@kernel.org>
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

[ Upstream commit 48ca54e39173d1ed4c4dc8cf045484014bb26eaf ]

In plat_of_remap_node(), plat_of_remap_node() will return a node
pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/of.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 0135376c5de5..147ebca6ecbe 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -40,6 +40,8 @@ __iomem void *plat_of_remap_node(const char *node)
 	if (of_address_to_resource(np, 0, &res))
 		panic("Failed to get resource for %s", node);
 
+	of_node_put(np);
+
 	if (!request_mem_region(res.start,
 				resource_size(&res),
 				res.name))
-- 
2.35.1

