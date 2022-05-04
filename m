Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEBB51A9AE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356725AbiEDRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357470AbiEDRPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D40154F8E
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A5061808
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B11EC385A4;
        Wed,  4 May 2022 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683492;
        bh=Bm+LHSez8Wd7HOJkbz97KfsAmpiuF7x3y9aUntw7nMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqB2jtsKKnqRH0Yqu82n/Xm2dhUICPO+LZoQ/0Qs94wFUi4+eHzqf0/oLHGkHkJEV
         l5hugBjY1LdscWlXbWCjBUGfF6JTW1QIzKpChc8XWuetEfDdGpvUHmhD1HvWbx4Jb5
         feCN5I18SHXSx8N6ePEHkfx6f/VH9puYJfTl0NH7gnRUWLWkwVlf6aWJDHsqFmECNk
         s8qm7+AMCBcW4k/vdNfCoscz+XsQcd4rCs2Q3wvNSMfrlfC1csml1BiQRTlKG3eu4T
         rqUyh3LM6Y8QWsKh8Me7lEwHgwH/oBWKT8diG1uJo8CWFyhARvvptFWCZHDNfztLql
         O2HJcb48eq/OA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 08/30] PCI: aardvark: Fix memory leak in driver unbind
Date:   Wed,  4 May 2022 18:57:33 +0200
Message-Id: <20220504165755.30002-9-kabel@kernel.org>
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

commit 2f040a17f5061457ae95035326d3159eddc1e5cc upstream.

Free config space for emulated root bridge when unbinding driver to fix
memory leak. Do it after disabling and masking all interrupts, since
aardvark interrupt handler accesses config space of emulated root
bridge.

Link: https://lore.kernel.org/r/20211130172913.9727-9-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index d2c01c6e6815..02eefc13ac60 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1718,6 +1718,9 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 
+	/* Free config space for emulated root bridge */
+	pci_bridge_emul_cleanup(&pcie->bridge);
+
 	/* Disable outbound address windows mapping */
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);
-- 
2.35.1

