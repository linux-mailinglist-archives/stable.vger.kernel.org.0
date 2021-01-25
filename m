Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DAB304AB2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbhAZE6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbhAYSth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5662067B;
        Mon, 25 Jan 2021 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600561;
        bh=yar+POTz+vhoeHEmu5w/G1nxdxiXk1bIOlmBumyjAAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFq6HCzbniZZdl5QXokVJhC05+JCa4AM6e4xeNCjQG+nNnq6evPdjgbgZOMqIm/XK
         jIdpepFokE6Qpe2EGocPY0m4MF2K0rk5bkYV6xkRuA5Jbxyes/+eupbbiprkXg5V+H
         yjM1Bx5CTxO8z6nN44LgTD+By9ObLLx7Gfit3uQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 022/199] mmc: sdhci-of-dwcmshc: fix rpmb access
Date:   Mon, 25 Jan 2021 19:37:24 +0100
Message-Id: <20210125183217.192901843@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit ca1219c0a7432272324660fc9f61a9940f90c50b upstream.

Commit a44f7cb93732 ("mmc: core: use mrq->sbc when sending CMD23 for
RPMB") began to use ACMD23 for RPMB if the host supports ACMD23. In
RPMB ACM23 case, we need to set bit 31 to CMD23 argument, otherwise
RPMB write operation will return general fail.

However, no matter V4 is enabled or not, the dwcmshc's ARGUMENT2
register is 32-bit block count register which doesn't support stuff
bits of CMD23 argument. So let's handle this specific ACMD23 case.

>From another side, this patch also prepare for future v4 enabling
for dwcmshc, because from the 4.10 spec, the ARGUMENT2 register is
redefined as 32bit block count which doesn't support stuff bits of
CMD23 argument.

Fixes: a44f7cb93732 ("mmc: core: use mrq->sbc when sending CMD23 for RPMB")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201229161625.38255233@xhacker.debian
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -16,6 +16,8 @@
 
 #include "sdhci-pltfm.h"
 
+#define SDHCI_DWCMSHC_ARG2_STUFF	GENMASK(31, 16)
+
 /* DWCMSHC specific Mode Select value */
 #define DWCMSHC_CTRL_HS400		0x7
 
@@ -49,6 +51,29 @@ static void dwcmshc_adma_write_desc(stru
 	sdhci_adma_write_desc(host, desc, addr, len, cmd);
 }
 
+static void dwcmshc_check_auto_cmd23(struct mmc_host *mmc,
+				     struct mmc_request *mrq)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+
+	/*
+	 * No matter V4 is enabled or not, ARGUMENT2 register is 32-bit
+	 * block count register which doesn't support stuff bits of
+	 * CMD23 argument on dwcmsch host controller.
+	 */
+	if (mrq->sbc && (mrq->sbc->arg & SDHCI_DWCMSHC_ARG2_STUFF))
+		host->flags &= ~SDHCI_AUTO_CMD23;
+	else
+		host->flags |= SDHCI_AUTO_CMD23;
+}
+
+static void dwcmshc_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	dwcmshc_check_auto_cmd23(mmc, mrq);
+
+	sdhci_request(mmc, mrq);
+}
+
 static void dwcmshc_set_uhs_signaling(struct sdhci_host *host,
 				      unsigned int timing)
 {
@@ -133,6 +158,8 @@ static int dwcmshc_probe(struct platform
 
 	sdhci_get_of_property(pdev);
 
+	host->mmc_host_ops.request = dwcmshc_request;
+
 	err = sdhci_add_host(host);
 	if (err)
 		goto err_clk;


