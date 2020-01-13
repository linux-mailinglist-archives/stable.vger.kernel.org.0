Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF19B138FCD
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAMLJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgAMLJH (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 13 Jan 2020 06:09:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D08E1207E0;
        Mon, 13 Jan 2020 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578913746;
        bh=0JAs5mjJzermW0vL2s43ksd48JSh+bvhREFkqnjjZFw=;
        h=Subject:To:From:Date:From;
        b=Ch+ATsv2RW60GMCoiN6J9msNzW18fpmA7ygk2HXzAAofdBQ6AVzjCZz3mcUXy0APB
         hQzAgzCitS6XZFcKCFlaUINVtN6G6/amWj0j1Eo8s6WBMHFOQ8Wbzsf41VXgPoA4Jj
         15eL4l/PqlKgwEUIayt6K7WR3mWwaA+RE0EjyizA=
Subject: patch "iio: light: vcnl4000: Fix scale for vcnl4040" added to staging-linus
To:     agx@sigxcpu.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gregkh@linuxfoundation.org,
        m.felsch@pengutronix.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jan 2020 12:08:54 +0100
Message-ID: <157891373413636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: vcnl4000: Fix scale for vcnl4040

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bc80573ea25bb033a58da81b3ce27205b97c088e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Date: Fri, 27 Dec 2019 11:22:54 +0100
Subject: iio: light: vcnl4000: Fix scale for vcnl4040
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

According to the data sheet the ambient sensor's scale is 0.12 lux/step
(not 0.024 lux/step as used by vcnl4200) when the integration time is
80ms. The integration time is currently hardcoded in the driver to that
value.

See p. 8 in https://www.vishay.com/docs/84307/designingvcnl4040.pdf

Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 16dacea9eadf..b0e241aaefb4 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -163,7 +163,6 @@ static int vcnl4200_init(struct vcnl4000_data *data)
 	if (ret < 0)
 		return ret;
 
-	data->al_scale = 24000;
 	data->vcnl4200_al.reg = VCNL4200_AL_DATA;
 	data->vcnl4200_ps.reg = VCNL4200_PS_DATA;
 	switch (id) {
@@ -172,11 +171,13 @@ static int vcnl4200_init(struct vcnl4000_data *data)
 		/* show 54ms in total. */
 		data->vcnl4200_al.sampling_rate = ktime_set(0, 54000 * 1000);
 		data->vcnl4200_ps.sampling_rate = ktime_set(0, 4200 * 1000);
+		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:
 		/* Integration time is 80ms, add 10ms. */
 		data->vcnl4200_al.sampling_rate = ktime_set(0, 100000 * 1000);
 		data->vcnl4200_ps.sampling_rate = ktime_set(0, 100000 * 1000);
+		data->al_scale = 120000;
 		break;
 	}
 	data->vcnl4200_al.last_measurement = ktime_set(0, 0);
-- 
2.24.1


