Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DFD4E94D6
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbiC1Lch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbiC1Lb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:31:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838AC56743;
        Mon, 28 Mar 2022 04:24:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBA8FB81056;
        Mon, 28 Mar 2022 11:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE95C340EC;
        Mon, 28 Mar 2022 11:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466665;
        bh=afXJF7r+BNN7Bd/BCnFM0/zZ4G0iDP/43BVuOKMseVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Shl+V5gB+3va8hxI6/hdpaG6UoXiv+PlerR7w6rVwjYBsnQDChz2qxiFBnu9SJfGZ
         ZR2Aw4zc3d3h8Tsjt0qew/YS6DOcTEAbceTOyD4UOJlsLyF0tR/zMMwI1MK3/1h0HD
         5I5ecm45IgQ8CVRPzKZEIac2wyoGCz/FCGdgIyDe5lG4iYWpFbGDvsQMFZHnucFstD
         c7E3JhKoouhEaA3abTEiRGerN25yJAVd96uZiDZOkNhH9d4Hp9EHKEa8cvjhyf12Hi
         NWDUB3JHAP2TASWDZ6YmXUs5qv66tagcZhRPWJ5vfRfL9NDEGcFTA92X2hUPsJYl5U
         vrhmdv7wXYxnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 4.19 05/12] irqchip/nvic: Release nvic_base upon failure
Date:   Mon, 28 Mar 2022 07:24:10 -0400
Message-Id: <20220328112417.1556946-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112417.1556946-1-sashal@kernel.org>
References: <20220328112417.1556946-1-sashal@kernel.org>
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
index 9694529b709d..330beb62d015 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -108,6 +108,7 @@ static int __init nvic_of_init(struct device_node *node,
 
 	if (!nvic_irq_domain) {
 		pr_warn("Failed to allocate irq domain\n");
+		iounmap(nvic_base);
 		return -ENOMEM;
 	}
 
@@ -117,6 +118,7 @@ static int __init nvic_of_init(struct device_node *node,
 	if (ret) {
 		pr_warn("Failed to allocate irq chips\n");
 		irq_domain_remove(nvic_irq_domain);
+		iounmap(nvic_base);
 		return ret;
 	}
 
-- 
2.34.1

