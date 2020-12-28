Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3572E6615
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393511AbgL1QIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388934AbgL1NZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F9C22475;
        Mon, 28 Dec 2020 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161924;
        bh=VyVBGoS9MOCBu4cikptMOeRKp8QLlY4mmy/7tessIUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQATbC6GE33XGgis5qLRLcLE0pjKY0Y2xGVJFaCClj1G1uwcMD1AFIBC3a/28Vp9X
         y0jrenvyfFJTyRbnD+ZOVOlUx3UoE3LrVj/BUfL2/Nv70By9XDUwG1tngXv1QXk37z
         z+NvHbPRQVKs+vjHIn2zg9Uq8ofZC25oZvKDJvcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/346] spi: bcm63xx-hsspi: fix missing clk_disable_unprepare() on error in bcm63xx_hsspi_resume
Date:   Mon, 28 Dec 2020 13:47:28 +0100
Message-Id: <20201228124926.023749543@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 9bb9ef2b3e5d9d012876e7e2d7757eb30e865bee ]

Fix the missing clk_disable_unprepare() before return
from bcm63xx_hsspi_resume in the error handling case when
fails to prepare and enable bs->pll_clk.

Fixes: 0fd85869c2a9 ("spi/bcm63xx-hsspi: keep pll clk enabled")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201103074911.195530-1-miaoqinglang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 1669c554ea340..2ad7b3f3666be 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -487,8 +487,10 @@ static int bcm63xx_hsspi_resume(struct device *dev)
 
 	if (bs->pll_clk) {
 		ret = clk_prepare_enable(bs->pll_clk);
-		if (ret)
+		if (ret) {
+			clk_disable_unprepare(bs->clk);
 			return ret;
+		}
 	}
 
 	spi_master_resume(master);
-- 
2.27.0



