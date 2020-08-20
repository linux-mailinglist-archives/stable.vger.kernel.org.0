Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5104C24BBCC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgHTMeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbgHTJsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC6422D6E;
        Thu, 20 Aug 2020 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916932;
        bh=ENiqpdrP0F6yjrEXZFstOmJSl0BgjFvhgs+/PdwbxjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzQY3NvwjYdmVlTppPwVJNqmArc2LbQM4RfAmXW/U5D5ksnSJVRHWGyzC4lNz/ZvP
         7RBq0U6SsXCn514lasaRfN5ULDSNs4dG6jNQwE3dfD+F2t9gPqACZK3MWj+mS8vrem
         dy4uWTwk65V1GdNDF1obTWCyGVR8PxHvThZ0n/lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/152] mmc: renesas_sdhi_internal_dmac: clean up the code for dma complete
Date:   Thu, 20 Aug 2020 11:21:03 +0200
Message-Id: <20200820091558.676450266@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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
index a66f8d6d61d1b..cb89f0578d425 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -229,15 +229,12 @@ static void renesas_sdhi_internal_dmac_issue_tasklet_fn(unsigned long arg)
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
@@ -250,6 +247,17 @@ static void renesas_sdhi_internal_dmac_complete_tasklet_fn(unsigned long arg)
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



