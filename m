Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A611C450E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgEDSDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731426AbgEDSDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D16E2073E;
        Mon,  4 May 2020 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615384;
        bh=m0NOQkhaDLLWHMFRUMofd+9PQkdwLZpGR0kbkLzWY9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHTTa15tkVhTawOhmrl2a+8R6gbMCeav2nTtMN2V9LF0J+v/Gtys+Wsm4JfHLV0hb
         TNGcP0E5mooI0xNAfgK81l6/SCcmQ6gaB628ny8gGBWh2OtF0E2rKQxRMOkj9dqHDy
         7mZ1CFyaHGcn60weHeeB//mR0awEN4/ya7KA6X94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 17/57] mmc: meson-mx-sdio: remove the broken ->card_busy() op
Date:   Mon,  4 May 2020 19:57:21 +0200
Message-Id: <20200504165457.896543710@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit ddca1092c4324c89cf692b5efe655aa251864b51 upstream.

The recent commit 0d84c3e6a5b2 ("mmc: core: Convert to
mmc_poll_for_busy() for erase/trim/discard") makes use of the
->card_busy() op for SD cards. This uncovered that the ->card_busy() op
in the Meson SDIO driver was never working right:
while polling the busy status with ->card_busy()
meson_mx_mmc_card_busy() reads only one of the two MESON_MX_SDIO_IRQC
register values 0x1f001f10 or 0x1f003f10. This translates to "three out
of four DAT lines are HIGH" and "all four DAT lines are HIGH", which
is interpreted as "the card is busy".

It turns out that no situation can be observed where all four DAT lines
are LOW, meaning the card is not busy anymore. Upon further research the
3.10 vendor driver for this controller does not implement the
->card_busy() op.

Remove the ->card_busy() op from the meson-mx-sdio driver since it is
not working. At the time of writing this patch it is not clear what's
needed to make the ->card_busy() implementation work with this specific
controller hardware. For all use-cases which have previously worked the
MMC_CAP_WAIT_WHILE_BUSY flag is now taking over, even if we don't have
a ->card_busy() op anymore.

Fixes: ed80a13bb4c4c9 ("mmc: meson-mx-sdio: Add a driver for the Amlogic Meson8 and Meson8b SoCs")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200416183513.993763-3-martin.blumenstingl@googlemail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/meson-mx-sdio.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/mmc/host/meson-mx-sdio.c
+++ b/drivers/mmc/host/meson-mx-sdio.c
@@ -357,14 +357,6 @@ static void meson_mx_mmc_request(struct
 		meson_mx_mmc_start_cmd(mmc, mrq->cmd);
 }
 
-static int meson_mx_mmc_card_busy(struct mmc_host *mmc)
-{
-	struct meson_mx_mmc_host *host = mmc_priv(mmc);
-	u32 irqc = readl(host->base + MESON_MX_SDIO_IRQC);
-
-	return !!(irqc & MESON_MX_SDIO_IRQC_FORCE_DATA_DAT_MASK);
-}
-
 static void meson_mx_mmc_read_response(struct mmc_host *mmc,
 				       struct mmc_command *cmd)
 {
@@ -506,7 +498,6 @@ static void meson_mx_mmc_timeout(struct
 static struct mmc_host_ops meson_mx_mmc_ops = {
 	.request		= meson_mx_mmc_request,
 	.set_ios		= meson_mx_mmc_set_ios,
-	.card_busy		= meson_mx_mmc_card_busy,
 	.get_cd			= mmc_gpio_get_cd,
 	.get_ro			= mmc_gpio_get_ro,
 };


