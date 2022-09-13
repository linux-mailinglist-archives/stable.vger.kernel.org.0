Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2505B7040
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiIMOY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiIMOXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0187761125;
        Tue, 13 Sep 2022 07:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C160B80F01;
        Tue, 13 Sep 2022 14:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A34C433C1;
        Tue, 13 Sep 2022 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078527;
        bh=fiEddYsxSrl6iGnx31Ma41eqSTgoZ/tijxy7pq9biGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsKWkhyk7A/zHLIyNy0iXvd4g4R/bRqJfCfshoGYLV8/q+ZQqc3dCMDUmAasmOjDz
         w3c6FZ4aqJfFq0T1dxQBt/s8To4umwoVj48h7fUc6IkSUZdzPI2/0bFQ9nYIwgg1+G
         pzOxaUKGR+DoHfUcwblXKUT4bKvVvV2nk+c0OjbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 175/192] hwmon: (mr75203) fix voltage equation for negative source input
Date:   Tue, 13 Sep 2022 16:04:41 +0200
Message-Id: <20220913140418.761829835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eliav Farber <farbere@amazon.com>

[ Upstream commit 227a3a2fc31d8e4bb9c88d4804e19530af245b1b ]

According to Moortec Embedded Voltage Monitor (MEVM) series 3 data
sheet, the minimum input signal is -100mv and maximum input signal
is +1000mv.

The equation used to convert the digital word to voltage uses mixed
types (*val signed and n unsigned), and on 64 bit machines also has
different size, since sizeof(u32) = 4 and sizeof(long) = 8.

So when measuring a negative input, n will be small enough, such that
PVT_N_CONST * n < PVT_R_CONST, and the result of
(PVT_N_CONST * n - PVT_R_CONST) will overflow to a very big positive
32 bit number. Then when storing the result in *val it will be the same
value just in 64 bit (instead of it representing a negative number which
will what happen when sizeof(long) = 4).

When -1023 <= (PVT_N_CONST * n - PVT_R_CONST) <= -1
dividing the number by 1024 should result of in 0, but because ">> 10"
is used, and the sign bit is used to fill the vacated bit positions, it
results in -1 (0xf...fffff) which is wrong.

This change fixes the sign problem and supports negative values by
casting n to long and replacing the shift right with div operation.

Fixes: 9d823351a337 ("hwmon: Add hardware monitoring driver for Moortec MR75203 PVT controller")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220908152449.35457-5-farbere@amazon.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mr75203.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/mr75203.c b/drivers/hwmon/mr75203.c
index be02f32bf143d..6d3b3c499ed83 100644
--- a/drivers/hwmon/mr75203.c
+++ b/drivers/hwmon/mr75203.c
@@ -201,8 +201,18 @@ static int pvt_read_in(struct device *dev, u32 attr, int channel, long *val)
 			return ret;
 
 		n &= SAMPLE_DATA_MSK;
-		/* Convert the N bitstream count into voltage */
-		*val = (PVT_N_CONST * n - PVT_R_CONST) >> PVT_CONV_BITS;
+		/*
+		 * Convert the N bitstream count into voltage.
+		 * To support negative voltage calculation for 64bit machines
+		 * n must be cast to long, since n and *val differ both in
+		 * signedness and in size.
+		 * Division is used instead of right shift, because for signed
+		 * numbers, the sign bit is used to fill the vacated bit
+		 * positions, and if the number is negative, 1 is used.
+		 * BIT(x) may not be used instead of (1 << x) because it's
+		 * unsigned.
+		 */
+		*val = (PVT_N_CONST * (long)n - PVT_R_CONST) / (1 << PVT_CONV_BITS);
 
 		return 0;
 	default:
-- 
2.35.1



