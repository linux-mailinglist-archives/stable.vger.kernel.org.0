Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBF51A9B3
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356769AbiEDRTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357564AbiEDRPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E415520D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992706179D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFDCC385B0;
        Wed,  4 May 2022 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683523;
        bh=0/LLEg595DdMV4CWDCK0iNA8sk94FhJe32O27McizyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYFiLn5Sz8lH9482zhttMrUgOG7p/kb985zxTTMpcRdeE5DEgXX9y+kiD9ih4AOQm
         lQkAk6R+ZIm2RYVGkaY4XfzQOQmi3hcos1hbSNOTbR2vgGRASCu9tL835d+pGLVs6c
         xaI/COSWDMWUE7LMjL91YSvRyTxH1aQGfzUNaHloMBD7gLy1NLe9vqYbgd20kdZk0s
         GrxRfTLDm5UmDbpOPBLEVClIPGHpDv7cm7m82NX7V4fsYnSHDYLag2tTK6K84NK0u5
         BzI02IBOIyMBRFPNnYQRyM5rUeX5bzFxfJDPObrftUQmuJXfq7I0ktUaQnZMhpQvg5
         HIHQjz6tPdTKA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 27/30] PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts
Date:   Wed,  4 May 2022 18:57:52 +0200
Message-Id: <20220504165755.30002-28-kabel@kernel.org>
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
index 39fa8af01671..e1783fb94eb8 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1415,7 +1415,6 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	}
 
 	irq_chip->irq_mask = advk_pcie_irq_mask;
-	irq_chip->irq_mask_ack = advk_pcie_irq_mask;
 	irq_chip->irq_unmask = advk_pcie_irq_unmask;
 
 	pcie->irq_domain =
-- 
2.35.1

