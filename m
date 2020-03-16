Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9879F186A16
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgCPLb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:31:58 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60675 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730801AbgCPLb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:31:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8A20980F;
        Mon, 16 Mar 2020 07:31:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QWPOvs
        8Gtxu5qhuZtLIWZ9sVYgX27VyxUA4YTzkfxVU=; b=LKa9tAs8G8AuCK40XQgH1t
        45PTFsyA118R8Ha/e9N8IR0IOVXzNiPVYkYHsZ6bUnlJ+B36xRK+Ub/5lPq5SwYA
        z/IaIEA1QEoO9+9lWHw63tmQLjlXJQhuBYt/sYTSMd3ygFq1WcooDXWFFGL0TtiD
        SrEEuL6jWW04+M8wv5auGWISGb0no3qi/VuwXReuc6TCj547T0ozb18yD/AALzAJ
        qNDou5/7z97Tqf+JOVjLA9Hic8n6sWIRZP6o1P1qoumdZXVkJX0J5TyUHu/HTwr6
        ltQ/EEBEnrftO6adFBb6Wh++yvtYVlko/WqIlZimoLcG3K+WiNN17RVD6nblM8mg
        ==
X-ME-Sender: <xms:rWNvXk049K2CGM997DWG2rGngYpc6jnECZaS6KxphHrgGLgQFRe7gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeegne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rWNvXjUcssl0_qh7iFNokGu8gse52zPlcmycIEzax_FDznEKg7_Vsw>
    <xmx:rWNvXn6NtJ5Ta8dWYOcynaXSJaRG076onUBjo_uI_ym05oyknBWWIQ>
    <xmx:rWNvXiJ8Jo1DvyzrOPa9r9JwZfhRMO7S6KpEpqNLPSHxIOm74GKXng>
    <xmx:rWNvXmEYdoUrfL-ZHHvD7639Y7ONDw5FC5_ek5Z-Rqekba8Ymtx3iQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3A7B30618C1;
        Mon, 16 Mar 2020 07:31:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci-omap: Fix busy detection by enabling" failed to apply to 5.4-stable tree
To:     ulf.hansson@linaro.org, anders.roxell@linaro.org,
        faiz_abbas@ti.com, naresh.kamboju@linaro.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:31:47 +0100
Message-ID: <158435830716852@kroah.com>
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

From 055e04830d4544c57f2a5192a26c9e25915c29c0 Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 10 Mar 2020 15:05:02 +0100
Subject: [PATCH] mmc: sdhci-omap: Fix busy detection by enabling
 MMC_CAP_NEED_RSP_BUSY

It has turned out that the sdhci-omap controller requires the R1B response,
for commands that has this response associated with them. So, converting
from an R1B to an R1 response for a CMD6 for example, leads to problems
with the HW busy detection support.

Fix this by informing the mmc core about the requirement, via setting the
host cap, MMC_CAP_NEED_RSP_BUSY.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Reported-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: <stable@vger.kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 882053151a47..c4978177ef88 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1192,6 +1192,9 @@ static int sdhci_omap_probe(struct platform_device *pdev)
 	if (of_find_property(dev->of_node, "dmas", NULL))
 		sdhci_switch_external_dma(host, true);
 
+	/* R1B responses is required to properly manage HW busy detection. */
+	mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	ret = sdhci_setup_host(host);
 	if (ret)
 		goto err_put_sync;

