Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6D205C8B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387968AbgFWUDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387956AbgFWUDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 702402080C;
        Tue, 23 Jun 2020 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942578;
        bh=krHgMfCn8WZvzHVDZ4TckLPbXuEfsPCvYgWThdNfNgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7ohRaPbiJmaoPirI6lFM/QrccMIJx8okv8Z7pr4LmLjCINx3FzyBHY5/xV0CQO1n
         wYqTHOFqgIAJdN3JiwKjJQ6DXmS9FtEy0YhwR/NzaT2d3e/VcSl8FTOfehKdAMp6wT
         US864nFRXdT+bqV4fjKiTjrvVhU7Exw8cAZ9kuNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 053/477] clk: renesas: cpg-mssr: Fix STBCR suspend/resume handling
Date:   Tue, 23 Jun 2020 21:50:50 +0200
Message-Id: <20200623195410.113611492@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ace342097768e35fd41934285604fa97da1e235a ]

On SoCs with Standby Control Registers (STBCRs) instead of Module Stop
Control Registers (MSTPCRs), the suspend handler saves the wrong
registers, and the resume handler prints the wrong register in an error
message.

Fortunately this cannot happen yet, as the suspend/resume code is used
on PSCI systems only, and systems with STBCRs (RZ/A1 and RZ/A2) do not
use PSCI.  Still, it is better to fix this, to avoid this becoming a
problem in the future.

Distinguish between STBCRs and MSTPCRs where needed.  Replace the
useless printing of the virtual register address in the resume error
message by printing the register index.

Fixes: fde35c9c7db5732c ("clk: renesas: cpg-mssr: Add R7S9210 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20200507074713.30113-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index a2663fbbd7a51..d6a53c99b114a 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -812,7 +812,8 @@ static int cpg_mssr_suspend_noirq(struct device *dev)
 	/* Save module registers with bits under our control */
 	for (reg = 0; reg < ARRAY_SIZE(priv->smstpcr_saved); reg++) {
 		if (priv->smstpcr_saved[reg].mask)
-			priv->smstpcr_saved[reg].val =
+			priv->smstpcr_saved[reg].val = priv->stbyctrl ?
+				readb(priv->base + STBCR(reg)) :
 				readl(priv->base + SMSTPCR(reg));
 	}
 
@@ -872,8 +873,9 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		}
 
 		if (!i)
-			dev_warn(dev, "Failed to enable SMSTP %p[0x%x]\n",
-				 priv->base + SMSTPCR(reg), oldval & mask);
+			dev_warn(dev, "Failed to enable %s%u[0x%x]\n",
+				 priv->stbyctrl ? "STB" : "SMSTP", reg,
+				 oldval & mask);
 	}
 
 	return 0;
-- 
2.25.1



