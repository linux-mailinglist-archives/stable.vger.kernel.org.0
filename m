Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A0A5B840B
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiINJGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiINJFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:05:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87D75FD7;
        Wed, 14 Sep 2022 02:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6478CB816A9;
        Wed, 14 Sep 2022 09:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DEEC433C1;
        Wed, 14 Sep 2022 09:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146190;
        bh=e2kVlvgprAhl2CfETWVkmRy+y7zyJQ8UcKRMKdXErcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5RdDEiTj76IoK5BxtSBWqXO+ZGPWCAQJ19sBlZGFE7euI8Mq+5cz+OUYt1QZ/5b+
         ZFW2j7y6zRMs/Xz4xAlXC/orIGb2+MXPdQYW+KCmPGi0U6KGzL0ZhURq70wVCvUwUf
         GsOktV4zbDFRbL9M2B7ZQNFr/nOrSHzEMoeKFETPdcc687ykwQUZAL7fsPIyimk1Ob
         0q+0Qh6vdmj5xBgxkyDFVCWbP1fmnjVtcGs9SbAvNZEiUHZdgNF9V2FKwPgVMcywRc
         MGt80uiBUPLNMaQ8ko3lkj30Q8wa8y+GjpwpnXRpOWoghvOSGgY5+gn1KlqreYhRV9
         mTT4L92by1BHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        rikard.falkeborn@gmail.com, mark.rutland@arm.com,
        samuel@sholland.org, Julia.Lawall@inria.fr,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/16] MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()
Date:   Wed, 14 Sep 2022 05:02:22 -0400
Message-Id: <20220914090224.470913-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090224.470913-1-sashal@kernel.org>
References: <20220914090224.470913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

[ Upstream commit ba912afbd611d3a5f22af247721a071ad1d5b9e0 ]

For irq_domain_associate() to work the virq descriptor has to be
pre-allocated in advance. Otherwise the following happens:

WARNING: CPU: 0 PID: 0 at .../kernel/irq/irqdomain.c:527 irq_domain_associate+0x298/0x2e8
error: virq128 is not allocated
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.78-... #1
        ...
Call Trace:
[<ffffffff801344c4>] show_stack+0x9c/0x130
[<ffffffff80769550>] dump_stack+0x90/0xd0
[<ffffffff801576d0>] __warn+0x118/0x130
[<ffffffff80157734>] warn_slowpath_fmt+0x4c/0x70
[<ffffffff801b83c0>] irq_domain_associate+0x298/0x2e8
[<ffffffff80a43bb8>] octeon_irq_init_ciu+0x4c8/0x53c
[<ffffffff80a76cbc>] of_irq_init+0x1e0/0x388
[<ffffffff80a452cc>] init_IRQ+0x4c/0xf4
[<ffffffff80a3cc00>] start_kernel+0x404/0x698

Use irq_alloc_desc_at() to avoid the above problem.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-irq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index be5d4afcd30f9..353dfeee0a6d3 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -127,6 +127,16 @@ static void octeon_irq_free_cd(struct irq_domain *d, unsigned int irq)
 static int octeon_irq_force_ciu_mapping(struct irq_domain *domain,
 					int irq, int line, int bit)
 {
+	struct device_node *of_node;
+	int ret;
+
+	of_node = irq_domain_get_of_node(domain);
+	if (!of_node)
+		return -EINVAL;
+	ret = irq_alloc_desc_at(irq, of_node_to_nid(of_node));
+	if (ret < 0)
+		return ret;
+
 	return irq_domain_associate(domain, irq, line << 6 | bit);
 }
 
-- 
2.35.1

