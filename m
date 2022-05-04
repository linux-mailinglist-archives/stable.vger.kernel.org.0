Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C3B51A999
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353175AbiEDRSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357150AbiEDROt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032B541A4
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE2E61926
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D262FC385B8;
        Wed,  4 May 2022 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683502;
        bh=5JAE2nH73Aq3dgXms8E1L8SvLpW+oV4ITzf+h2IMZbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il1irbytRKDJTqJJDvV7j714MP1FclFDZZ/S4qj1hfxdNrhwovo+A6LKN/rKuzuMQ
         ovs6kpQpehui+ouShvfFxNiU4bBBRwDIu+Heqp4Y/nLLLpiScIm3fFpPcNTdOAkvFj
         diemXDYXCwG7CGuAs+XX9KIGT2bD26HaCWmgDAONmghzu38huvtoeEJRM6sp49aZhU
         1a7UamiV+ubg0mk3fIACaDuSC5MrVtF+fTJBo/bxqOE/GPw3w8WS0VjD8nfcvjHqJv
         30H+ZvbXMok6V/1lIvrwyY+fr3HSv0FWwE9c1tk9J/MifdHg1/Rhbe3UESMG8RSHRe
         23bpIJz+SOmkg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 14/30] PCI: aardvark: Check return value of generic_handle_domain_irq() when processing INTx IRQ
Date:   Wed,  4 May 2022 18:57:39 +0200
Message-Id: <20220504165755.30002-15-kabel@kernel.org>
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

commit 51f96e287c6f003d3bb29672811c757c5fbf0028 upstream.

It is possible that we receive spurious INTx interrupt. Check for the
return value of generic_handle_domain_irq() when processing INTx IRQ.

Link: https://lore.kernel.org/r/20220110015018.26359-6-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 5d6ed7a3816f..00fe1e6682ad 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1429,7 +1429,9 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 		advk_writel(pcie, PCIE_ISR1_INTX_ASSERT(i),
 			    PCIE_ISR1_REG);
 
-		generic_handle_domain_irq(pcie->irq_domain, i);
+		if (generic_handle_domain_irq(pcie->irq_domain, i) == -EINVAL)
+			dev_err_ratelimited(&pcie->pdev->dev, "unexpected INT%c IRQ\n",
+					    (char)i + 'A');
 	}
 }
 
-- 
2.35.1

