Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7F30337A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbhAZEyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:54:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730837AbhAYSsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FDFF2063A;
        Mon, 25 Jan 2021 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600507;
        bh=nIMReitFDPKoV2KJphe6j4zD/0wHrTy1EqDsoCywc/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2vwk4NXk0Uq2mPUnWMrQza5n2JurdvGkJNMcVTQYklCii+5MkO4FQ2TG4dsrjfKG
         CpSYVeEsIyaZMAWlu6huXD3ApYx0oUCg9EclzqNXvS3EZezySun4QdT6w+cBLFskSz
         K33DJKz3LOh2PD82TDakXv7QO4/mq87r6iffvMqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 024/199] mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend
Date:   Mon, 25 Jan 2021 19:37:26 +0100
Message-Id: <20210125183217.271928907@linuxfoundation.org>
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

From: Al Cooper <alcooperx@gmail.com>

commit 5b191dcba719319148eeecf6ed409949fac55b39 upstream.

Commit e7b5d63a82fe ("mmc: sdhci-brcmstb: Add shutdown callback")
that added a shutdown callback to the diver, is causing "mmc timeout"
errors on S5 suspend. The problem was that the "remove" was queuing
additional MMC commands after the "shutdown" and these caused
timeouts as the MMC queues were cleaned up for "remove". The
shutdown callback will be changed to calling sdhci-pltfm_suspend
which should get better power savings because the clocks will be
shutdown.

Fixes: e7b5d63a82fe ("mmc: sdhci-brcmstb: Add shutdown callback")
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210107221509.6597-1-alcooperx@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-brcmstb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -314,11 +314,7 @@ err_clk:
 
 static void sdhci_brcmstb_shutdown(struct platform_device *pdev)
 {
-	int ret;
-
-	ret = sdhci_pltfm_unregister(pdev);
-	if (ret)
-		dev_err(&pdev->dev, "failed to shutdown\n");
+	sdhci_pltfm_suspend(&pdev->dev);
 }
 
 MODULE_DEVICE_TABLE(of, sdhci_brcm_of_match);


