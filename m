Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E836055DD22
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbiF0Ln1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbiF0Lmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FAEDF1F;
        Mon, 27 Jun 2022 04:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DF68610A1;
        Mon, 27 Jun 2022 11:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2266FC3411D;
        Mon, 27 Jun 2022 11:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329795;
        bh=UKbEqA3Zv9VXTEGzuMe35zysRCOL+NKUWHwYEp7etj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5pZDCtBPCdPFWba4wu298zZkGtz1Hn6bHx6P+L2PRzNIBuLo/U4ThMdVw0l1fykK
         fsB/fHUs763vnLQ2O6U1GUAtqgo33WUn5UU3DhMEBVZPOOr6mJ1wSMkA9WsT1aCX3p
         8k6ZJsPwNWCtCzVXJWHQ6hlNdr3Blw2HOnx8kli4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakob Hauser <jahau@rocketmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/135] iio: magnetometer: yas530: Fix memchr_inv() misuse
Date:   Mon, 27 Jun 2022 13:21:28 +0200
Message-Id: <20220627111940.512125939@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit bb52d3691db8cf24cea049235223f3599778f264 ]

The call to check if the calibration is all zeroes is doing
it wrong: memchr_inv() returns NULL if the the calibration
contains all zeroes, but the check is for != NULL.

Fix it up. It's probably not an urgent fix because the inner
check for BIT(7) in data[13] will save us. But fix it.

Fixes: de8860b1ed47 ("iio: magnetometer: Add driver for Yamaha YAS530")
Reported-by: Jakob Hauser <jahau@rocketmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220501195029.151852-1-linus.walleij@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/yamaha-yas530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index 9ff7b0e56cf6..b2bc637150bf 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -639,7 +639,7 @@ static int yas532_get_calibration_data(struct yas5xx *yas5xx)
 	dev_dbg(yas5xx->dev, "calibration data: %*ph\n", 14, data);
 
 	/* Sanity check, is this all zeroes? */
-	if (memchr_inv(data, 0x00, 13)) {
+	if (memchr_inv(data, 0x00, 13) == NULL) {
 		if (!(data[13] & BIT(7)))
 			dev_warn(yas5xx->dev, "calibration is blank!\n");
 	}
-- 
2.35.1



