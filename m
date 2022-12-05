Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE835643382
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiLETgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiLETgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887562657E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 252866131F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3231CC433C1;
        Mon,  5 Dec 2022 19:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268815;
        bh=Pn4HbyywFCMg+ElboVAbJsrPe4GkmNe+kyeTbRr4NPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmrvugysSjrLF7j+8accMK0jgFlZ4zYNV3DP6ddm4UNIMDkjdfvnctdYce2/RoaCL
         WuZf5wtvDrZWcjWiFWXjOKNY3O9glXkiL7qjD+WB2Mssdzms8nwjM1unK/LjsMaL2m
         XXpMV2gPCERbe/vI4ZAEdNYkcFnKPdfNrzMg0jz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Andrew Davis <afd@ti.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/120] iio: health: afe4403: Fix oob read in afe4403_read_raw
Date:   Mon,  5 Dec 2022 20:09:14 +0100
Message-Id: <20221205190807.006167766@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 58143c1ed5882c138a3cd2251a336fc8755f23d9 ]

KASAN report out-of-bounds read as follows:

BUG: KASAN: global-out-of-bounds in afe4403_read_raw+0x42e/0x4c0
Read of size 4 at addr ffffffffc02ac638 by task cat/279

Call Trace:
 afe4403_read_raw
 iio_read_channel_info
 dev_attr_show

The buggy address belongs to the variable:
 afe4403_channel_leds+0x18/0xffffffffffffe9e0

This issue can be reproduced by singe command:

 $ cat /sys/bus/spi/devices/spi0.0/iio\:device0/in_intensity6_raw

The array size of afe4403_channel_leds is less than channels, so access
with chan->address cause OOB read in afe4403_read_raw. Fix it by moving
access before use it.

Fixes: b36e8257641a ("iio: health/afe440x: Use regmap fields")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20221107151946.89260-1-weiyongjun@huaweicloud.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/health/afe4403.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index d4921385aaf7..b5f959bba422 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -245,14 +245,14 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4403_data *afe = iio_priv(indio_dev);
-	unsigned int reg = afe4403_channel_values[chan->address];
-	unsigned int field = afe4403_channel_leds[chan->address];
+	unsigned int reg, field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			reg = afe4403_channel_values[chan->address];
 			ret = afe4403_read(afe, reg, val);
 			if (ret)
 				return ret;
@@ -262,6 +262,7 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			field = afe4403_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[field], val);
 			if (ret)
 				return ret;
-- 
2.35.1



