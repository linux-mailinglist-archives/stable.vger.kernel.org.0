Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A4C60AA57
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiJXNcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiJXNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4553F30E;
        Mon, 24 Oct 2022 05:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FF26128E;
        Mon, 24 Oct 2022 12:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8670C433D6;
        Mon, 24 Oct 2022 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614820;
        bh=fS92YeGgAE7/jfevSZZ9qKCTlZHn8Zq5p+Rkx1Cwmg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JWnIHHd3cDG6Bwk0DiZ/nbNvs5Ig+HUwu1VyE04J/7ZubpeI37b613PuqWG8mV6O
         TFr3vViv8xDkGBKwSJ1aqmwEjczGbruSxyb2N4J8gErprVd0E/pKkMKgSLPXEhNuqH
         +ScNq+r7z1us6CmtBPqxh4SalE+OIm8WbLPq9GpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Denys Zagorui <dzagorui@cisco.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 016/530] iio: ltc2497: Fix reading conversion results
Date:   Mon, 24 Oct 2022 13:26:00 +0200
Message-Id: <20221024113045.756200162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 7f4f1096d5921f5d90547596f9ce80e0b924f887 upstream.

After the result of the previous conversion is read the chip
automatically starts a new conversion and doesn't accept new i2c
transfers until this conversion is completed which makes the function
return failure.

So add an early return iff the programming of the new address isn't
needed. Note this will not fix the problem in general, but all cases
that are currently used. Once this changes we get the failure back, but
this can be addressed when the need arises.

Fixes: 69548b7c2c4f ("iio: adc: ltc2497: split protocol independent part in a separate module ")
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Denys Zagorui <dzagorui@cisco.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220815091647.1523532-1-dzagorui@cisco.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ltc2497.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -41,6 +41,19 @@ static int ltc2497_result_and_measure(st
 		}
 
 		*val = (be32_to_cpu(st->buf) >> 14) - (1 << 17);
+
+		/*
+		 * The part started a new conversion at the end of the above i2c
+		 * transfer, so if the address didn't change since the last call
+		 * everything is fine and we can return early.
+		 * If not (which should only happen when some sort of bulk
+		 * conversion is implemented) we have to program the new
+		 * address. Note that this probably fails as the conversion that
+		 * was triggered above is like not complete yet and the two
+		 * operations have to be done in a single transfer.
+		 */
+		if (ddata->addr_prev == address)
+			return 0;
 	}
 
 	ret = i2c_smbus_write_byte(st->client,


