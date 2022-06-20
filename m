Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3A25511D3
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbiFTHvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiFTHvG (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116DD101EA
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B205BB80EAE
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198C9C3411B;
        Mon, 20 Jun 2022 07:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711463;
        bh=phdoNnpzQ+n8C3LHWNlLGdywNdbuVkOx+QgTVF7hPuE=;
        h=Subject:To:From:Date:From;
        b=wUwyI/rtWWldNJzMQFapVezVBWh1NpMVX5EWfEUSMQRI5Prhpu0K/hfo/+EBs4M66
         AGh48/wxb60wQMNEiFaS4EIKoM8XiW36FA8IdaieSJq/fng9DVo8Fd1tLCrF8N//SY
         QcSprtN1R3tJRXGw2Fj/h1jBM4f83CXIRGk/5+4o=
Subject: patch "iio: adc: ti-ads131e08: add missing fwnode_handle_put() in" added to char-misc-linus
To:     zhangjialin11@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:40 +0200
Message-ID: <1655711440178158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads131e08: add missing fwnode_handle_put() in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 47dcf770abc793f347a65a24c24d550c936f08b0 Mon Sep 17 00:00:00 2001
From: Jialin Zhang <zhangjialin11@huawei.com>
Date: Tue, 17 May 2022 11:30:20 +0800
Subject: iio: adc: ti-ads131e08: add missing fwnode_handle_put() in
 ads131e08_alloc_channels()

fwnode_handle_put() should be used when terminating
device_for_each_child_node() iteration with break or return to prevent
stale device node references from being left behind.

Fixes: d935eddd2799 ("iio: adc: Add driver for Texas Instruments ADS131E0x ADC family")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jialin Zhang <zhangjialin11@huawei.com>
Link: https://lore.kernel.org/r/20220517033020.2033324-1-zhangjialin11@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads131e08.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-ads131e08.c b/drivers/iio/adc/ti-ads131e08.c
index 0c2025a22575..80a09817c119 100644
--- a/drivers/iio/adc/ti-ads131e08.c
+++ b/drivers/iio/adc/ti-ads131e08.c
@@ -739,7 +739,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 	device_for_each_child_node(dev, node) {
 		ret = fwnode_property_read_u32(node, "reg", &channel);
 		if (ret)
-			return ret;
+			goto err_child_out;
 
 		ret = fwnode_property_read_u32(node, "ti,gain", &tmp);
 		if (ret) {
@@ -747,7 +747,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 		} else {
 			ret = ads131e08_pga_gain_to_field_value(st, tmp);
 			if (ret < 0)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].pga_gain = tmp;
 		}
@@ -758,7 +758,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 		} else {
 			ret = ads131e08_validate_channel_mux(st, tmp);
 			if (ret)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].mux = tmp;
 		}
@@ -784,6 +784,10 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 	st->channel_config = channel_config;
 
 	return 0;
+
+err_child_out:
+	fwnode_handle_put(node);
+	return ret;
 }
 
 static void ads131e08_regulator_disable(void *data)
-- 
2.36.1


