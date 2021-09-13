Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B084F409567
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344565AbhIMOlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346230AbhIMOjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05FCB61C16;
        Mon, 13 Sep 2021 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541306;
        bh=hL90DXIM74ocYY1wpc5HpqWBhujKelUfVbEiWwtusfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5yIYuOIjkdHfwSCyDZujwquO3g/hzHefuxQHhOH06K83b+QTjWHmo7cebF/9Hxj6
         ZzYEzkEma8MGjU1pK66J8hYEMTIPgx6vAVqHrSU0v5IFT+Ia7pwsspPf06e8Q8m5PR
         8mCq2rMqK7bqT7YnZXdYhTp8EK1MJSi3E6QRQzdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 246/334] m68k: coldfire: return success for clk_enable(NULL)
Date:   Mon, 13 Sep 2021 15:15:00 +0200
Message-Id: <20210913131121.714823869@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f6a4f0b424df957d84fa7b9f2d02981234ff5828 ]

The clk_enable is supposed work when CONFIG_HAVE_CLK is false, but it
returns -EINVAL.  That means some drivers fail during probe.

[    1.680000] flexcan: probe of flexcan.0 failed with error -22

Fixes: c1fb1bf64bb6 ("m68k: let clk_enable() return immediately if clk is NULL")
Fixes: bea8bcb12da0 ("m68knommu: Add support for the Coldfire m5441x.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/coldfire/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/coldfire/clk.c b/arch/m68k/coldfire/clk.c
index 2ed841e94111..d03b6c4aa86b 100644
--- a/arch/m68k/coldfire/clk.c
+++ b/arch/m68k/coldfire/clk.c
@@ -78,7 +78,7 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 
 	if (!clk)
-		return -EINVAL;
+		return 0;
 
 	spin_lock_irqsave(&clk_lock, flags);
 	if ((clk->enabled++ == 0) && clk->clk_ops)
-- 
2.30.2



