Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B074F33C9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiDEKGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344267AbiDEJTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A1E220DE;
        Tue,  5 Apr 2022 02:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFD461571;
        Tue,  5 Apr 2022 09:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C039C385A1;
        Tue,  5 Apr 2022 09:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149593;
        bh=hUw5GvYClpR87kollzuNvmjc3unATiZOHiuZijPqx/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaFJ2kWx1a7RhTHQy1JrDDFcTuIIzkbQlDmEjKCRvJAfaG4R4FBqWjtsAr5y67KKB
         3Xp8mIkWfyapmUYMzg4k1/DsPS9roWt42ssgWcPyfWQ8GGr7md05RHE/Rlm5mBQiQ7
         njr2dOFa5k0cmmNWu9dTmd8c0DiFCf5g/mjXmQr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0771/1017] irqchip/nvic: Release nvic_base upon failure
Date:   Tue,  5 Apr 2022 09:28:04 +0200
Message-Id: <20220405070417.145962088@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Souptick Joarder (HPE) <jrdr.linux@gmail.com>

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
index ba4759b3e269..94230306e0ee 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -107,6 +107,7 @@ static int __init nvic_of_init(struct device_node *node,
 
 	if (!nvic_irq_domain) {
 		pr_warn("Failed to allocate irq domain\n");
+		iounmap(nvic_base);
 		return -ENOMEM;
 	}
 
@@ -116,6 +117,7 @@ static int __init nvic_of_init(struct device_node *node,
 	if (ret) {
 		pr_warn("Failed to allocate irq chips\n");
 		irq_domain_remove(nvic_irq_domain);
+		iounmap(nvic_base);
 		return ret;
 	}
 
-- 
2.34.1



