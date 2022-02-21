Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EFE4BE314
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbiBUQ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiBUQ7J (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD6C23BE3
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:58:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FCCBB815A6
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3821AC340E9;
        Mon, 21 Feb 2022 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462722;
        bh=0ARQESC2AMGIaARrJ58LG8Y7msR3Ys5mtj+K8hvZbdY=;
        h=Subject:To:From:Date:From;
        b=KCUM0rf3y/cp6G2qzDbnCdyhBiY9EAgIt9c1jTyhywhR15FgqWVfeh9Dj2M5NHaJ/
         QLClG5eegtjcH1MimIrImysuUZY7K16r3ILv217ycPdGpyOw5nIZ5/gFJNm94I16k+
         JA8PzkaRbuXEfb+Js0I5oT78ottT8QD4izVzEyt4=
Subject: patch "iio: adc: tsc2046: fix memory corruption by preventing array overflow" added to char-misc-linus
To:     o.rempel@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:40 +0100
Message-ID: <164546272013346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: tsc2046: fix memory corruption by preventing array overflow

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b7a78a8adaa8849c02f174d707aead0f85dca0da Mon Sep 17 00:00:00 2001
From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 7 Jan 2022 09:14:01 +0100
Subject: iio: adc: tsc2046: fix memory corruption by preventing array overflow

On one side we have indio_dev->num_channels includes all physical channels +
timestamp channel. On other side we have an array allocated only for
physical channels. So, fix memory corruption by ARRAY_SIZE() instead of
num_channels variable.

Note the first case is a cleanup rather than a fix as the software
timestamp channel bit in active_scanmask is never set by the IIO core.

Fixes: 9374e8f5a38d ("iio: adc: add ADC driver for the TI TSC2046 controller")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20220107081401.2816357-1-o.rempel@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-tsc2046.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti-tsc2046.c b/drivers/iio/adc/ti-tsc2046.c
index d84ae6b008c1..e8fc4d01f30b 100644
--- a/drivers/iio/adc/ti-tsc2046.c
+++ b/drivers/iio/adc/ti-tsc2046.c
@@ -388,7 +388,7 @@ static int tsc2046_adc_update_scan_mode(struct iio_dev *indio_dev,
 	mutex_lock(&priv->slock);
 
 	size = 0;
-	for_each_set_bit(ch_idx, active_scan_mask, indio_dev->num_channels) {
+	for_each_set_bit(ch_idx, active_scan_mask, ARRAY_SIZE(priv->l)) {
 		size += tsc2046_adc_group_set_layout(priv, group, ch_idx);
 		tsc2046_adc_group_set_cmd(priv, group, ch_idx);
 		group++;
@@ -548,7 +548,7 @@ static int tsc2046_adc_setup_spi_msg(struct tsc2046_adc_priv *priv)
 	 * enabled.
 	 */
 	size = 0;
-	for (ch_idx = 0; ch_idx < priv->dcfg->num_channels; ch_idx++)
+	for (ch_idx = 0; ch_idx < ARRAY_SIZE(priv->l); ch_idx++)
 		size += tsc2046_adc_group_set_layout(priv, ch_idx, ch_idx);
 
 	priv->tx = devm_kzalloc(&priv->spi->dev, size, GFP_KERNEL);
-- 
2.35.1


