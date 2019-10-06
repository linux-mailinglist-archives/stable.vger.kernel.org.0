Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458ABCD772
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfJFR3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbfJFR3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAC022080F;
        Sun,  6 Oct 2019 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382954;
        bh=iFNLHfZGTgPUdhXaraunHws1uO5Hq9xIxfd6f9z792E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+uOhJOuOiV0UJOQoNXetdbzgHyWyEKEGtec+xiD+/u7R9ugFeRoedG3IYqS0tSHO
         X9JLRjdprBH2+0hAu3b6sHuooq2QtOts2Kh3uDz2H0CXPlE/EaARCSLG1AXzDlfJbT
         XoXFNccjKrBvtI+bFIf3uLTlZVqfbdLYMAmG0ThA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/106] clk: renesas: mstp: Set GENPD_FLAG_ALWAYS_ON for clock domain
Date:   Sun,  6 Oct 2019 19:20:37 +0200
Message-Id: <20191006171139.608595417@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a459a184c978ca9ad538aab93aafdde873953f30 ]

The CPG/MSTP Clock Domain driver does not implement the
generic_pm_domain.power_{on,off}() callbacks, as the domain itself
cannot be powered down.  Hence the domain should be marked as always-on
by setting the GENPD_FLAG_ALWAYS_ON flag, to prevent the core PM Domain
code from considering it for power-off, and doing unnessary processing.

This also gets rid of a boot warning when the Clock Domain contains an
IRQ-safe device, e.g. on RZ/A1:

    sh_mtu2 fcff0000.timer: PM domain cpg_clocks will not be powered off

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/clk-mstp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/clk-mstp.c b/drivers/clk/renesas/clk-mstp.c
index e82adcb16a52a..45d94fb9703d2 100644
--- a/drivers/clk/renesas/clk-mstp.c
+++ b/drivers/clk/renesas/clk-mstp.c
@@ -341,7 +341,8 @@ void __init cpg_mstp_add_clk_domain(struct device_node *np)
 		return;
 
 	pd->name = np->name;
-	pd->flags = GENPD_FLAG_PM_CLK | GENPD_FLAG_ACTIVE_WAKEUP;
+	pd->flags = GENPD_FLAG_PM_CLK | GENPD_FLAG_ALWAYS_ON |
+		    GENPD_FLAG_ACTIVE_WAKEUP;
 	pd->attach_dev = cpg_mstp_attach_dev;
 	pd->detach_dev = cpg_mstp_detach_dev;
 	pm_genpd_init(pd, &pm_domain_always_on_gov, false);
-- 
2.20.1



