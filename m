Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1551AA24
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355704AbiEDRVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357582AbiEDRPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943EB5521F
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED771B82416
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FBBC385B8;
        Wed,  4 May 2022 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683524;
        bh=+qFyvAsJHmod36OH1SZbecAcPsFD7YcL+3MjQbPiFL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqKIa684IiW3buBRNdecqLCVGOh4US6NdSl6RpeMZq0IUUvLZFFKLQ/YkgA7egSVs
         UdZ9uRRxKUSnLZ+o5xYH3t2WfbKFEH1xHGAOeLGWVYh3EmG7t3qBgaj96VgERc/0S/
         rYjERD8T6TKz9DOHJFafka5OwzGVmR/Bf6/u8WjbTYalVKrFFmcZ5NENbO5dnGq0wv
         1JkEdZSFxJab+YY2blhM3qvEQDM0t4RVQSgoBP2ztvOfNXgwLUZ8wnAB26cXm6XAzk
         eiBG/eUQ9lF0rTCHGcLK4slS5ua/LCDECb6YcldUrQQITZxEn6R6lebbNU7BioJyS9
         V9ul0CzwH6mmA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 28/30] PCI: aardvark: Don't mask irq when mapping
Date:   Wed,  4 May 2022 18:57:53 +0200
Message-Id: <20220504165755.30002-29-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pali Rohár <pali@kernel.org>

commit befa71000160b39c1bf6cdfca6837bb5e9d372d7 upstream.

By default, all Legacy INTx interrupts are masked, so there is no need to
mask this interrupt during irq_map() callback.

Link: https://lore.kernel.org/r/20220110015018.26359-21-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index e1783fb94eb8..58b92dfa3e74 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1332,7 +1332,6 @@ static int advk_pcie_irq_map(struct irq_domain *h,
 {
 	struct advk_pcie *pcie = h->host_data;
 
-	advk_pcie_irq_mask(irq_get_irq_data(virq));
 	irq_set_status_flags(virq, IRQ_LEVEL);
 	irq_set_chip_and_handler(virq, &pcie->irq_chip,
 				 handle_level_irq);
-- 
2.35.1

