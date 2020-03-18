Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B124718993D
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCRKYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKYj (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00C720775;
        Wed, 18 Mar 2020 10:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527078;
        bh=Wvx4KUwMxUJsTtrCNTDsS625bJYQagEUxgpF15z6Xnw=;
        h=Subject:To:From:Date:From;
        b=E7pwYf5eUqMFUqIHQTP2VQ/2Sl3atzsBm45o+or14eWhIbVf0Yr3H5qPkaTwbWp3T
         mb7NkeE72bKtGuqJ08nJ5L0MqwSfU1sr/6YQSDsrv76vEQlDwzIDksVmSQ9UeYkMCR
         t+P0JrTAlGdsBOMU8qkFE5k1tdTFnLj29Cenu1nc=
Subject: patch "iio: light: vcnl4000: update sampling periods for vcnl4200" added to staging-linus
To:     tomas@novotny.cz, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, agx@sigxcpu.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:20 +0100
Message-ID: <158452706014514@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: vcnl4000: update sampling periods for vcnl4200

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b42aa97ed5f1169cfd37175ef388ea62ff2dcf43 Mon Sep 17 00:00:00 2001
From: Tomas Novotny <tomas@novotny.cz>
Date: Tue, 18 Feb 2020 16:44:50 +0100
Subject: iio: light: vcnl4000: update sampling periods for vcnl4200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Vishay has published a new version of "Designing the VCNL4200 Into an
Application" application note in October 2019. The new version specifies
that there is +-20% of part to part tolerance. This explains the drift
seen during experiments. The proximity pulse width is also changed from
32us to 30us. According to the support, the tolerance also applies to
ambient light.

So update the sampling periods. As the reading is blocking, current
users may notice slightly longer response time.

Fixes: be38866fbb97 ("iio: vcnl4000: add support for VCNL4200")
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/vcnl4000.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index b0e241aaefb4..98428bf430bd 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -167,10 +167,10 @@ static int vcnl4200_init(struct vcnl4000_data *data)
 	data->vcnl4200_ps.reg = VCNL4200_PS_DATA;
 	switch (id) {
 	case VCNL4200_PROD_ID:
-		/* Integration time is 50ms, but the experiments */
-		/* show 54ms in total. */
-		data->vcnl4200_al.sampling_rate = ktime_set(0, 54000 * 1000);
-		data->vcnl4200_ps.sampling_rate = ktime_set(0, 4200 * 1000);
+		/* Default wait time is 50ms, add 20% tolerance. */
+		data->vcnl4200_al.sampling_rate = ktime_set(0, 60000 * 1000);
+		/* Default wait time is 4.8ms, add 20% tolerance. */
+		data->vcnl4200_ps.sampling_rate = ktime_set(0, 5760 * 1000);
 		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:
-- 
2.25.1


