Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC1E1C43E0
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbgEDSCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731306AbgEDSCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD5920707;
        Mon,  4 May 2020 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615338;
        bh=OfM4L/DSXzomjs6joc4qF0cINSrNJaXOJcZUMqDCA5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dl/FwMbYadvN7ZSOdrBetb/e5iy3xMvzIbo1UNv6RzfHKry8SPbujQiKZZMthTShB
         seiUjUNFX1Ne15kCLpSESSrZv/W6y9VeJi2kT0SUPi6jUilv8t+qAU1hVekkM9pxcY
         /FgAJk57BJ2La5PC46xjzLHS2fhUTUpIJF4Bzi+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 35/37] mmc: sdhci-msm: Enable host capabilities pertains to R1b response
Date:   Mon,  4 May 2020 19:57:48 +0200
Message-Id: <20200504165451.839824034@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>

commit 9d8cb58691f85cef687512262acb2c7109ee4868 upstream.

MSM sd host controller is capable of HW busy detection of device busy
signaling over DAT0 line. And it requires the R1B response for commands
that have this response associated with them.

So set the below two host capabilities for qcom SDHC.
 - MMC_CAP_WAIT_WHILE_BUSY
 - MMC_CAP_NEED_RSP_BUSY

Recent development of the mmc core in regards to this, revealed this as
being a potential bug, hence the stable tag.

Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1587363626-20413-2-git-send-email-vbadigan@codeaurora.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-msm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1909,6 +1909,8 @@ static int sdhci_msm_probe(struct platfo
 		goto clk_disable;
 	}
 
+	msm_host->mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY | MMC_CAP_NEED_RSP_BUSY;
+
 	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);


