Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2072B3286CD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbhCARPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234521AbhCARI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7306500C;
        Mon,  1 Mar 2021 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616906;
        bh=YWR598s9ftPyqMyDa+kVCJIElHUyK4weZXeEz4cVrWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQrl6wgj4DGxur6BBgZt/xKgrOdau1uEDwP/c5p0VbEJwNSol84dPfWjJuRl/ehk1
         AVvQWrgF8YgCp9b0jucyphAO/MhaJgX5d5NSBVJb1zAMciQ3p/ZwwpHzZwvVSESdkJ
         9+jnYWwUNmwsd0Abu790MW/3aA15Q/J5CUc1A2P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/247] mmc: renesas_sdhi_internal_dmac: Fix DMA buffer alignment from 8 to 128-bytes
Date:   Mon,  1 Mar 2021 17:12:36 +0100
Message-Id: <20210301161038.328278383@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Saito <takeshi.saito.xv@renesas.com>

[ Upstream commit d7aefb2887601cf1fc3f86f55d43b2c9aece5e8f ]

According to the latest datasheet, the internal DMAC buffer alignment
R-Car Gen3 SDHI HW should be 128-bytes. So, fix it.

Signed-off-by: Takeshi Saito <takeshi.saito.xv@renesas.com>
[shimoda: revise commit description, rebase]
Fixes: 2a68ea7896e3 ("mmc: renesas-sdhi: add support for R-Car Gen3 SDHI DMAC")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/1608114572-1892-2-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 74eea8247490d..6e2685c9e9cb5 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -180,8 +180,8 @@ renesas_sdhi_internal_dmac_start_dma(struct tmio_mmc_host *host,
 			mmc_get_dma_dir(data)))
 		goto force_pio;
 
-	/* This DMAC cannot handle if buffer is not 8-bytes alignment */
-	if (!IS_ALIGNED(sg_dma_address(sg), 8))
+	/* This DMAC cannot handle if buffer is not 128-bytes alignment */
+	if (!IS_ALIGNED(sg_dma_address(sg), 128))
 		goto force_pio_with_unmap;
 
 	if (data->flags & MMC_DATA_READ) {
-- 
2.27.0



