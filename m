Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F377B3BB0E8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhGDXJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhGDXJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D7C36162A;
        Sun,  4 Jul 2021 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439999;
        bh=XfvWU0UloXk9czUVI1GErEJUmqIoEjk1o7MmrbHOmdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHpZfEZCpRAe+YzUc4z2pMOAV5XYOZUN+IkaCfugorrssOiHKQ8IAoozyOAlGfzPK
         CA+zLSfreD48icfG2gVdVtLWts6oZlnuH+rLXUfkWmHEJTTW5xBzmgZqH50amNd764
         Wy7aLlNWEThCbZlB8vCxcQ1+GuR3VPbAp18z5zFUrzoOchyQHnAhr4K2IaA9lNLJcV
         TgPrqJJm+pF9zOq/G1xKcvT+4WQTtUkE1RnsZjchYjT7k4D8uT3d+N4TXsCsVyGuw8
         bQdgBD/tlN29AbpFw7IjeU2HPkcFqRA3iE98aG2CbAevlrc/rGs+obZeyr6trGhixY
         0H83ExsW5PWtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 17/80] spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()
Date:   Sun,  4 Jul 2021 19:05:13 -0400
Message-Id: <20210704230616.1489200-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index b459e369079f..7fb020a1d66a 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -580,8 +580,10 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
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

