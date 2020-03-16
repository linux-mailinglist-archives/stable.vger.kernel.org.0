Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6304186A15
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgCPLbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:31:50 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54621 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730698AbgCPLbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:31:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id F14B5808;
        Mon, 16 Mar 2020 07:31:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Zwp+8b
        HFZ/iK+Qp/afJN1odyszKtxzaZkpROsvOu/gc=; b=vgGKkoHI225r4HUvDqRPPE
        D+wvll/FK+UNJcjdZkDlhUxVQjNzinsYj5Db91n2WXYDB5Nq/Yw8kaOcYar1sIYl
        kn5+NVqC0M6MY6+YV1YuEy16JtEesbG7odRzXeIgfhhpQqWM6+U46M6MFGmo0LoQ
        OLrxPL49zKSMLf70Nivhv0/jtj1hjvy/i6CJGi46EvANxJ3SJ/falw6lY//SE14N
        XQZv88dXgYwtsMCOcQDtWVCjfHPusdyCERlwfyK8W/e5CmpFop6c/Ck4tYKQkGyn
        ir4Uvp1zQIXTK0/oYC/C/phKfHhGcBnB0kxgV3qOpjy4xT8KpGkyOn2n2emXTpRQ
        ==
X-ME-Sender: <xms:pGNvXjB300pSv2FPyxujEtYiRLmvmu1rzrBsaQWhVpgUJ17vjQ0Ohg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pGNvXqhVFzOWfIJqt0mQBzUlepAOj9NSabOpdx3EPK9-kz7km7cweg>
    <xmx:pGNvXjcY62Aj39cVb9tnqQqio4fmKNNOhwN4H4QNL6GqtPg0IanW8A>
    <xmx:pGNvXtc4rMqvatc69JhD3InrBBUyCGL1SG9L60KG0DWvpAS3LoywpA>
    <xmx:pGNvXi8_gtXVSiro3go2XUJp8dRy31qpRWGC458ncKmNxYm1YU0DtA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37D7430618C1;
        Mon, 16 Mar 2020 07:31:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci-omap: Fix busy detection by enabling" failed to apply to 5.5-stable tree
To:     ulf.hansson@linaro.org, anders.roxell@linaro.org,
        faiz_abbas@ti.com, naresh.kamboju@linaro.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:31:47 +0100
Message-ID: <158435830785159@kroah.com>
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

