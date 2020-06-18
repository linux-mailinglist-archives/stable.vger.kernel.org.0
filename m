Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5131FE3E8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgFRBUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbgFRBUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EB421D79;
        Thu, 18 Jun 2020 01:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443247;
        bh=Ztf0MFblqY398kSpaTyXtwRSKN22Zy4kdj7XYww3BJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqH7nxc1IOY7JEWMIDeYaoizWxxRAyAUMJu8GLrjZduF8TXu0T/6BvzZcrWNaQicz
         Eynz2gvjoWjRTMJIELwlCBCsK4711+3s9lBA3YZQyVim7VfrX5ALQl6iY3ND6AGm9q
         54yiM3j9UQDo2YfmpxDYCBePabq6V8+XItTRwJkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 197/266] clk: sprd: return correct type of value for _sprd_pll_recalc_rate
Date:   Wed, 17 Jun 2020 21:15:22 -0400
Message-Id: <20200618011631.604574-197-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit c2f30986d418f26abefc2eec90ebf06716c970d2 ]

The function _sprd_pll_recalc_rate() defines return value to unsigned
long, but it would return a negative value when malloc fail, changing
to return its parent_rate makes more sense, since if the callback
.recalc_rate() is not set, the framework returns the parent_rate as
well.

Fixes: 3e37b005580b ("clk: sprd: add adjustable pll support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lkml.kernel.org/r/20200519030036.1785-2-zhang.lyra@gmail.com
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sprd/pll.c b/drivers/clk/sprd/pll.c
index 640270f51aa5..eb8862752c2b 100644
--- a/drivers/clk/sprd/pll.c
+++ b/drivers/clk/sprd/pll.c
@@ -105,7 +105,7 @@ static unsigned long _sprd_pll_recalc_rate(const struct sprd_pll *pll,
 
 	cfg = kcalloc(regs_num, sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
-		return -ENOMEM;
+		return parent_rate;
 
 	for (i = 0; i < regs_num; i++)
 		cfg[i] = sprd_pll_read(pll, i);
-- 
2.25.1

