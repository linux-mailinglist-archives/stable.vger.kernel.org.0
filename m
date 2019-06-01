Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91C131EF9
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfFANky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfFANT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:19:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D76B272B9;
        Sat,  1 Jun 2019 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395197;
        bh=s+Z98v9ivrDolaDrRNoRrO6t6pmUb/gBb80oUlBT2RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3HaZkd6351hnunqMx+53jdQmH/G+1wACj7oOuUqe6FCjA03UUammvsIvTqRYXliq
         ojuE3VgarTpg97By8+Ulm92q9s9wLtMCdP4PZaTmcAiwk8LkpW8f6pPAHKWCH0z77W
         fYYIGonZSEtkLN8yirqopZx7mOsxUjJIbqw+d2d0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 008/173] drm/pl111: Initialize clock spinlock early
Date:   Sat,  1 Jun 2019 09:16:40 -0400
Message-Id: <20190601131934.25053-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 3e01ae2612bdd7975c74ec7123d7f8f5e6eed795 ]

The following warning is seen on systems with broken clock divider.

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 1 Comm: swapper Not tainted 5.1.0-09698-g1fb3b52 #1
Hardware name: ARM Integrator/CP (Device Tree)
[<c0011be8>] (unwind_backtrace) from [<c000ebb8>] (show_stack+0x10/0x18)
[<c000ebb8>] (show_stack) from [<c07d3fd0>] (dump_stack+0x18/0x24)
[<c07d3fd0>] (dump_stack) from [<c0060d48>] (register_lock_class+0x674/0x6f8)
[<c0060d48>] (register_lock_class) from [<c005de2c>]
	(__lock_acquire+0x68/0x2128)
[<c005de2c>] (__lock_acquire) from [<c0060408>] (lock_acquire+0x110/0x21c)
[<c0060408>] (lock_acquire) from [<c07f755c>] (_raw_spin_lock+0x34/0x48)
[<c07f755c>] (_raw_spin_lock) from [<c0536c8c>]
	(pl111_display_enable+0xf8/0x5fc)
[<c0536c8c>] (pl111_display_enable) from [<c0502f54>]
	(drm_atomic_helper_commit_modeset_enables+0x1ec/0x244)

Since commit eedd6033b4c8 ("drm/pl111: Support variants with broken clock
divider"), the spinlock is not initialized if the clock divider is broken.
Initialize it earlier to fix the problem.

Fixes: eedd6033b4c8 ("drm/pl111: Support variants with broken clock divider")
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1557758781-23586-1-git-send-email-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/pl111/pl111_display.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/pl111/pl111_display.c b/drivers/gpu/drm/pl111/pl111_display.c
index 754f6b25f2652..6d9f78612deeb 100644
--- a/drivers/gpu/drm/pl111/pl111_display.c
+++ b/drivers/gpu/drm/pl111/pl111_display.c
@@ -531,14 +531,15 @@ pl111_init_clock_divider(struct drm_device *drm)
 		dev_err(drm->dev, "CLCD: unable to get clcdclk.\n");
 		return PTR_ERR(parent);
 	}
+
+	spin_lock_init(&priv->tim2_lock);
+
 	/* If the clock divider is broken, use the parent directly */
 	if (priv->variant->broken_clockdivider) {
 		priv->clk = parent;
 		return 0;
 	}
 	parent_name = __clk_get_name(parent);
-
-	spin_lock_init(&priv->tim2_lock);
 	div->init = &init;
 
 	ret = devm_clk_hw_register(drm->dev, div);
-- 
2.20.1

