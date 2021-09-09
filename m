Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4F405461
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbhIIM6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356225AbhIIMxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:53:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF0B63244;
        Thu,  9 Sep 2021 11:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188664;
        bh=JU4iJc6oY871eBLmLglTyk8lAnK2nHC5KV9FVXhDFpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2dbbx7ER8DBHzkH92lj555Lcbq0ds4tbnuOd+5yiWQJzjDFstCx5fO0Bu/kiOQx1
         tAwjkQGVTUuoPTwWqtE3F4dTFrxmfjH0xX1QNk1e8Fd73pdmsBYaUDAAvZpfB5yGO1
         G9I2xXG1HH7FMj3FUlj9Wag7ITGvFOWGfG3GhifjgPQj3P9T6w4OVgJf13JYQU3pcX
         0Z/cu8kSPLCakObg07WGi+FLpY4DW3BCyObYASiIGl9aOW8Lfkj/uBIvrN4R5jxAAf
         4+AcyVhEVvsNSi+5r+ZAb/brS0HyjCf/2IrzHlGgHH9xVsFykbhS3aaUM3+rjzXYPd
         fYGuFJUMcihEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.19 14/74] staging: board: Fix uninitialized spinlock when attaching genpd
Date:   Thu,  9 Sep 2021 07:56:26 -0400
Message-Id: <20210909115726.149004-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit df00609821bf17f50a75a446266d19adb8339d84 ]

On Armadillo-800-EVA with CONFIG_DEBUG_SPINLOCK=y:

    BUG: spinlock bad magic on CPU#0, swapper/1
     lock: lcdc0_device+0x10c/0x308, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    CPU: 0 PID: 1 Comm: swapper Not tainted 5.11.0-rc5-armadillo-00036-gbbca04be7a80-dirty #287
    Hardware name: Generic R8A7740 (Flattened Device Tree)
    [<c010c3c8>] (unwind_backtrace) from [<c010a49c>] (show_stack+0x10/0x14)
    [<c010a49c>] (show_stack) from [<c0159534>] (do_raw_spin_lock+0x20/0x94)
    [<c0159534>] (do_raw_spin_lock) from [<c040858c>] (dev_pm_get_subsys_data+0x8c/0x11c)
    [<c040858c>] (dev_pm_get_subsys_data) from [<c05fbcac>] (genpd_add_device+0x78/0x2b8)
    [<c05fbcac>] (genpd_add_device) from [<c0412db4>] (of_genpd_add_device+0x34/0x4c)
    [<c0412db4>] (of_genpd_add_device) from [<c0a1ea74>] (board_staging_register_device+0x11c/0x148)
    [<c0a1ea74>] (board_staging_register_device) from [<c0a1eac4>] (board_staging_register_devices+0x24/0x28)

of_genpd_add_device() is called before platform_device_register(), as it
needs to attach the genpd before the device is probed.  But the spinlock
is only initialized when the device is registered.

Fix this by open-coding the spinlock initialization, cfr.
device_pm_init_common() in the internal drivers/base code, and in the
SuperH early platform code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/57783ece7ddae55f2bda2f59f452180bff744ea0.1626257398.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/board/board.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/board/board.c b/drivers/staging/board/board.c
index cb6feb34dd40..f980af037345 100644
--- a/drivers/staging/board/board.c
+++ b/drivers/staging/board/board.c
@@ -136,6 +136,7 @@ int __init board_staging_register_clock(const struct board_staging_clk *bsc)
 static int board_staging_add_dev_domain(struct platform_device *pdev,
 					const char *domain)
 {
+	struct device *dev = &pdev->dev;
 	struct of_phandle_args pd_args;
 	struct device_node *np;
 
@@ -148,7 +149,11 @@ static int board_staging_add_dev_domain(struct platform_device *pdev,
 	pd_args.np = np;
 	pd_args.args_count = 0;
 
-	return of_genpd_add_device(&pd_args, &pdev->dev);
+	/* Initialization similar to device_pm_init_common() */
+	spin_lock_init(&dev->power.lock);
+	dev->power.early_init = true;
+
+	return of_genpd_add_device(&pd_args, dev);
 }
 #else
 static inline int board_staging_add_dev_domain(struct platform_device *pdev,
-- 
2.30.2

