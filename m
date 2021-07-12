Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931E63C489C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhGLGkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236883AbhGLGh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF37610CC;
        Mon, 12 Jul 2021 06:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071645;
        bh=XfvWU0UloXk9czUVI1GErEJUmqIoEjk1o7MmrbHOmdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYXAJhIps7c3AY3A6Nu8F+JGv1bSDb+DfFzCCBAcIj49AZeQzTdL8IuOV/HXBA+ix
         nOBrJBSMMbB07vNEkrUU9wiJF8Yc9+v0DAcZuKiS+oRMVLcZ6p4T9tf4OiibKEXALe
         k5g2KNWrOGCytP77ZftM+Mio86zrObj7a5xYWL9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Fang <f.fangjian@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/593] spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()
Date:   Mon, 12 Jul 2021 08:04:35 +0200
Message-Id: <20210712060855.818405093@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



