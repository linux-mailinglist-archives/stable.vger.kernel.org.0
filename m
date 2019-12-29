Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F0812C585
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfL2Rgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730063AbfL2Rgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:36:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76473206CB;
        Sun, 29 Dec 2019 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640992;
        bh=g+N0/g6R4gWKlxZcTIY6rBxf1YdyFsaiJ1YqZUeyx2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6x657S9A2PJx+/KZc0SZWwnSt+It2Rkn1nTIR18DIEwh9C1uIdN36UQbmANR5Y7t
         ExOJ3fsCXrjCMzw4N7UMtu743gN09XZQ8iyDYa6C4WDRHz5vukgDQSsOvByV+zBodJ
         JNsDFbvvsSdKIzR9qu0tBaPrCQTc+n0whU4IoHPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 216/219] mmc: sdhci-of-esdhc: fix P2020 errata handling
Date:   Sun, 29 Dec 2019 18:20:18 +0100
Message-Id: <20191229162543.135029069@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
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
@@ -923,8 +923,8 @@ static int sdhci_esdhc_probe(struct plat
 		host->quirks &= ~SDHCI_QUIRK_NO_BUSY_IRQ;
 
 	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc")) {
-		host->quirks2 |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
-		host->quirks2 |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+		host->quirks |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
+		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 	}
 
 	if (of_device_is_compatible(np, "fsl,p5040-esdhc") ||


