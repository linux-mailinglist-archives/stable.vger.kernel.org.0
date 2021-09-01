Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD7A3FDC6A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbhIAMut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344201AbhIAMrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:47:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788CB6115A;
        Wed,  1 Sep 2021 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500017;
        bh=tIlXoCmilhX0y2OscsrFOcz4GMNRMV1uFCPD2R7oKyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqRz+2SoRNktrC+2a5jTeDvJ81yJdBvsPXdZqeMaO415xW96kyp6Nr8uosXDC3nvI
         DbXMeQDF+8tio0TyI5EAtL8X9V7/XMHHksDXmYWDQAB3vz+XqVtL04Z+rrJq+PWtsV
         gFfoCncC1IaKhOOagqhvKOTDGKHpLnj1hNSTnmLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 072/113] clk: renesas: rcar-usb2-clock-sel: Fix kernel NULL pointer dereference
Date:   Wed,  1 Sep 2021 14:28:27 +0200
Message-Id: <20210901122304.390718842@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 1669a941f7c4844ae808cf441db51dde9e94db07 ]

The probe was manually passing NULL instead of dev to devm_clk_hw_register.
This caused a Unable to handle kernel NULL pointer dereference error.
Fix this by passing 'dev'.

Signed-off-by: Adam Ford <aford173@gmail.com>
Fixes: a20a40a8bbc2 ("clk: renesas: rcar-usb2-clock-sel: Fix error handling in .probe()")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rcar-usb2-clock-sel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rcar-usb2-clock-sel.c b/drivers/clk/renesas/rcar-usb2-clock-sel.c
index 9fb79bd79435..684d8937965e 100644
--- a/drivers/clk/renesas/rcar-usb2-clock-sel.c
+++ b/drivers/clk/renesas/rcar-usb2-clock-sel.c
@@ -187,7 +187,7 @@ static int rcar_usb2_clock_sel_probe(struct platform_device *pdev)
 	init.ops = &usb2_clock_sel_clock_ops;
 	priv->hw.init = &init;
 
-	ret = devm_clk_hw_register(NULL, &priv->hw);
+	ret = devm_clk_hw_register(dev, &priv->hw);
 	if (ret)
 		goto pm_put;
 
-- 
2.30.2



