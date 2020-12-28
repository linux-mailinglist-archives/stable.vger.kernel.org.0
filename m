Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66AB2E3D5E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440505AbgL1OOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440504AbgL1OOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9240822B2A;
        Mon, 28 Dec 2020 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164848;
        bh=PYpj4NAq1T+tbXVF/iIBpjeM9zAFCXUk4gMTuhLjReU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoUv/9xYCO1Etgs5yMP+jZp9PuuUceNzy37tcLcp+1ScIy79Dtj+zgupon1XGnfe1
         ldkQKDbiXB6EZH60qPfCy8IiO0IV6YMMCW1sRGLAt7wNiJ/wG3vEqfG41wAadTwhFC
         Ha+QuTzIAQyho/xumgjYXTGlUK8sg0RAh/4PKhcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/717] clocksource/drivers/arm_arch_timer: Use stable count reader in erratum sne
Date:   Mon, 28 Dec 2020 13:45:19 +0100
Message-Id: <20201228125036.406151752@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keqian Zhu <zhukeqian1@huawei.com>

[ Upstream commit d8cc3905b8073c7cfbff94af889fa8dc71f21dd5 ]

In commit 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter
to access stable counters"), we separate stable and normal count reader to omit
unnecessary overhead on systems that have no timer erratum.

However, in erratum_set_next_event_tval_generic(), count reader becomes normal
reader. This converts it to stable reader.

Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter to access stable counters")
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201204073126.6920-2-zhukeqian1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6c3e841801461..777d38cb39b09 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -396,10 +396,10 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
 	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
 
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
-		cval = evt + arch_counter_get_cntpct();
+		cval = evt + arch_counter_get_cntpct_stable();
 		write_sysreg(cval, cntp_cval_el0);
 	} else {
-		cval = evt + arch_counter_get_cntvct();
+		cval = evt + arch_counter_get_cntvct_stable();
 		write_sysreg(cval, cntv_cval_el0);
 	}
 
-- 
2.27.0



