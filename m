Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3324E9480
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiC1LaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241182AbiC1L3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:29:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F0C4ECFB;
        Mon, 28 Mar 2022 04:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F30D7B81061;
        Mon, 28 Mar 2022 11:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7ADC34100;
        Mon, 28 Mar 2022 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466641;
        bh=HQIIJpmNq9N1Slcu8StaroPhbPp8EKGVVCdngl137/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUHStGSS7z+P/6HkFSTRRGy8rSIAsLekg+RiNl8UW8x1PWfht7rMqS1/VfW3ywOAr
         s1G5cmwaIQNhf9i5h6nudWO5TPAunFVtA/h8DvIU9ezKetrUIOM+iYMVsvYqHAGYb+
         6vrCEkFGF5oLUksuR7PBG/lwX2/SVrTrxTVhuYZwXI5WgKYk5pw/1TI3WM9HtfwG+C
         xs9Cxm7xV2tyA+9Oo6GiHZnXOtULAtW/oFwUO3Dw1+xo1p5U5jvbY1PCQfQIOsQNUC
         MndM2gsqUYI8AM4nNivqrMlpaalahJUctHeZDLjTsRcrNPAK1m1dyYD4PjmBqlJrQR
         wEmdrLqiu4Igg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.4 09/16] irqchip/nvic: Release nvic_base upon failure
Date:   Mon, 28 Mar 2022 07:23:38 -0400
Message-Id: <20220328112345.1556601-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112345.1556601-1-sashal@kernel.org>
References: <20220328112345.1556601-1-sashal@kernel.org>
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

From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>

[ Upstream commit e414c25e3399b2b3d7337dc47abccab5c71b7c8f ]

smatch warning was reported as below ->

smatch warnings:
drivers/irqchip/irq-nvic.c:131 nvic_of_init()
warn: 'nvic_base' not released on lines: 97.

Release nvic_base upon failure.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220218163303.33344-1-jrdr.linux@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-nvic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 160b39b5cd10..128a26d219e2 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -105,6 +105,7 @@ static int __init nvic_of_init(struct device_node *node,
 
 	if (!nvic_irq_domain) {
 		pr_warn("Failed to allocate irq domain\n");
+		iounmap(nvic_base);
 		return -ENOMEM;
 	}
 
@@ -114,6 +115,7 @@ static int __init nvic_of_init(struct device_node *node,
 	if (ret) {
 		pr_warn("Failed to allocate irq chips\n");
 		irq_domain_remove(nvic_irq_domain);
+		iounmap(nvic_base);
 		return ret;
 	}
 
-- 
2.34.1

