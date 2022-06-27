Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82EF55C9D6
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbiF0Lxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiF0Lvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107DC959A;
        Mon, 27 Jun 2022 04:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41BB612AC;
        Mon, 27 Jun 2022 11:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6C3C3411D;
        Mon, 27 Jun 2022 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330289;
        bh=ScQpEIpxHjSqDrGr76uERJiMqoOSdBON+D/RKrJ4bQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BJw7fyU1OLiNFT+7vPvwWeGDjE4viQFAvQn/GbheRmV5BRAqBpC3zxMnky8dm472
         2wzgb3bnp7JA5xSMrFVOOmwA8Tqn+s3KUcIOZPKJYVMgzB0mh8SR4jvb2RA8U4a10+
         g2/jMXIMLVZF0U8r9CrksKD7rQO8gsz2SQwLEUfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jialin Zhang <zhangjialin11@huawei.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 148/181] iio: adc: rzg2l_adc: add missing fwnode_handle_put() in rzg2l_adc_parse_properties()
Date:   Mon, 27 Jun 2022 13:22:01 +0200
Message-Id: <20220627111948.976077610@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Jialin Zhang <zhangjialin11@huawei.com>

commit d836715f588ea15f905f607c27bc693587058db4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rzg2l_adc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/rzg2l_adc.c
+++ b/drivers/iio/adc/rzg2l_adc.c
@@ -334,11 +334,15 @@ static int rzg2l_adc_parse_properties(st
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


