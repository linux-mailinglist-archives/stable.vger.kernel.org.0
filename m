Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98915511D2
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbiFTHvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiFTHvI (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D099DEEF
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A02D611FB
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130CAC3411B;
        Mon, 20 Jun 2022 07:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711466;
        bh=YLkcPyJI2RR/h3lxALeJeIHBBqRI+LhpVqsHTVVCTgI=;
        h=Subject:To:From:Date:From;
        b=PusmthuD3OGnGXhhLCuVyHbZETR5zXgg54Ci4nzXzFkbNmI1czsXnV/trXdouwi/d
         g5wrIAFF1DtCi6x4sEinIuSbhMxtvmZWx/aVFtWKUCIEUU3FY3JILZGyGxG6ttZA+a
         TwUR4aIJx4FOF9CyMmPRcRc3xOVYFC+s39SKswdU=
Subject: patch "iio: adc: rzg2l_adc: add missing fwnode_handle_put() in" added to char-misc-linus
To:     zhangjialin11@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, geert+renesas@glider.be, hulkci@huawei.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:40 +0200
Message-ID: <165571144075222@kroah.com>
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

    iio: adc: rzg2l_adc: add missing fwnode_handle_put() in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d836715f588ea15f905f607c27bc693587058db4 Mon Sep 17 00:00:00 2001
From: Jialin Zhang <zhangjialin11@huawei.com>
Date: Tue, 17 May 2022 11:35:26 +0800
Subject: iio: adc: rzg2l_adc: add missing fwnode_handle_put() in
 rzg2l_adc_parse_properties()

fwnode_handle_put() should be used when terminating
device_for_each_child_node() iteration with break or return to prevent
stale device node references from being left behind.

Fixes: d484c21bacfa ("iio: adc: Add driver for Renesas RZ/G2L A/D converter")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jialin Zhang <zhangjialin11@huawei.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220517033526.2035735-1-zhangjialin11@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/rzg2l_adc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/rzg2l_adc.c b/drivers/iio/adc/rzg2l_adc.c
index 7585144b9715..5b09a93fdf34 100644
--- a/drivers/iio/adc/rzg2l_adc.c
+++ b/drivers/iio/adc/rzg2l_adc.c
@@ -334,11 +334,15 @@ static int rzg2l_adc_parse_properties(struct platform_device *pdev, struct rzg2l
 	i = 0;
 	device_for_each_child_node(&pdev->dev, fwnode) {
 		ret = fwnode_property_read_u32(fwnode, "reg", &channel);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 
-		if (channel >= RZG2L_ADC_MAX_CHANNELS)
+		if (channel >= RZG2L_ADC_MAX_CHANNELS) {
+			fwnode_handle_put(fwnode);
 			return -EINVAL;
+		}
 
 		chan_array[i].type = IIO_VOLTAGE;
 		chan_array[i].indexed = 1;
-- 
2.36.1


