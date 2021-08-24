Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC9C3F641F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhHXRA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239051AbhHXQ7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F3961452;
        Tue, 24 Aug 2021 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824256;
        bh=qwQ7SaZ0wfykj1iky8lmbdBzWHrS+Kn+mxuPu4iNuKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PP0duNplEyj2/o9mdTGhYZi5Hn0nEXd6RZMSYzeqzfrdCbsQUbpAwaMXtxhI2M0iZ
         7R4JDshaVYMCGgGUmTqhHoyrpYNiSkm43sImXZZ2s6xeFzKO+K30pm4NHAvUPMME5d
         ajswtFzAA0d1noJ94l89DstXzHISjkmSmtKC7iMeAHxL6QkeX6fKKgmCxel3EaWFOG
         eu5kBcU43i6K+oiwKZvjNHFqs+pRI5bDAT4Ih7RYy5DWnrtGgPB20JhQ0UC96Vg9AS
         Wy00IqkX83IG3bsB55hLnzK2B1UdsT98uC0lS5OBAmJHMiLyRW/n4V4lC5RuhuuYCM
         A0TW5l+W/3m3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, Abel Vesa <abel.vesa@nxp.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 089/127] clk: imx6q: fix uart earlycon unwork
Date:   Tue, 24 Aug 2021 12:55:29 -0400
Message-Id: <20210824165607.709387-90-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit 283f1b9a0401859c53fdd6483ab66f1c4fadaea5 ]

The earlycon depends on the bootloader setup UART clocks being retained.
There're actually two uart clocks (ipg, per) on MX6QDL,
but the 'Fixes' commit change to register only one which means
another clock may be disabled during booting phase
and result in the earlycon unwork.

Cc: stable@vger.kernel.org # v5.10+
Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20210702085438.1988087-1-aisheng.dong@nxp.com
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index 496900de0b0b..de36f58d551c 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -974,6 +974,6 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
 	}
 
-	imx_register_uart_clocks(1);
+	imx_register_uart_clocks(2);
 }
 CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
-- 
2.30.2

