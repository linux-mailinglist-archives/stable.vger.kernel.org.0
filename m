Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BAB34C5D8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhC2ID1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231940AbhC2ICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18AE761981;
        Mon, 29 Mar 2021 08:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004956;
        bh=BG4jTp2DQEnJmUtlKC/+k9EQ3yB9/XQr/geX0VFuXlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AALZ8H/MjwW35fI9qwdp4Ee+8qb5wy1goJYxtV8KV3ufiXIAgUK7qx+WwyERwcIVE
         4ZevyLgW/+Wt2Up8UCZx83dEAURDL10YmgKJIjHJm+UbULe28npKp3Ild8LE/1LA3g
         k/Jyczvef5Pts2l1ICYyvy2T6M/dwDZQbG5+65sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/53] bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD
Date:   Mon, 29 Mar 2021 09:57:56 +0200
Message-Id: <20210329075608.241621807@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 7d7275b3e866cf8092bd12553ec53ba26864f7bb ]

The main purpose of l3 IRQs is to catch OCP bus access errors and identify
corresponding code places by showing call stack, so it's important to
handle L3 interconnect errors as fast as possible. On RT these IRQs will
became threaded and will be scheduled much more late from the moment actual
error occurred so showing completely useless information.

Hence, mark l3 IRQs as IRQF_NO_THREAD so they will not be forced threaded
on RT or if force_irqthreads = true.

Fixes: 0ee7261c9212 ("drivers: bus: Move the OMAP interconnect driver to drivers/bus/")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/omap_l3_noc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 5012e3ad1225..624f74d03a83 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -285,7 +285,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 	 */
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(l3->dev, l3->debug_irq, l3_interrupt_handler,
-			       0x0, "l3-dbg-irq", l3);
+			       IRQF_NO_THREAD, "l3-dbg-irq", l3);
 	if (ret) {
 		dev_err(l3->dev, "request_irq failed for %d\n",
 			l3->debug_irq);
@@ -294,7 +294,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = devm_request_irq(l3->dev, l3->app_irq, l3_interrupt_handler,
-			       0x0, "l3-app-irq", l3);
+			       IRQF_NO_THREAD, "l3-app-irq", l3);
 	if (ret)
 		dev_err(l3->dev, "request_irq failed for %d\n", l3->app_irq);
 
-- 
2.30.1



