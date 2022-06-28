Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5548655DB55
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbiF1C3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244624AbiF1C1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A49F25C73;
        Mon, 27 Jun 2022 19:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC6606170D;
        Tue, 28 Jun 2022 02:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7123AC34115;
        Tue, 28 Jun 2022 02:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383105;
        bh=tBw7QvR15M6Y4jhKI36OkO2sI08Qgw/3y3KcRr2GDzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzrubjUfIN9U9hw5zmh7b6WWG8LtACrNvaW/7/Z3L4/YWen4z9GOmhPWAaf0yNz7l
         jY4AU4oQv5lDDo3mo9ter6Sb7aPozKnW6mNmEhohqufGQzDVJ9yQ7W+71bKZWC5F0n
         XlKqPYKw/w/CU0f94TeG9WccbIv7FJy/2CaavydJwZABGFo/uhK07MNALOUE3NsZcJ
         kldM9YAj2VLUhVTaH13thmL6bNA6TWbVgff9NQHfCKpDiHU9m69z9x6fcZP8sGXtXC
         fokLlbbPmVrAUMJSxJfSPWvFd5Z0+mcE3RJLGBFFlZeRGrawLeL3HFh4HNmIAKzQG4
         WBGzAemGzAGSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangtiezhu@loongson.cn,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/27] mips/pic32/pic32mzda: Fix refcount leak bugs
Date:   Mon, 27 Jun 2022 22:24:07 -0400
Message-Id: <20220628022413.596341-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022413.596341-1-sashal@kernel.org>
References: <20220628022413.596341-1-sashal@kernel.org>
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
index f232c77ff526..0b2cd87b33d3 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -123,13 +123,18 @@ static int __init pic32_of_prepare_platform_data(struct of_dev_auxdata *lookup)
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
index 905ec1d86928..f4b533c2e94c 100644
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

