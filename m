Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDED51A9D5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357614AbiEDRTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358090AbiEDRPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04675641B
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8202461920
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A32C385AF;
        Wed,  4 May 2022 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683562;
        bh=iudl3sPioMOWIt4o2ojSrD+RSvKVBpWQmSa5ZS9bpMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Els556y42RGsiX2HETcvKEfG4Jpl8+DzExsByZToxc1zswHesi0NAxz7TMK86fznt
         05UEFEkcid+73nA9BBGhT6HVFQAC9zqGtdLzJJfOnASHXWHnCqSUQIn9jek8i43JXw
         90nBDzWEJNkmfPYcfEOkalQOgs1X7b90z+xoeT82FMLPdLmVA+RGYM6Pfmn7xrJ6zG
         oN224bQrl85saF3By2+BZdMnm8LKpgBeKGFsXhAaT+26Rdh7lKJ3smQRgQkjsMwL6N
         G1U4SWiFmBFsCjJv7FXjgFC+Sc3nUPaoK/7SvHtDFsCK3/uTiyOjXTWlX9TPbOm+Sx
         AUZupbsGB/U/Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 16/19] PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts
Date:   Wed,  4 May 2022 18:58:49 +0200
Message-Id: <20220504165852.30089-17-kabel@kernel.org>
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

commit b08e5b53d17be58eb2311d6790a84fe2c200ee47 upstream.

Callback for irq_mask_ack() is the same as for irq_mask(). As there is no
special handling for irq_ack(), there is no need to define irq_mask_ack()
too.

Link: https://lore.kernel.org/r/20220110015018.26359-20-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 58a5ba852be1..faf4f55c462d 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1413,7 +1413,6 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	}
 
 	irq_chip->irq_mask = advk_pcie_irq_mask;
-	irq_chip->irq_mask_ack = advk_pcie_irq_mask;
 	irq_chip->irq_unmask = advk_pcie_irq_unmask;
 
 	pcie->irq_domain =
-- 
2.35.1

