Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD24814B892
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgA1OZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgA1OZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674822071E;
        Tue, 28 Jan 2020 14:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221502;
        bh=RoZ81vHe5oOwSF4DrAOn7tSXN8FoDE6hUlYToDbbnkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pykOWZBrIIj5YjmYBOik1Q+ulvJqKl6cvccVEQpYovxv9q5jc1oX5CpX5akmd5ncD
         A3yp3ub1Hm+dA3R1B5K0IWL0xdFuBmLVKCqgl8X3UnogQpcZreWHbhjEiqwUG9wKSm
         Wu2JRZ40pAhYaO4LwR/+2DlliOJScuko/6KSbW5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 250/271] mmc: tegra: fix SDR50 tuning override
Date:   Tue, 28 Jan 2020 15:06:39 +0100
Message-Id: <20200128135911.176417016@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit f571389c0b015e76f91c697c4c1700aba860d34f upstream.

Commit 7ad2ed1dfcbe inadvertently mixed up a quirk flag's name and
broke SDR50 tuning override. Use correct NVQUIRK_ name.

Fixes: 7ad2ed1dfcbe ("mmc: tegra: enable UHS-I modes")
Cc: <stable@vger.kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Tested-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/9aff1d859935e59edd81e4939e40d6c55e0b55f6.1578390388.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -174,7 +174,7 @@ static void tegra_sdhci_reset(struct sdh
 			misc_ctrl |= SDHCI_MISC_CTRL_ENABLE_DDR50;
 		if (soc_data->nvquirks & NVQUIRK_ENABLE_SDR104)
 			misc_ctrl |= SDHCI_MISC_CTRL_ENABLE_SDR104;
-		if (soc_data->nvquirks & SDHCI_MISC_CTRL_ENABLE_SDR50)
+		if (soc_data->nvquirks & NVQUIRK_ENABLE_SDR50)
 			clk_ctrl |= SDHCI_CLOCK_CTRL_SDR50_TUNING_OVERRIDE;
 	}
 


