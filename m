Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198B42CFD48
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 19:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgLES33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 13:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbgLES3Z (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 5 Dec 2020 13:29:25 -0500
Subject: patch "iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on" added to staging-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183328;
        bh=+79iqHa2fp0sN7f6xH7qJnQiBVGjxznbsnQ6/QDNjUk=;
        h=To:From:Date:From;
        b=2GxBhTbJJV41Sl5fkGbNR40CsrH2tQTRIMTjHIgvhROJG7f+qLaxiD0mAwE9wocDa
         De+R2WVgj6mkkqsnsHkxGigACzt+jIHdYVWrR5NEyWTqiE5CxFN6th9+1FiNwN3lMZ
         OCUdZA0offEiATgxzqgQQ+qnRSrREZNeIqcxb550=
To:     miaoqinglang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, robin.murphy@arm.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Dec 2020 16:46:13 +0100
Message-ID: <1607183173172227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 560c6b914c6ec7d9d9a69fddbb5bf3bf71433e8b Mon Sep 17 00:00:00 2001
From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Tue, 3 Nov 2020 20:07:43 +0800
Subject: iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on
 error in rockchip_saradc_resume

Fix the missing clk_disable_unprepare() of info->pclk
before return from rockchip_saradc_resume in the error
handling case when fails to prepare and enable info->clk.

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Fixes: 44d6f2ef94f9 ("iio: adc: add driver for Rockchip saradc")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201103120743.110662-1-miaoqinglang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/rockchip_saradc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
index 1f3d7d639d37..12584f1631d8 100644
--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -462,7 +462,7 @@ static int rockchip_saradc_resume(struct device *dev)
 
 	ret = clk_prepare_enable(info->clk);
 	if (ret)
-		return ret;
+		clk_disable_unprepare(info->pclk);
 
 	return ret;
 }
-- 
2.29.2


