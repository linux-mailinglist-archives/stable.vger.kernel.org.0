Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF34657C4F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbiL1PbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiL1PbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9961915F12
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D196154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4919FC433EF;
        Wed, 28 Dec 2022 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241466;
        bh=kcQgg9ehBOzyXNlFza6/yPpkNfY3mOMvIREc/aWgUCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtPly31/8986AqQVPdm5kJU26bfTuwnKz9LckEcSfhjJRBkRi6WconWhbVVQpDoYJ
         ejAkKKkHc+Ey3EHWhFG458wcS20OhUecG3duV0qe0n0T+NAefmV/2lU9zZsxTM23CD
         WDthQTzwkUe/8dKB7KUdsW7HllPVLkCngO1KZnWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 473/731] iio: temperature: ltc2983: make bulk write buffer DMA-safe
Date:   Wed, 28 Dec 2022 15:39:40 +0100
Message-Id: <20221228144310.261135296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Cosmin Tanislav <cosmin.tanislav@analog.com>

[ Upstream commit 5e0176213949724fbe9a8e4a39817edce337b8a0 ]

regmap_bulk_write() does not guarantee implicit DMA-safety,
even though the current implementation duplicates the given
buffer. Do not rely on it.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Link: https://lore.kernel.org/r/20221103130041.2153295-2-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/ltc2983.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 8306daa77908..b2ae2d2c7eef 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -205,6 +205,7 @@ struct ltc2983_data {
 	 * Holds the converted temperature
 	 */
 	__be32 temp ____cacheline_aligned;
+	__be32 chan_val;
 };
 
 struct ltc2983_sensor {
@@ -309,19 +310,18 @@ static int __ltc2983_fault_handler(const struct ltc2983_data *st,
 	return 0;
 }
 
-static int __ltc2983_chan_assign_common(const struct ltc2983_data *st,
+static int __ltc2983_chan_assign_common(struct ltc2983_data *st,
 					const struct ltc2983_sensor *sensor,
 					u32 chan_val)
 {
 	u32 reg = LTC2983_CHAN_START_ADDR(sensor->chan);
-	__be32 __chan_val;
 
 	chan_val |= LTC2983_CHAN_TYPE(sensor->type);
 	dev_dbg(&st->spi->dev, "Assign reg:0x%04X, val:0x%08X\n", reg,
 		chan_val);
-	__chan_val = cpu_to_be32(chan_val);
-	return regmap_bulk_write(st->regmap, reg, &__chan_val,
-				 sizeof(__chan_val));
+	st->chan_val = cpu_to_be32(chan_val);
+	return regmap_bulk_write(st->regmap, reg, &st->chan_val,
+				 sizeof(st->chan_val));
 }
 
 static int __ltc2983_chan_custom_sensor_assign(struct ltc2983_data *st,
-- 
2.35.1



