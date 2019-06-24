Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A325081B
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfFXKEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbfFXKE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:29 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5DD205ED;
        Mon, 24 Jun 2019 10:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370668;
        bh=eXUgI4O6QoYCbIFoByqbhrudnIe63+NDqbKQVSLvN9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6XFVAGORZCru+NBlnUUMwFYNGjvLoG0t5XnfdqpfmwCXDGJJKy3Y4fSKEZtevac3
         RXwqBFvJRGu5Yj4oo+JadOah9StJJMbNuFhEzKWL3LtvJFP9e+MMXGnfj3yHM198J+
         h3btbXnr0BGX3zBb09+V363piCii6u9Cz4U4wRZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 12/90] mmc: sdhci: sdhci-pci-o2micro: Correctly set bus width when tuning
Date:   Mon, 24 Jun 2019 17:56:02 +0800
Message-Id: <20190624092314.811321051@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

commit 0f7b79a44e7d7dd3ef1f59758c1a341f217ff5e5 upstream.

The O2Micro controller only supports tuning at 4-bits. So the host driver
needs to change the bus width while tuning and then set it back when done.

There was a bug in the original implementation in that mmc->ios.bus_width
also wasn't updated. Thus setting the incorrect blocksize in
sdhci_send_tuning which results in a tuning failure.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Fixes: 0086fc217d5d7 ("mmc: sdhci: Add support for O2 hardware tuning")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-o2micro.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -117,6 +117,7 @@ static int sdhci_o2_execute_tuning(struc
 	 */
 	if (mmc->ios.bus_width == MMC_BUS_WIDTH_8) {
 		current_bus_width = mmc->ios.bus_width;
+		mmc->ios.bus_width = MMC_BUS_WIDTH_4;
 		sdhci_set_bus_width(host, MMC_BUS_WIDTH_4);
 	}
 
@@ -128,8 +129,10 @@ static int sdhci_o2_execute_tuning(struc
 
 	sdhci_end_tuning(host);
 
-	if (current_bus_width == MMC_BUS_WIDTH_8)
+	if (current_bus_width == MMC_BUS_WIDTH_8) {
+		mmc->ios.bus_width = MMC_BUS_WIDTH_8;
 		sdhci_set_bus_width(host, current_bus_width);
+	}
 
 	host->flags &= ~SDHCI_HS400_TUNING;
 	return 0;


