Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C6B3CDAF1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbhGSOkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245152AbhGSOhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:37:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857D061244;
        Mon, 19 Jul 2021 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707862;
        bh=bJArV5wIlLilLfD7Ao1kwSLhVegh20igN+ZquuapfVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2Ux0Jms0+n9D3/+3+Uksli+HZAoTSE8vPlTSWQEOhFqRGAvQA5Ofu1v98nF1i1I0
         6okV7LLR6qX4AUzK/0IP8WH2a47TT+HHnnYIeWe13xtZSFKWNcKAN5TGns/J7jef8R
         te76u+dAi7tELZ16KQKEE9TtXZ6eyBhXhYcYoONM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/315] mmc: usdhi6rol0: fix error return code in usdhi6_probe()
Date:   Mon, 19 Jul 2021 16:49:36 +0200
Message-Id: <20210719144945.736201743@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 2f9ae69e5267f53e89e296fccee291975a85f0eb ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 75fa9ea6e3c0 ("mmc: add a driver for the Renesas usdhi6rol0 SD/SDIO host controller")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210508020321.1677-1-thunder.leizhen@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/usdhi6rol0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index 76e31a30b0cf..d27ee9eb2eac 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -1809,6 +1809,7 @@ static int usdhi6_probe(struct platform_device *pdev)
 
 	version = usdhi6_read(host, USDHI6_VERSION);
 	if ((version & 0xfff) != 0xa0d) {
+		ret = -EPERM;
 		dev_err(dev, "Version not recognized %x\n", version);
 		goto e_clk_off;
 	}
-- 
2.30.2



