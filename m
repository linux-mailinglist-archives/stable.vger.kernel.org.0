Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2E5E9F19
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiIZKT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiIZKSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:18:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A5649B40;
        Mon, 26 Sep 2022 03:15:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E79C60B97;
        Mon, 26 Sep 2022 10:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000AFC433D6;
        Mon, 26 Sep 2022 10:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187324;
        bh=vN9yVk82ZFk4dEwgCx+4IuPIPCT6CZf5RbGU+zOwaSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVNk5Fs9XjqmVY5AB+uGrwmdcdGy7Im5GV2NvKBBSBNQQTuZOi0VOcxTGXJlGYITf
         KcuG3ZQI/+D47UDCoa5XIXcVaZ2WCl7fCoWnU2Uoyg82RbryJqQ5rdqY2yIU8cah1Z
         fnOxwP4R9YMuSj1IEb7h+KZqshl0RShQR1I3qyIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/40] MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()
Date:   Mon, 26 Sep 2022 12:11:40 +0200
Message-Id: <20220926100738.689498854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index a27b3d70393f..657e626cc41e 100644
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



