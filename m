Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E967201333
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbgFSP6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403779AbgFSPT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8107B206DB;
        Fri, 19 Jun 2020 15:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579966;
        bh=nFGjH5tzVEWgseGhypamuZgOJ+XW9VpKERelgD2AHVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQyScUctKoLhT+Yqp5ZlIglYpBdQHhKvMzulkAh6pSkTlpPf9arHW/+U3/JBtWmns
         UipBkDyVAzaZNf3jsFXCvEUwSLRcoUBzMd1oKEk3CCQQUhEp2iQa/spkFRMnb4vflf
         766lJkboJYHzmo3R+H48ogA99RhMwo2+flZGFlNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 071/376] mmc: mmci_sdmmc: fix power on issue due to pwr_reg initialization
Date:   Fri, 19 Jun 2020 16:29:49 +0200
Message-Id: <20200619141713.714680400@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Barre <ludovic.barre@st.com>

[ Upstream commit 33ba6fec0012e47f4e72bfab922b99327373f210 ]

This patch fix a power-on issue, and avoid to retry the power sequence.

In power off sequence: sdmmc must set pwr_reg in "power-cycle" state
(value 0x2), to prevent the card from being supplied through the signal
lines (all the lines are driven low).

In power on sequence: when the power is stable, sdmmc must set pwr_reg
in "power-off" state (value 0x0) to drive all signal to high before to
set "power-on".

To avoid writing the same value to the power register several times, this
register is cached by the pwr_reg variable. At probe pwr_reg is initialized
to 0 by kzalloc of mmc_alloc_host.

Like pwr_reg value is 0 at probing, the power on sequence fail because
the "power-off" state is not writes (value 0x0) and the lines
remain drive to low.

This patch initializes "pwr_reg" variable with power register value.
This it done in sdmmc variant init to not disturb default mmci behavior.

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Link: https://lore.kernel.org/r/20200420161831.5043-1-ludovic.barre@st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmci_stm32_sdmmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/mmci_stm32_sdmmc.c b/drivers/mmc/host/mmci_stm32_sdmmc.c
index cca7b3b3f618..2965b1c062e1 100644
--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -522,6 +522,7 @@ void sdmmc_variant_init(struct mmci_host *host)
 	struct sdmmc_dlyb *dlyb;
 
 	host->ops = &sdmmc_variant_ops;
+	host->pwr_reg = readl_relaxed(host->base + MMCIPOWER);
 
 	base_dlyb = devm_of_iomap(mmc_dev(host->mmc), np, 1, NULL);
 	if (IS_ERR(base_dlyb))
-- 
2.25.1



