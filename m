Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C5830A3F7
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhBAJFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:05:42 -0500
Received: from www.linuxtv.org ([130.149.80.248]:41066 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232648AbhBAJFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:05:20 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l6V8C-005hiM-7y; Mon, 01 Feb 2021 09:04:24 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 12 Jan 2021 11:47:15 +0000
Subject: [git:media_tree/master] media: rc: ite-cir: fix min_timeout calculation
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Matthias Reichl <hias@horus.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l6V8C-005hiM-7y@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rc: ite-cir: fix min_timeout calculation
Author:  Matthias Reichl <hias@horus.com>
Date:    Sat Jan 9 21:10:55 2021 +0100

Commit 528222d853f92 ("media: rc: harmonize infrared durations to
microseconds") missed to switch the min_timeout calculation from ns
to us. This resulted in a minimum timeout of 1.2 seconds instead of 1.2ms,
leading to large delays and long key repeats.

Fix this by applying proper ns->us conversion.

Cc: stable@vger.kernel.org
Fixes: 528222d853f92 ("media: rc: harmonize infrared durations to microseconds")
Signed-off-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/ite-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index a905113fef6e..0c6229592e13 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1551,7 +1551,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	rdev->s_rx_carrier_range = ite_set_rx_carrier_range;
 	/* FIFO threshold is 17 bytes, so 17 * 8 samples minimum */
 	rdev->min_timeout = 17 * 8 * ITE_BAUDRATE_DIVISOR *
-			    itdev->params.sample_period;
+			    itdev->params.sample_period / 1000;
 	rdev->timeout = IR_DEFAULT_TIMEOUT;
 	rdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	rdev->rx_resolution = ITE_BAUDRATE_DIVISOR *
