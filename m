Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3E24CF6EC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbiCGJnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240538AbiCGJlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46742273D;
        Mon,  7 Mar 2022 01:37:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CCB6128E;
        Mon,  7 Mar 2022 09:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B50C340E9;
        Mon,  7 Mar 2022 09:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645842;
        bh=r8Ao5v/dnH/vW+0w9rwvC1D8D+2q8aKGa6MHCS65ao0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2rSomsNqZ3KF3N153HPViLt3E4JlxJ2CmKXonjsv9Ff2bh1NfAqCP8/ATtpbCPCt
         yH703DOP4kMSV1Pjn+43cQ1VDmW118xYFuQg6lh32Vuw2XTEjhCg66sAmtunP/9A0m
         aQK+lkPFk/ExOVKBVCFnjJCiuk6Znu56KcR50AR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/262] PCI: aardvark: Fix checking for MEM resource type
Date:   Mon,  7 Mar 2022 10:16:38 +0100
Message-Id: <20220307091704.040305642@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 2070b2ddea89f5b604fac3d27ade5cb6d19a5706 ]

IORESOURCE_MEM_64 is not a resource type but a type flag.

Remove incorrect check for type IORESOURCE_MEM_64.

Link: https://lore.kernel.org/r/20211125160148.26029-2-kabel@kernel.org
Fixes: 64f160e19e92 ("PCI: aardvark: Configure PCIe resources from 'ranges' DT property")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 85323cbc4888a..b2217e2b3efde 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1537,8 +1537,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		 * only PIO for issuing configuration transfers which does
 		 * not use PCIe window configuration.
 		 */
-		if (type != IORESOURCE_MEM && type != IORESOURCE_MEM_64 &&
-		    type != IORESOURCE_IO)
+		if (type != IORESOURCE_MEM && type != IORESOURCE_IO)
 			continue;
 
 		/*
@@ -1546,8 +1545,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		 * configuration is set to transparent memory access so it
 		 * does not need window configuration.
 		 */
-		if ((type == IORESOURCE_MEM || type == IORESOURCE_MEM_64) &&
-		    entry->offset == 0)
+		if (type == IORESOURCE_MEM && entry->offset == 0)
 			continue;
 
 		/*
-- 
2.34.1



