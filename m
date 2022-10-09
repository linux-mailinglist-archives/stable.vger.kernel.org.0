Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072AB5F91E3
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiJIWme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiJIWkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:40:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4DE3CBF2;
        Sun,  9 Oct 2022 15:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E889B80DDB;
        Sun,  9 Oct 2022 22:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B898C433D6;
        Sun,  9 Oct 2022 22:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354068;
        bh=bALSsrDsYiGvrQhdjWgMeF/pAodNNbEgK4sWVnAJ1Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jl6DCv5/0scl8aINTYltBCfQhd+5t3OL3Qh+vuWrM2nJaRTLEGoM+8/19wFDvbbzs
         OlTYHuKv+jAVzw80wN7EvG31RklspjH9UzNaZyuGWOn9opxsRKUvBH5S/q0VakMxIM
         tPLX5l7bNY1x4Otrn0Yt4WIBNKhfWqPQJgox4iDm5K3ve8Y5zmfrH3xl7aLXqEc0q7
         h9yZGOCw65nHtFAV9C0ixhnco/0vP6uW4PXcQZxVoBqHet2hbsQY2AFjzU/x5Lilqn
         kEd89zt/h3EeYYePGp0woALgmoWycbMn0cMN6r+LTg7A1BUGks9gnYyKC86Sfjzr58
         K1/Khy0rs1AcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 42/46] hwmon: (sht4x) do not overflow clamping operation on 32-bit platforms
Date:   Sun,  9 Oct 2022 18:19:07 -0400
Message-Id: <20221009221912.1217372-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit f9c0cf8f26de367c58e48b02b1cdb9c377626e6f ]

On 32-bit platforms, long is 32 bits, so (long)UINT_MAX is less than
(long)SHT4X_MIN_POLL_INTERVAL, which means the clamping operation is
bogus. Fix this by clamping at INT_MAX, so that the upperbound is the
same on all platforms.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20220924101151.4168414-1-Jason@zx2c4.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 09c2a0b06444..9aeb3dbf6c20 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -129,7 +129,7 @@ static int sht4x_read_values(struct sht4x_data *data)
 
 static ssize_t sht4x_interval_write(struct sht4x_data *data, long val)
 {
-	data->update_interval = clamp_val(val, SHT4X_MIN_POLL_INTERVAL, UINT_MAX);
+	data->update_interval = clamp_val(val, SHT4X_MIN_POLL_INTERVAL, INT_MAX);
 
 	return 0;
 }
-- 
2.35.1

