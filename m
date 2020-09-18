Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B2E26F18D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgIRCwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgIRCIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 975C0239CF;
        Fri, 18 Sep 2020 02:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394893;
        bh=XooXO7f0+p2i4ItHkoDZBtIGouKukXVbkWk0foHqTds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3YPGdiiR9p/vPgkCN4p1qfwkYAoUXMnUuCS6aVymEZDgnbCIVHPm65mG9ljmMMkD
         xjuVLJvWxZNCAaQBipmpVgQ+veN4fM9yZLrM6TcfgUQykwX39v4sZmdl44WtA/ZG6x
         c25352D2lrWc4Rk9xO+f+4RW3a+97VTtrRhGU6Vs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.19 008/206] m68k: q40: Fix info-leak in rtc_ioctl
Date:   Thu, 17 Sep 2020 22:04:44 -0400
Message-Id: <20200918020802.2065198-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
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
index 96810d91da2bd..4a25ce6a1823d 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -273,6 +273,7 @@ static int q40_get_rtc_pll(struct rtc_pll_info *pll)
 {
 	int tmp = Q40_RTC_CTRL;
 
+	pll->pll_ctrl = 0;
 	pll->pll_value = tmp & Q40_RTC_PLL_MASK;
 	if (tmp & Q40_RTC_PLL_SIGN)
 		pll->pll_value = -pll->pll_value;
-- 
2.25.1

