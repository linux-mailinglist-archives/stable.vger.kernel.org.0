Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1121FC1E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgGNSwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729810AbgGNSwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:52:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA4F022B2B;
        Tue, 14 Jul 2020 18:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752757;
        bh=pK+W22/DcFThLfhF/4gRQyRFkRDEPbf2zOghp31jwvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7qij7+u2KsHkLPsmA1Ssrjrqeo4C61E0+877LsJl0pHKuGD5qPt/+xgG6pDKg8nX
         HUMeD7pqxXQqw9d67GLt/E5ORIU+SznHC42jiZMidfMKIspEcSpTiWkvopMJWYAl+b
         xS39FB+ryEy+4yGuB7q2FIyBSHJ5+cpZ5eS6J0ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Art Nikpal <art@khadas.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 098/109] mmc: meson-gx: limit segments to 1 when dram-access-quirk is needed
Date:   Tue, 14 Jul 2020 20:44:41 +0200
Message-Id: <20200714184110.256716835@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 27a5e7d36d383970affae801d77141deafd536a8 upstream.

The actual max_segs computation leads to failure while using the broadcom
sdio brcmfmac/bcmsdh driver, since the driver tries to make usage of
scatter gather.

But with the dram-access-quirk we use a 1,5K SRAM bounce buffer, and the
max_segs current value of 3 leads to max transfers to 4,5k, which doesn't
work.

This patch sets max_segs to 1 to better describe the hardware limitation,
and fix the SDIO functionality with the brcmfmac/bcmsdh driver on Amlogic
G12A/G12B SoCs on boards like SEI510 or Khadas VIM3.

Reported-by: Art Nikpal <art@khadas.com>
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Fixes: acdc8e71d9bb ("mmc: meson-gx: add dram-access-quirk")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200608084458.32014-1-narmstrong@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/meson-gx-mmc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1151,9 +1151,11 @@ static int meson_mmc_probe(struct platfo
 
 	mmc->caps |= MMC_CAP_CMD23;
 	if (host->dram_access_quirk) {
+		/* Limit segments to 1 due to low available sram memory */
+		mmc->max_segs = 1;
 		/* Limit to the available sram memory */
-		mmc->max_segs = SD_EMMC_SRAM_DATA_BUF_LEN / mmc->max_blk_size;
-		mmc->max_blk_count = mmc->max_segs;
+		mmc->max_blk_count = SD_EMMC_SRAM_DATA_BUF_LEN /
+				     mmc->max_blk_size;
 	} else {
 		mmc->max_blk_count = CMD_CFG_LENGTH_MASK;
 		mmc->max_segs = SD_EMMC_DESC_BUF_LEN /


