Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C6E58C00B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbiHHBrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243322AbiHHBqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF67815814;
        Sun,  7 Aug 2022 18:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD9060DFE;
        Mon,  8 Aug 2022 01:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D995C43158;
        Mon,  8 Aug 2022 01:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922607;
        bh=UkgRBGRGiND0e5vjUxLk3kZH+BsEyc38Jo903maH+RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohfQK8rE9NHrW9aXfXrfUJhpvvhwFf6o3vgEhpfFDt0owidoD/Txe6+lNnQcb/T/3
         1IgVZZDFuCRJNChiiSUDFYF3x91tkO6KbbRcqJ//oekob5bKHb8t2cA61niBC+kgrc
         oX88I77FHVejhUofYsstUvGB/BK8etTP0F1JeoXH6y3Eowc6tBusq6SC160nsouycW
         Izy729Eo/Is/v5b1MnM9LGEGcQRKTsaeGwYHe4MS2P7iokyPkGe5pa23cgiMVf4Oa+
         t0sT0ghpuoHwzbfiBrOFcGB5xnSsrGnwAMvPKZgnYaFXIzcTAHQ1+mx5oBFRuZYxpF
         EkpYpRLLOkhVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     William Dean <williamsukatube@163.com>,
        Hacash Robot <hacashRobot@santino.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tsbogend@alpha.franken.de, fancer.lancer@gmail.com,
        tglx@linutronix.de, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/45] irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()
Date:   Sun,  7 Aug 2022 21:35:20 -0400
Message-Id: <20220808013551.315446-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: William Dean <williamsukatube@163.com>

[ Upstream commit 71349cc85e5930dce78ed87084dee098eba24b59 ]

The function ioremap() in gic_of_init() can fail, so
its return value should be checked.

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@163.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220723100128.2964304-1-williamsukatube@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index f03f47ffea1e..d815285f1efe 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -767,6 +767,10 @@ static int __init gic_of_init(struct device_node *node,
 	}
 
 	mips_gic_base = ioremap(gic_base, gic_len);
+	if (!mips_gic_base) {
+		pr_err("Failed to ioremap gic_base\n");
+		return -ENOMEM;
+	}
 
 	gicconfig = read_gic_config();
 	gic_shared_intrs = gicconfig & GIC_CONFIG_NUMINTERRUPTS;
-- 
2.35.1

