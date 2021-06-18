Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C173AC3F8
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhFRGf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhFRGf0 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E3686128D;
        Fri, 18 Jun 2021 06:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623997997;
        bh=JrNd5UDKezwIL3Ai67sWjluEvkO5GVBYGYKsTtnEidQ=;
        h=Subject:To:From:Date:From;
        b=vnGP+M66efpizM7c0y6iIVQcH+7LoH0wl/YcsotqD2uuHLff0533wlNIuwGigR3a2
         PMeDg0pFImY5Np7bmK8J55s1yB+EZnlVgDQdIC46Kk0OKUF3anvUhe5Jai1pnFwlB2
         ddoZSmof/ELgev2CaSRyLCUjMUrDeFpMCfIkQgaI=
Subject: patch "iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR" added to staging-next
To:     Oliver.Lang@gossenmetrawatt.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        mkl@pengutronix.de, nikita@trvn.ru
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:31:13 +0200
Message-ID: <16239978737974@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 421a26f3d7a7c3ca43f3a9dc0f3cb0f562d5bd95 Mon Sep 17 00:00:00 2001
From: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Date: Thu, 10 Jun 2021 15:46:17 +0200
Subject: iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR

The ltr559 chip uses only the lowest bit of the ALS_CONTR register to
configure between active and stand-by mode. In the original driver
BIT(1) is used, which does a software reset instead.

This patch fixes the problem by using BIT(0) as als_mode_active for
the ltr559 chip.

Fixes: 8592a7eefa54 ("iio: ltr501: Add support for ltr559 chip")
Signed-off-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Nikita Travkin <nikita@trvn.ru> # ltr559
Link: https://lore.kernel.org/r/20210610134619.2101372-3-mkl@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 0ed3392a33cf..79898b72fe73 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1208,7 +1208,7 @@ static struct ltr501_chip_info ltr501_chip_info_tbl[] = {
 		.als_gain_tbl_size = ARRAY_SIZE(ltr559_als_gain_tbl),
 		.ps_gain = ltr559_ps_gain_tbl,
 		.ps_gain_tbl_size = ARRAY_SIZE(ltr559_ps_gain_tbl),
-		.als_mode_active = BIT(1),
+		.als_mode_active = BIT(0),
 		.als_gain_mask = BIT(2) | BIT(3) | BIT(4),
 		.als_gain_shift = 2,
 		.info = &ltr501_info,
-- 
2.32.0


