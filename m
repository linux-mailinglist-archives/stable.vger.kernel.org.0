Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9715C6DEF60
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjDLIuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjDLIuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:50:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A58C976C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8256314E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E81C4339B;
        Wed, 12 Apr 2023 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289378;
        bh=04ytoBOGqFml9HH5bQ3aHTX76z7gfY5bCP/TJPK7dZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLo/67GTItbZDT/Se3o/9AoIn7su3KPdFhWTVSbECG42wLkG6LcbUaiy3DFo8gRBH
         fnmicqvQ0voOv4BDGc2e2q5y1Ji70MOiTwliMZU4qjrPG2p1yK8gJHvlChhAFWsL47
         okr7bBt+7H0i9pBgAwYXYOm7Rk28+YxVz/XbQKTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Ibrahim Tilki <Ibrahim.Tilki@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 076/173] iio: adc: max11410: fix read_poll_timeout() usage
Date:   Wed, 12 Apr 2023 10:33:22 +0200
Message-Id: <20230412082841.135528121@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit 7b3825e9487d77e83bf1e27b10a74cd729b8f972 upstream.

Even though we are passing 'ret' as stop condition for
read_poll_timeout(), that return code is still being ignored. The reason
is that the poll will stop if the passed condition is true which will
happen if the passed op() returns error. However, read_poll_timeout()
returns 0 if the *complete* condition evaluates to true. Therefore, the
error code returned by op() will be ignored.

To fix this we need to check for both error codes:
 * The one returned by read_poll_timeout() which is either 0 or
ETIMEDOUT.
 * The one returned by the passed op().

Fixes: a44ef7c46097 ("iio: adc: add max11410 adc driver")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Ibrahim Tilki <Ibrahim.Tilki@analog.com>
Link: https://lore.kernel.org/r/20230307095303.713251-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max11410.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/iio/adc/max11410.c
+++ b/drivers/iio/adc/max11410.c
@@ -413,13 +413,17 @@ static int max11410_sample(struct max114
 		if (!ret)
 			return -ETIMEDOUT;
 	} else {
+		int ret2;
+
 		/* Wait for status register Conversion Ready flag */
-		ret = read_poll_timeout(max11410_read_reg, ret,
-					ret || (val & MAX11410_STATUS_CONV_READY_BIT),
+		ret = read_poll_timeout(max11410_read_reg, ret2,
+					ret2 || (val & MAX11410_STATUS_CONV_READY_BIT),
 					5000, MAX11410_CONVERSION_TIMEOUT_MS * 1000,
 					true, st, MAX11410_REG_STATUS, &val);
 		if (ret)
 			return ret;
+		if (ret2)
+			return ret2;
 	}
 
 	/* Read ADC Data */
@@ -850,17 +854,21 @@ static int max11410_init_vref(struct dev
 
 static int max11410_calibrate(struct max11410_state *st, u32 cal_type)
 {
-	int ret, val;
+	int ret, ret2, val;
 
 	ret = max11410_write_reg(st, MAX11410_REG_CAL_START, cal_type);
 	if (ret)
 		return ret;
 
 	/* Wait for status register Calibration Ready flag */
-	return read_poll_timeout(max11410_read_reg, ret,
-				 ret || (val & MAX11410_STATUS_CAL_READY_BIT),
-				 50000, MAX11410_CALIB_TIMEOUT_MS * 1000, true,
-				 st, MAX11410_REG_STATUS, &val);
+	ret = read_poll_timeout(max11410_read_reg, ret2,
+				ret2 || (val & MAX11410_STATUS_CAL_READY_BIT),
+				50000, MAX11410_CALIB_TIMEOUT_MS * 1000, true,
+				st, MAX11410_REG_STATUS, &val);
+	if (ret)
+		return ret;
+
+	return ret2;
 }
 
 static int max11410_self_calibrate(struct max11410_state *st)


