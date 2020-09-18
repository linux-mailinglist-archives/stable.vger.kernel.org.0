Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4273626EEA9
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgIRC3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbgIRCO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:14:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A34823787;
        Fri, 18 Sep 2020 02:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395298;
        bh=EK4ExL+4XPc6rfQSetuscZT39buHQChcqefi/2nI/KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19j7+XI5i/wFfShZc+QkoXPzFEb813vXswUNn5oaZbkpgRgqGJWZnVbPuOS1ZNVQ0
         hT1PML07UZaay8G97OP4T0jBWAwM2+lr0EL6UfY8nAp0bGs0ckWfdjKqGK4gYfCHXo
         lxhrF4xO9CObvtsiGY1W2OuCiRlW4pUDgMQqg288=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.9 02/90] m68k: q40: Fix info-leak in rtc_ioctl
Date:   Thu, 17 Sep 2020 22:13:27 -0400
Message-Id: <20200918021455.2067301-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>

[ Upstream commit 7cf78b6b12fd5550545e4b73b35dca18bd46b44c ]

When the option is RTC_PLL_GET, pll will be copied to userland
via copy_to_user. pll is initialized using mach_get_rtc_pll indirect
call and mach_get_rtc_pll is only assigned with function
q40_get_rtc_pll in arch/m68k/q40/config.c.
In function q40_get_rtc_pll, the field pll_ctrl is not initialized.
This will leak uninitialized stack content to userland.
Fix this by zeroing the uninitialized field.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
Link: https://lore.kernel.org/r/20190927121544.7650-1-huangfq.daxian@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/q40/config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index ea89a24f46000..cc0f924bbdd2d 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -303,6 +303,7 @@ static int q40_get_rtc_pll(struct rtc_pll_info *pll)
 {
 	int tmp = Q40_RTC_CTRL;
 
+	pll->pll_ctrl = 0;
 	pll->pll_value = tmp & Q40_RTC_PLL_MASK;
 	if (tmp & Q40_RTC_PLL_SIGN)
 		pll->pll_value = -pll->pll_value;
-- 
2.25.1

