Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C613ED1D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbgAPSBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405750AbgAPRli (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:41:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38EC3246FC;
        Thu, 16 Jan 2020 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196498;
        bh=Fz0iwlYQb3AI2FWlTCnZlv/YpHHlg9Rxquncv+MXZsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxCE5Qv0AKWVmdjft/Bh2B0J3Fe5f4VVwjzl5i51TwQhcIjgGa28rxQ9uPUJULpta
         33S5WzLVHdpED9Kg9hBGYwpji5GPP754Brqj8RMSJ15TGKt8aLI8ckQMeF08CBBQpg
         0/8SJtX+Y1YILpWlrBI1vkxYUOLR8JcfM0Mmj270=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Fan <peng.fan@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 240/251] tty: serial: imx: use the sg count from dma_map_sg
Date:   Thu, 16 Jan 2020 12:36:29 -0500
Message-Id: <20200116173641.22137-200-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 596fd8dffb745afcebc0ec6968e17fe29f02044c ]

The dmaengine_prep_slave_sg needs to use sg count returned
by dma_map_sg, not use sport->dma_tx_nents, because the return
value of dma_map_sg is not always same with "nents".

Fixes: b4cdc8f61beb ("serial: imx: add DMA support for imx6q")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1573108875-26530-1-git-send-email-peng.fan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 6d596c635159..e75bd8d7e6f6 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -548,7 +548,7 @@ static void imx_dma_tx(struct imx_port *sport)
 		dev_err(dev, "DMA mapping error for TX.\n");
 		return;
 	}
-	desc = dmaengine_prep_slave_sg(chan, sgl, sport->dma_tx_nents,
+	desc = dmaengine_prep_slave_sg(chan, sgl, ret,
 					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dma_unmap_sg(dev, sgl, sport->dma_tx_nents,
-- 
2.20.1

