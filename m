Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2C186A1B
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgCPLca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:32:30 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55019 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730759AbgCPLc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:32:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id BE29F7D3;
        Mon, 16 Mar 2020 07:32:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xVX5tm
        txg/tgHQBlDq+Ax6ajxu+QDBhq5VXnpPmdJZg=; b=Czhu/CpJWpRlaStGmuSe1I
        hLf+jL5WvdYQgP24q30bFZnK/UU9oXBLKdURrAuKHIS7DuD3K9fdgV4royQhWSsf
        TL2AoKCk6S/GhhWefqi/makQGdDDjtO+9PHeQAHvWgqtO3Lgf5ndAX/kvrfh1qVf
        Rh2+GNdCbzqY00k317uCtRVRxzk0tNW4B7iY6GswJnugTrZ4fqdn5PeaD76+Z5ek
        yUV/dfyc4GJyPt0lbFaRm+F5pKxbbkuqup13MtYylYJYdGdLQQ+St9eIunYHAxMs
        5qxhn8SBOiwu/H6W7ZQOOT/0KE7WXeR52GI3ubsex3sany/gg9JEo35bwIX8uaFg
        ==
X-ME-Sender: <xms:zGNvXszM0ZKQhiTbJutLUTs_tYSqCdT9dm0PyhNld_4IDzEEsBvxAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeejne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zGNvXrsslX9rSZXmlKAkOR8No4YCj5_8jsNIQg-5GzRQyZlaPDEMjw>
    <xmx:zGNvXh6jsI9LXfk-xzL6YSn3ktAEvwn-6f7uJZK8LB13R68rNCzA6g>
    <xmx:zGNvXjiHcRcuJWfgYmo0VZZkU_klBwuIOlH-FcEnlxkfMLZgdMKf7A>
    <xmx:zGNvXobeBrsiuYlFPUh7GlZ1jQU3p1cIbrE4JjNS187IiGt6npOjUw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08501328005D;
        Mon, 16 Mar 2020 07:32:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci-tegra: Fix busy detection by enabling" failed to apply to 5.4-stable tree
To:     ulf.hansson@linaro.org, bbiswas@nvidia.com, pgwipeout@gmail.com,
        skomatineni@nvidia.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:32:17 +0100
Message-ID: <1584358337148226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

