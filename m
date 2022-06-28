Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC6E55C62A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbiF1C1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244363AbiF1CZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AFD2559B;
        Mon, 27 Jun 2022 19:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9047618AC;
        Tue, 28 Jun 2022 02:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BA5C34115;
        Tue, 28 Jun 2022 02:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383022;
        bh=gBf2FASKH5N/2icjNawQqMpLTWAtw42YwowtPP9Y2uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnYmK9A37sl1P0yVW+ibLiMJIjod8xNwah7+QD7bFjGhLuhWy0yME2P9ccx7whTfm
         O9KfIMhhdC03qwCFeLtp0fXxYWZhOHa4kJOSMluCBW0lj3o4j3IpPIbe8RHv12az+t
         tsDWK+53CJ62Pn0aG2iLlX/+kjjTmf/LfTjZcx5z2R6jQBxcvT0hX+Z9dPb/rqmfcb
         CNe0IQ4m+aeNKhA1Kmyz1O4/gOQ+b5Q2LjZQMAqZbAhegNU8r7REVMAYqQcOLQfZ/+
         n87WkZEEvjxTNgeLbuiKDmTHo/UUWfknU2jW25ZoQ8LUrSRr/WLS7lLsA8z6cOCb0K
         nFQ054pQoJ59g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/34] mips: mti-malta: Fix refcount leak in malta-time.c
Date:   Mon, 27 Jun 2022 22:22:29 -0400
Message-Id: <20220628022241.595835-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
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

[ Upstream commit 608d94cb84c42585058d692f2fe5d327f8868cdb ]

In update_gic_frequency_dt(), of_find_compatible_node() will return
a node pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mti-malta/malta-time.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 7efcfe0c9cd4..7ac06bc8a86e 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -219,6 +219,8 @@ static void update_gic_frequency_dt(void)
 
 	if (of_update_property(node, &gic_frequency_prop) < 0)
 		pr_err("error updating gic frequency property\n");
+
+	of_node_put(node);
 }
 
 #endif
-- 
2.35.1

