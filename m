Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6A333B535
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhCONxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhCONxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3928964EEC;
        Mon, 15 Mar 2021 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816394;
        bh=dMn7XsKtA1xK+QI9+vobxM8LkEqT1GfUZUUKSTSHkMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQriiOvVDmxj3fG9O93wYf9otBkYtyRcBb0kNVSXIZkaFrxKJ1sTTjuedxwXOFy7v
         Tu0iBl9/KpYW7T9Dybdgw+4BnMMpsWeKNwxXWB9YJQG57SOsg0jgF/sS00wi+Cv5d9
         4lSpzusxY26NPTXDmSlxxq4ilLwvdhbcm7gw+nHY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/75] mmc: mxs-mmc: Fix a resource leak in an error handling path in mxs_mmc_probe()
Date:   Mon, 15 Mar 2021 14:51:33 +0100
Message-Id: <20210315135208.881886983@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0bb7e560f821c7770973a94e346654c4bdccd42c ]

If 'mmc_of_parse()' fails, we must undo the previous 'dma_request_chan()'
call.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201208203527.49262-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxs-mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index c8b8ac66ff7e..687fd68fbbcd 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -651,7 +651,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto out_clk_disable;
+		goto out_free_dma;
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-- 
2.30.1



