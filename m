Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705E914B638
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgA1ODb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgA1OD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE5FF2468D;
        Tue, 28 Jan 2020 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220209;
        bh=A24LsO0d3DuD+wDWWl1ud8hGDPwxevJPgWeuw9uy1A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2mxzsOObio9PlkHRsDcOQfq+SkcQSjKawmyRD+C/EzeU2Qn4iGSK/9n29CtIbF8C
         cfhYAo2yjnjX7tvgKM0lp4AsS+jKFvNW1dW5Rw4ZLBpxqtcvUEk91SCsseywSLEH/Z
         1/6sAqQ8lS+GhvLatsde++E/QcRQINKXOgAF8PWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 060/104] mmc: sdhci_am654: Remove Inverted Write Protect flag
Date:   Tue, 28 Jan 2020 15:00:21 +0100
Message-Id: <20200128135825.883055904@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit 4d627c88546a697b07565dbb70d2f9f46a5ee76f upstream.

The MMC/SD controllers on am65x and j721e don't in fact detect the write
protect line as inverted. No issues were detected because of this
because the sdwp line is not connected on any of the evms. Fix this by
removing the flag.

Fixes: 1accbced1c32 ("mmc: sdhci_am654: Add Support for 4 bit IP on J721E")
Cc: stable@vger.kernel.org
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200108143301.1929-2-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci_am654.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -249,8 +249,7 @@ static struct sdhci_ops sdhci_am654_ops
 
 static const struct sdhci_pltfm_data sdhci_am654_pdata = {
 	.ops = &sdhci_am654_ops,
-	.quirks = SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
-		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
@@ -272,8 +271,7 @@ static struct sdhci_ops sdhci_j721e_8bit
 
 static const struct sdhci_pltfm_data sdhci_j721e_8bit_pdata = {
 	.ops = &sdhci_j721e_8bit_ops,
-	.quirks = SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
-		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
@@ -295,8 +293,7 @@ static struct sdhci_ops sdhci_j721e_4bit
 
 static const struct sdhci_pltfm_data sdhci_j721e_4bit_pdata = {
 	.ops = &sdhci_j721e_4bit_ops,
-	.quirks = SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
-		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 


