Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5E755DA9A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiF0LyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238626AbiF0Lv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE0A461;
        Mon, 27 Jun 2022 04:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F28612E3;
        Mon, 27 Jun 2022 11:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD7DC341C7;
        Mon, 27 Jun 2022 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330295;
        bh=vdb3E6WRlDL20adQ9KZ21R2W9oW3boQenfgRmu7+Rxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppL0uATf7RO5lJ8ljfiUwJNTtY7AH4CEMWOs+Uf7eL3IFf5nsW4oomXU/BV2a8PyW
         Xwg+B6sxo/qxbEcFxlBgSMIiMaHRYgtPGaEZ5AUR4kj+ujXSu0h32uRuC8yZLAh3Qe
         mdIRe4pcGNWVV9bUymWks/7lQWvIyoeb2S6ZbFtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jialin Zhang <zhangjialin11@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 150/181] iio: adc: ti-ads131e08: add missing fwnode_handle_put() in ads131e08_alloc_channels()
Date:   Mon, 27 Jun 2022 13:22:03 +0200
Message-Id: <20220627111949.033741522@linuxfoundation.org>
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

commit 47dcf770abc793f347a65a24c24d550c936f08b0 upstream.

fwnode_handle_put() should be used when terminating
device_for_each_child_node() iteration with break or return to prevent
stale device node references from being left behind.

Fixes: d935eddd2799 ("iio: adc: Add driver for Texas Instruments ADS131E0x ADC family")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jialin Zhang <zhangjialin11@huawei.com>
Link: https://lore.kernel.org/r/20220517033020.2033324-1-zhangjialin11@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads131e08.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-ads131e08.c
+++ b/drivers/iio/adc/ti-ads131e08.c
@@ -739,7 +739,7 @@ static int ads131e08_alloc_channels(stru
 	device_for_each_child_node(dev, node) {
 		ret = fwnode_property_read_u32(node, "reg", &channel);
 		if (ret)
-			return ret;
+			goto err_child_out;
 
 		ret = fwnode_property_read_u32(node, "ti,gain", &tmp);
 		if (ret) {
@@ -747,7 +747,7 @@ static int ads131e08_alloc_channels(stru
 		} else {
 			ret = ads131e08_pga_gain_to_field_value(st, tmp);
 			if (ret < 0)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].pga_gain = tmp;
 		}
@@ -758,7 +758,7 @@ static int ads131e08_alloc_channels(stru
 		} else {
 			ret = ads131e08_validate_channel_mux(st, tmp);
 			if (ret)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].mux = tmp;
 		}
@@ -784,6 +784,10 @@ static int ads131e08_alloc_channels(stru
 	st->channel_config = channel_config;
 
 	return 0;
+
+err_child_out:
+	fwnode_handle_put(node);
+	return ret;
 }
 
 static void ads131e08_regulator_disable(void *data)


