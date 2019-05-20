Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7374A23455
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389176AbfETMZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388481AbfETMZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 464F421479;
        Mon, 20 May 2019 12:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355148;
        bh=mKAMmo5lwnwFG02xpzRZChvX/xc2kbA2BzCwLAZ1sE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cg4DpkGZKzi30AuWvFTsXf+aRDMZsSHjcdjRrefXnftf6AcDE3c+cxpUoYvIrWYsX
         IMEo72Ruh5cZNeZbWT7JCMtYmdQZlrDRFHl6lJyiC65NxjVMy2GpoMzQZOQOpWAaqd
         1/HYejP9BvAXylB3t9eKlOIaKrMu1IVo5RKcn9+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Muellner <christoph.muellner@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.0 010/123] mmc: sdhci-of-arasan: Add DTS property to disable DCMDs.
Date:   Mon, 20 May 2019 14:13:10 +0200
Message-Id: <20190520115245.860637408@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Muellner <christoph.muellner@theobroma-systems.com>

commit 7bda9482e7ed4d27d83c1f9cb5cbe3b34ddac3e8 upstream.

Direct commands (DCMDs) are an optional feature of eMMC 5.1's command
queue engine (CQE). The Arasan eMMC 5.1 controller uses the CQHCI,
which exposes a control register bit to enable the feature.
The current implementation sets this bit unconditionally.

This patch allows to suppress the feature activation,
by specifying the property disable-cqe-dcmd.

Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-arasan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -832,7 +832,10 @@ static int sdhci_arasan_probe(struct pla
 		host->mmc_host_ops.start_signal_voltage_switch =
 					sdhci_arasan_voltage_switch;
 		sdhci_arasan->has_cqe = true;
-		host->mmc->caps2 |= MMC_CAP2_CQE | MMC_CAP2_CQE_DCMD;
+		host->mmc->caps2 |= MMC_CAP2_CQE;
+
+		if (!of_property_read_bool(np, "disable-cqe-dcmd"))
+			host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
 	}
 
 	ret = sdhci_arasan_add_host(sdhci_arasan);


