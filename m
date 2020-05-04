Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786801C43E2
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgEDSCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731315AbgEDSCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53167206B8;
        Mon,  4 May 2020 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615340;
        bh=Bj1E5/3UsUGDMcOAQK6uor3oP4xH+/iETM/gr4OMax4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2F283gC3C0eRRtrI6pbLBFHEH/JZnKLUHP8dCYMgW+6g96gGFUDtPrnf7Tzscb7w
         I6JKgd2JUEnekgcgHU+O/iM8Y2rE/9wFwuU+BP1ODh4v/r3KtMspQ5lbuXMt7Jl/0d
         FdD/HF3TSDnm8R3INoemLc3Wmviqvjbh7owiW8Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 36/37] mmc: meson-mx-sdio: Set MMC_CAP_WAIT_WHILE_BUSY
Date:   Mon,  4 May 2020 19:57:49 +0200
Message-Id: <20200504165451.960863147@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit e53b868b3cf5beeaa2f851ec6740112bf4d6a8cb upstream.

The Meson SDIO controller uses the DAT0 lane for hardware busy
detection. Set MMC_CAP_WAIT_WHILE_BUSY accordingly. This fixes
the following error observed with Linux 5.7 (pre-rc-1):
  mmc1: Card stuck being busy! __mmc_poll_for_busy
  blk_update_request: I/O error, dev mmcblk1, sector 17111080 op
   0x3:(DISCARD) flags 0x0 phys_seg 1 prio class 0

Fixes: ed80a13bb4c4c9 ("mmc: meson-mx-sdio: Add a driver for the Amlogic Meson8 and Meson8b SoCs")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200416183513.993763-2-martin.blumenstingl@googlemail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/meson-mx-sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-mx-sdio.c
+++ b/drivers/mmc/host/meson-mx-sdio.c
@@ -573,7 +573,7 @@ static int meson_mx_mmc_add_host(struct
 	mmc->f_max = clk_round_rate(host->cfg_div_clk,
 				    clk_get_rate(host->parent_clk));
 
-	mmc->caps |= MMC_CAP_ERASE | MMC_CAP_CMD23;
+	mmc->caps |= MMC_CAP_ERASE | MMC_CAP_CMD23 | MMC_CAP_WAIT_WHILE_BUSY;
 	mmc->ops = &meson_mx_mmc_ops;
 
 	ret = mmc_of_parse(mmc);


