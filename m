Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C5551AA06
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354156AbiEDRUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358122AbiEDRPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D514C40D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1ABCB827A9
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D6BC385B5;
        Wed,  4 May 2022 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683563;
        bh=PIEf6yrEp6OMjRBa9TCvaD0Y664sNOkqjnqO4vlganI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwi6kO2R30dKhlgi/pSR4M3ED3Jt0I32iqv+T/pGWsv6DITB5KPjAWn6KpIHqNgoH
         wa5bJMtIERM33mZUx9lYfA1DNfbgX4oOezOAbjIzioW4n/cZ7IM4xsywTD7YM8ai7d
         jOZG13NHMeFqeC4WXlJbtzCn3HjOA23iajPXr1ViTef6Cm9nEa70mf5gGr3iBshX8n
         6xMy0XPAt6oJhqAmvDappQ0tIMG33v9YvE7PZs179y+XYcHnPS760Lwuwwqfx8PuD2
         zvEvzqO21o5Z5mqYtNlbGkNj+z1KiYpcLZbknoth6IFAmMrFwA8l2bfa8awtPniYhx
         pF80hp1FAWqOw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 17/19] PCI: aardvark: Don't mask irq when mapping
Date:   Wed,  4 May 2022 18:58:50 +0200
Message-Id: <20220504165852.30089-18-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165852.30089-1-kabel@kernel.org>
References: <20220504165852.30089-1-kabel@kernel.org>
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
index faf4f55c462d..955ce7ef0407 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1330,7 +1330,6 @@ static int advk_pcie_irq_map(struct irq_domain *h,
 {
 	struct advk_pcie *pcie = h->host_data;
 
-	advk_pcie_irq_mask(irq_get_irq_data(virq));
 	irq_set_status_flags(virq, IRQ_LEVEL);
 	irq_set_chip_and_handler(virq, &pcie->irq_chip,
 				 handle_level_irq);
-- 
2.35.1

