Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B013A18B703
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgCSNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbgCSNUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 997CA20724;
        Thu, 19 Mar 2020 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624019;
        bh=mNEs1+4xD8aDv52fOUVhufV2W+80jU2ONFX0wpQFf/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04iIezgcXXKTkRsyAzm4O0zKvoHZKsD1WXD8dsNBWZcKw3CmiyNRgWc0CH/svdb9O
         nqX3PyD5ewi2nJUN3zakAD/KQoQR7hrpS88XRtw/OE3z2RCS44CyiM+dma5Hb+O++Y
         xCEE0wAFn2RmrSCfn6FOSff2ID/CuplFXmMsIuU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Borislav Petkov <bp@suse.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/48] mmc: host: Fix Kconfig warnings on keystone_defconfig
Date:   Thu, 19 Mar 2020 14:03:47 +0100
Message-Id: <20200319123904.797207216@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 287b1da6a458a30da2e5be745498d31092ebb001 ]

Commit 961de0a856e3 ("mmc: sdhci-omap: Workaround errata regarding
SDR104/HS200 tuning failures (i929)") added a select on TI_SOC_THERMAL
for the driver to get temperature for tuning.

However, this causes the following warning on keystone_defconfig because
keystone does not support TI_SOC_THERMAL:

"WARNING: unmet direct dependencies detected for TI_SOC_THERMAL"

Fix this by changing the select to imply.

Fixes: 961de0a856e3 ("mmc: sdhci-omap: Workaround errata regarding
SDR104/HS200 tuning failures (i929)")
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Tested-by: Borislav Petkov <bp@suse.de>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 79b8ac9cdc744..b7f809aa40c2c 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -936,7 +936,7 @@ config MMC_SDHCI_OMAP
 	tristate "TI SDHCI Controller Support"
 	depends on MMC_SDHCI_PLTFM && OF
 	select THERMAL
-	select TI_SOC_THERMAL
+	imply TI_SOC_THERMAL
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  support present in TI's DRA7 SOCs. The controller supports
-- 
2.20.1



