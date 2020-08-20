Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92324B3EE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgHTJyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgHTJyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:54:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B087F2067C;
        Thu, 20 Aug 2020 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917251;
        bh=+scfe+NEZbJY7EkOG84JZhcz2N/+8keGUW4mOZ8jPCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmWoh+ILhsrxB78nDFZuM8FBE2mgdpSyI7McVWDAq6E5R5iFc+FfIlIRLy2e+j0DE
         jY3hfHdHzLcuhG1cHJfgIfQ3baSGGjDcGjc/tLig/UXtZYmokrq0lqk5IgFjSmTwC7
         PhP4W56jIbJwJuQGERMk6r2a0unYzNxxt7siMiQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/92] mmc: renesas_sdhi_internal_dmac: clean up the code for dma complete
Date:   Thu, 20 Aug 2020 11:21:42 +0200
Message-Id: <20200820091540.583963283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 2b26e34e9af3fa24fa1266e9ea2d66a1f7d62dc0 ]

To add end() operation in the future, clean the code of
renesas_sdhi_internal_dmac_complete_tasklet_fn(). No behavior change.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1590044466-28372-3-git-send-email-yoshihiro.shimoda.uh@renesas.com
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 382172fb3da8f..74eea8247490d 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -222,15 +222,12 @@ static void renesas_sdhi_internal_dmac_issue_tasklet_fn(unsigned long arg)
 					    DTRAN_CTRL_DM_START);
 }
 
-static void renesas_sdhi_internal_dmac_complete_tasklet_fn(unsigned long arg)
+static bool renesas_sdhi_internal_dmac_complete(struct tmio_mmc_host *host)
 {
-	struct tmio_mmc_host *host = (struct tmio_mmc_host *)arg;
 	enum dma_data_direction dir;
 
-	spin_lock_irq(&host->lock);
-
 	if (!host->data)
-		goto out;
+		return false;
 
 	if (host->data->flags & MMC_DATA_READ)
 		dir = DMA_FROM_DEVICE;
@@ -243,6 +240,17 @@ static void renesas_sdhi_internal_dmac_complete_tasklet_fn(unsigned long arg)
 	if (dir == DMA_FROM_DEVICE)
 		clear_bit(SDHI_INTERNAL_DMAC_RX_IN_USE, &global_flags);
 
+	return true;
+}
+
+static void renesas_sdhi_internal_dmac_complete_tasklet_fn(unsigned long arg)
+{
+	struct tmio_mmc_host *host = (struct tmio_mmc_host *)arg;
+
+	spin_lock_irq(&host->lock);
+	if (!renesas_sdhi_internal_dmac_complete(host))
+		goto out;
+
 	tmio_mmc_do_data_irq(host);
 out:
 	spin_unlock_irq(&host->lock);
-- 
2.25.1



