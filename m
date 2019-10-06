Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9456CD5FD
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbfJFRmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbfJFRmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:42:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60C6F20700;
        Sun,  6 Oct 2019 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383743;
        bh=RWaQefVK8ASVG6pbqzbUIqMWiTGMpl6fvlxtzPjJeq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nwp3hB9VlvnAuhz4vz/oEF551Zlt02/zW7QyzU7tkNOMRQM+w2xL2/WmQUwkyYRP2
         Q3b/XW3HH/snfKss7xXe9pUw/Qfz8DGGzr6y0H6/UpatSgPnsFgHjd/5vsYcCgNZLQ
         sJMdWm+FBaw4bwnPeyzXEPc4lLSkMUwfibQsC8RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 077/166] clk: sprd: add missing kfree
Date:   Sun,  6 Oct 2019 19:20:43 +0200
Message-Id: <20191006171219.931680365@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



