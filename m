Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4590F3BB34D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhGDXRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234363AbhGDXPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E10613F3;
        Sun,  4 Jul 2021 23:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440344;
        bh=dOBmBQ+bXovITBVioBLH4/bROOrJQHliTPrYuifb34w=;
        h=From:To:Cc:Subject:Date:From;
        b=W+MGEs7qUG34nZRBz2k1xBEMCnUQYrD0ubHFOm9hOwevG34u/wYjohxl5yvkDxZIm
         ScbfFvo+mag+kIAR7ZRYbQqLDJVbMihHYqjq/vKdEMGl/a9RueEy0td2Z45Uwdhai0
         CofauDhuvd18Z+vwXOJg3xQPIfQs4OGYHEODIuTwz7PND2K1Txb2f7QJE2c6sfkxsh
         bolm69srnQXTGRIo1ZwWUVHvlRQDn0GQJ8VLlc2VyLHTcKipDFYCI9hVaEX3If7Cls
         YuVxVWSkvpgPxFcCHBP2qAzNY9n/A5RAKsekXulzhcc0ANTroJjwnMw76jtZ85M1ub
         So9IucTzEl/kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/15] spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()
Date:   Sun,  4 Jul 2021 19:12:07 -0400
Message-Id: <20210704231222.1492037-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Fang <f.fangjian@huawei.com>

[ Upstream commit 026a1dc1af52742c5897e64a3431445371a71871 ]

pch_spi_set_tx() frees data->pkt_tx_buff on failure of kzalloc() for
data->pkt_rx_buff, but its caller, pch_spi_process_messages(), will
free data->pkt_tx_buff again. Set data->pkt_tx_buff to NULL after
kfree() to avoid double free.

Signed-off-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/1620284888-65215-1-git-send-email-f.fangjian@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-topcliff-pch.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 9f30a4ab2004..66c170e799fc 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -589,8 +589,10 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 	data->pkt_tx_buff = kzalloc(size, GFP_KERNEL);
 	if (data->pkt_tx_buff != NULL) {
 		data->pkt_rx_buff = kzalloc(size, GFP_KERNEL);
-		if (!data->pkt_rx_buff)
+		if (!data->pkt_rx_buff) {
 			kfree(data->pkt_tx_buff);
+			data->pkt_tx_buff = NULL;
+		}
 	}
 
 	if (!data->pkt_rx_buff) {
-- 
2.30.2

