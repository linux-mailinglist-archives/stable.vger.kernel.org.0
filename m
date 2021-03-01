Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A473286C9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhCARO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhCARI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B45886500F;
        Mon,  1 Mar 2021 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616903;
        bh=s149aqb6iXt6XrArp6AMD3zXyGpQXNZHWq+ZGI8l3cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcO+Rry2TWbqLdJeGWMsp805DjQf7fpll1Sxfy3q0F1q/p/TCt/rR5+h4+ejnb/eN
         M6ovCfslreqB5GdZEFM0GggaXPN7hRuXYkQCDSiUM/Bdt+dd6ulHKOidEc/bg+zRS6
         BhP/BFVlrlacrCB1zJ3ii940G28L/L7jNokRSv8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/247] mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe
Date:   Mon,  1 Mar 2021 17:12:35 +0100
Message-Id: <20210301161038.276910649@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6052b3c370fb82dec28bcfff6d7ec0da84ac087a ]

A call to 'ausdhi6_dma_release()' to undo a previous call to
'usdhi6_dma_request()' is missing in the error handling path of the probe
function.

It is already present in the remove function.

Fixes: 75fa9ea6e3c0 ("mmc: add a driver for the Renesas usdhi6rol0 SD/SDIO host controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201217210922.165340-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/usdhi6rol0.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index cdfeb15b6f051..ef3aa8b520787 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -1866,10 +1866,12 @@ static int usdhi6_probe(struct platform_device *pdev)
 
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
-		goto e_clk_off;
+		goto e_release_dma;
 
 	return 0;
 
+e_release_dma:
+	usdhi6_dma_release(host);
 e_clk_off:
 	clk_disable_unprepare(host->clk);
 e_free_mmc:
-- 
2.27.0



