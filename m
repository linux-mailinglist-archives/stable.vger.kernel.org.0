Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BBB411E3E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350210AbhITR2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345349AbhITR0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 121356137F;
        Mon, 20 Sep 2021 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157363;
        bh=j7fEjZeqNGG1BVw4z7+o9ebWYMqAA1V0g2vnqTRhNPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePqDlYUpqzQmRQndemgaeG7JkQroe2DVf0wuclwFc9tR8c+lu8O/O7SdxhokkSzpq
         QFrdm2C7tA0KHsGByzIQMQ6p2ulAK2o8djmSRPzlakMTUUrh90NzU2XuwAsHQMLjTD
         KdVSvbuabzp8EmtOI5TGR2pRL0NewqiMTHy0UVIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 142/217] staging: board: Fix uninitialized spinlock when attaching genpd
Date:   Mon, 20 Sep 2021 18:42:43 +0200
Message-Id: <20210920163929.457615945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 86dc41101610..1e2b33912a8a 100644
--- a/drivers/staging/board/board.c
+++ b/drivers/staging/board/board.c
@@ -139,6 +139,7 @@ int __init board_staging_register_clock(const struct board_staging_clk *bsc)
 static int board_staging_add_dev_domain(struct platform_device *pdev,
 					const char *domain)
 {
+	struct device *dev = &pdev->dev;
 	struct of_phandle_args pd_args;
 	struct device_node *np;
 
@@ -151,7 +152,11 @@ static int board_staging_add_dev_domain(struct platform_device *pdev,
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



