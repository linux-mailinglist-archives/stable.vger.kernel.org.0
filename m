Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91989499A64
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352946AbiAXVns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46086 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454359AbiAXVcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77397B812A5;
        Mon, 24 Jan 2022 21:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF32C340E4;
        Mon, 24 Jan 2022 21:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059941;
        bh=txNX374nHenWS5fo70U4Ivs9K+G5lAxFBUkin4hVTmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omGCVRbbvAfUUUYAIbh6dILPBtGnYnMxdwiU7QJWIxApwjtdjrxB0+TNWqZlQdidC
         aHac7PwHg59or0VwqvpYA84WeadFeTd1kJ8QbTehijawSM9PqC7hOSi3U68J2rqBfD
         6u5bH+183a3itw0JQ6RILQJ6EoJsMlzvN4JWThhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0786/1039] PCI: aardvark: Fix checking for MEM resource type
Date:   Mon, 24 Jan 2022 19:42:55 +0100
Message-Id: <20220124184151.709548250@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index c3b725afa11fd..e3001b3b32930 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1535,8 +1535,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		 * only PIO for issuing configuration transfers which does
 		 * not use PCIe window configuration.
 		 */
-		if (type != IORESOURCE_MEM && type != IORESOURCE_MEM_64 &&
-		    type != IORESOURCE_IO)
+		if (type != IORESOURCE_MEM && type != IORESOURCE_IO)
 			continue;
 
 		/*
@@ -1544,8 +1543,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
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



