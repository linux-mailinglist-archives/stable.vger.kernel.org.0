Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF23BB310
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhGDXRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhGDXOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F37A613E5;
        Sun,  4 Jul 2021 23:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440251;
        bh=laX2QUMgM33K5uDB4opxgdizQO9drAjH4BCEMzCb5LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zq+CjwtKtDS4DCuKEjqqnU2KPl+3GynppTft49ll0HFiNsLTLGIXJIgTUsewsHLqF
         rYRz6KcC67RmvU0QqKf0rrzQ488f25Wx9/TtaUL67aOoyxOqoG67Zt+1kKwTkbw3u6
         333cMuy0N44tFS+bKlGP7S48m3kSQBdmwtR8aGD9LmQSwbvFwlYotNVKrY7Ga+nLLA
         zA7oFj+0VwL4pJTiVSyi2eM/cVuAB3pgTkYn9YjLhcqkt1mtYn1QJqmmErkbViP0TT
         r547DU/Ud4mQKIefVDWK2+lrC08ohMHQNpiRkyza95lKKwXqfuwKBFutZ8niLQjeMU
         iYhEQ7odk43Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/31] spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()
Date:   Sun,  4 Jul 2021 19:10:18 -0400
Message-Id: <20210704231043.1491209-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index 8a5966963834..ef19e050612c 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -584,8 +584,10 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
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

