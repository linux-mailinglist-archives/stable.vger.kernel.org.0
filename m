Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6EF12EEA7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgABWiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731227AbgABWiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:38:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6C1920866;
        Thu,  2 Jan 2020 22:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004698;
        bh=ap4dpVjQn3Nk0xHRM8S8HUI1F0pgWpUX/ogfa4HdwDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoYXuFovl52tukywLXC075HXHPTbnkCwiqhW3fHssln7p066B0mgzZo/3pxj7L4rS
         TbfgPoNjCgLskmxY+ZH5g/c0hIiTgkI/5iyyr5FoETGTxdMOaUegP970gZAnnD7MUk
         dPLnGz3fQZnEYUMal2qcGhWh1D++NT8u173sJLZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 088/137] mmc: sdhci-of-esdhc: fix P2020 errata handling
Date:   Thu,  2 Jan 2020 23:07:41 +0100
Message-Id: <20200102220558.568480528@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

commit fe0acab448f68c3146235afe03fb932e242ec94c upstream.

Two previous patches introduced below quirks for P2020 platforms.
- SDHCI_QUIRK_RESET_AFTER_REQUEST
- SDHCI_QUIRK_BROKEN_TIMEOUT_VAL

The patches made a mistake to add them in quirks2 of sdhci_host
structure, while they were defined for quirks.
	host->quirks2 |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
	host->quirks2 |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;

This patch is to fix them.
	host->quirks |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
	host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;

Fixes: 05cb6b2a66fa ("mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support")
Fixes: a46e42712596 ("mmc: sdhci-of-esdhc: add erratum eSDHC5 support")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191216031842.40068-1-yangbo.lu@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -625,8 +625,8 @@ static int sdhci_esdhc_probe(struct plat
 		host->quirks &= ~SDHCI_QUIRK_NO_BUSY_IRQ;
 
 	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc")) {
-		host->quirks2 |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
-		host->quirks2 |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+		host->quirks |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
+		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 	}
 
 	if (of_device_is_compatible(np, "fsl,p5040-esdhc") ||


