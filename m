Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7EBCF00
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410770AbfIXQua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410756AbfIXQu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:50:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C86D6222C0;
        Tue, 24 Sep 2019 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343826;
        bh=RWaQefVK8ASVG6pbqzbUIqMWiTGMpl6fvlxtzPjJeq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdYsNjXB8cxfseintxqC7ZxjZWwQzyPd+V5ziXpYLYd/L1mQ/ztTpE6/bptggsEQw
         Ep4M9kdr/RTGAAuoTXPrTBkiXz3ENm3/U/ux4wDVDqTbe7Iu1VA3cBiL86B34lBSJg
         p24uMLffYH5Gqg6Q6VlVxy3NEpdAgnT606Cr53w0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 47/50] clk: sprd: add missing kfree
Date:   Tue, 24 Sep 2019 12:48:44 -0400
Message-Id: <20190924164847.27780-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 5e75ea9c67433a065b0e8595ad3c91c7c0ca0d2d ]

The number of config registers for different pll clocks probably are not
same, so we have to use malloc, and should free the memory before return.

Fixes: 3e37b005580b ("clk: sprd: add adjustable pll support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Link: https://lkml.kernel.org/r/20190905103009.27166-1-zhang.lyra@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/pll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/sprd/pll.c b/drivers/clk/sprd/pll.c
index 36b4402bf09e3..640270f51aa56 100644
--- a/drivers/clk/sprd/pll.c
+++ b/drivers/clk/sprd/pll.c
@@ -136,6 +136,7 @@ static unsigned long _sprd_pll_recalc_rate(const struct sprd_pll *pll,
 					 k2 + refin * nint * CLK_PLL_1M;
 	}
 
+	kfree(cfg);
 	return rate;
 }
 
@@ -222,6 +223,7 @@ static int _sprd_pll_set_rate(const struct sprd_pll *pll,
 	if (!ret)
 		udelay(pll->udelay);
 
+	kfree(cfg);
 	return ret;
 }
 
-- 
2.20.1

