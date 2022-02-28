Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6937B4C75E8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239264AbiB1R45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbiB1RxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB8DA996B;
        Mon, 28 Feb 2022 09:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FFB26154F;
        Mon, 28 Feb 2022 17:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187C8C340E7;
        Mon, 28 Feb 2022 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070022;
        bh=kcKxsW8Q8xpBHWLZSMDqe7m3Do9CkKyNlANTKWSkuSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEKpcRkYJWsIklHQxRVDeHOXXg0DlbIAmkQ6e30SFDHEm9d5tpTwCWOnglEBkaVRw
         IGnxbLYNFONushT/QUGQ9f7wssKQCFjrZhc59+S2q7xAtgNWZZc/mob8lstb6w8P8V
         lEA8xKr2vqDBbeAebEaQ5Q9OeTHEJhByaO2EXrwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 098/139] iio: adc: tsc2046: fix memory corruption by preventing array overflow
Date:   Mon, 28 Feb 2022 18:24:32 +0100
Message-Id: <20220228172357.946505749@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit b7a78a8adaa8849c02f174d707aead0f85dca0da upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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



