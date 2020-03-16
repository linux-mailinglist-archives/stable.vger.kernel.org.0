Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08840186A19
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbgCPLcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:32:19 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54891 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730759AbgCPLcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:32:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 74DF07D9;
        Mon, 16 Mar 2020 07:32:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MsdQWT
        iar3RtFe5P1sSw3uGfQzu+nMsjYxVFDir9g5Y=; b=2iDzUomRnUkci5KIbnTlyJ
        rjpUbGjd8MBPS4Be7E7EyGJt4X05nSaOJLHvbjJYNhmLcGisecb69QjIul1PkmXX
        uUjHUp4JzvlrUKk9ycAoTz6Ejx7QIT3CdnBOchTwqqgvI7eaBjMIXfaxqnXUmwao
        o9oY32pK0zEqYLQHYbBQIEdUAdp4q8mwF7EU1p5FkQZgQA+mLI0dfAiEUhdavNS/
        OwhasJJJy8KEGDb44LBONUhHfHwKL3QTVUTjyU3m3xzkK5jHnK3xioFemxcO0R4r
        0dgoQutu4NQLVf6sX5QeC7dbl65BZnui2oPzjYRaEPBW1boaOVoR0xEJ/Omtnp3w
        ==
X-ME-Sender: <xms:wmNvXlel4PyXbGotMzIv3eY7-2QRP0h-6yyC12M-qiDzT4VaUXPLEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeeine
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wmNvXpETbeBZlHrZ1K6YM7hTRX0yQN_m6ZobHDKINkgXiCtXsnWVoA>
    <xmx:wmNvXpsxOm5T6uwQlne46XyHKXeDGgW0T9cU72OBdkd2OsD5UY4PnA>
    <xmx:wmNvXpDlUbSdFDgmP2elCvIlG06K54yFrK8RPOHZ9FwuNFg4Qe4q1A>
    <xmx:wmNvXg9k16wqEC4TWfYl_a7HG-AozeC4I0AgY5_ptn4NHD2ipoB6OQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B280430624CC;
        Mon, 16 Mar 2020 07:32:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci-tegra: Fix busy detection by enabling" failed to apply to 5.5-stable tree
To:     ulf.hansson@linaro.org, bbiswas@nvidia.com, pgwipeout@gmail.com,
        skomatineni@nvidia.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:32:16 +0100
Message-ID: <1584358336167196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d2f8bfa4bff5028bc40ed56b4497c32e05b0178f Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 10 Mar 2020 15:50:11 +0100
Subject: [PATCH] mmc: sdhci-tegra: Fix busy detection by enabling
 MMC_CAP_NEED_RSP_BUSY

It has turned out that the sdhci-tegra controller requires the R1B response,
for commands that has this response associated with them. So, converting
from an R1B to an R1 response for a CMD6 for example, leads to problems
with the HW busy detection support.

Fix this by informing the mmc core about the requirement, via setting the
host cap, MMC_CAP_NEED_RSP_BUSY.

Reported-by: Bitan Biswas <bbiswas@nvidia.com>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-By: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 403ac44a7378..a25c3a4d3f6c 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1552,6 +1552,9 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 	if (tegra_host->soc_data->nvquirks & NVQUIRK_ENABLE_DDR50)
 		host->mmc->caps |= MMC_CAP_1_8V_DDR;
 
+	/* R1B responses is required to properly manage HW busy detection. */
+	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	tegra_sdhci_parse_dt(host);
 
 	tegra_host->power_gpio = devm_gpiod_get_optional(&pdev->dev, "power",

