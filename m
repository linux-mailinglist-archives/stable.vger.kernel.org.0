Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B29440BA
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391018AbfFMQIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731268AbfFMIot (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:44:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60342147A;
        Thu, 13 Jun 2019 08:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415488;
        bh=GSTTpigTR+QKB1kZBNgiJYTC8qGHTEziFPt1bj0+VAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ID8YxHt9B+31S+P7Bk6D56XgSkh2X/2tg1EIPIbUytOy3nz+QUMErgcjjLp1Sjiwr
         yjlo3ogocYHGoe1aGF8649hUp+7orVrTV3xStLK4J/4GBvqL9xhMzgfKRi8vu+9Wgt
         d6emFVtmpSnQeLiV1ILUmmjvq7CWAwkz+y5bP64g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 009/155] drm/pl111: Initialize clock spinlock early
Date:   Thu, 13 Jun 2019 10:32:01 +0200
Message-Id: <20190613075653.263419369@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 754f6b25f265..6d9f78612dee 100644
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



