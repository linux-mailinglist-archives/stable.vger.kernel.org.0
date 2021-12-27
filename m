Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9594800E8
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240315AbhL0Pvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbhL0PtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:49:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE02BC08EAFB;
        Mon, 27 Dec 2021 07:43:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F1AB810CF;
        Mon, 27 Dec 2021 15:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB350C36AEA;
        Mon, 27 Dec 2021 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619836;
        bh=KgnVg2YEYix/uiAFihifYXS3lE4ZhUv7KUoFvE0PIEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGQedNhkD8RDXNI/DpUfVaV3brZd6P0lqXdBKke1LSezVNskyx272P5mJLrLYE4Z9
         9GFvlZePY1Piu51HUnjQEEnyJAPUFEHH6kbaZf9gGOwJ9P19/zd69S0Ylxgp4UXWJ/
         MROFVqGNBwBag3OmZGYdRtWyyXBmqN8b1dvxCLMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/128] hwmon: (lm90) Prevent integer overflow/underflow in hysteresis calculations
Date:   Mon, 27 Dec 2021 16:30:29 +0100
Message-Id: <20211227151333.323682429@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 55840b9eae5367b5d5b29619dc2fb7e4596dba46 ]

Commit b50aa49638c7 ("hwmon: (lm90) Prevent integer underflows of
temperature calculations") addressed a number of underflow situations
when writing temperature limits. However, it missed one situation, seen
when an attempt is made to set the hysteresis value to MAX_LONG and the
critical temperature limit is negative.

Use clamp_val() when setting the hysteresis temperature to ensure that
the provided value can never overflow or underflow.

Fixes: b50aa49638c7 ("hwmon: (lm90) Prevent integer underflows of temperature calculations")
Cc: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index d40e3bb801d07..f6e6c7c6c73f8 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1143,8 +1143,8 @@ static int lm90_set_temphyst(struct lm90_data *data, long val)
 	else
 		temp = temp_from_s8(data->temp8[LOCAL_CRIT]);
 
-	/* prevent integer underflow */
-	val = max(val, -128000l);
+	/* prevent integer overflow/underflow */
+	val = clamp_val(val, -128000l, 255000l);
 
 	data->temp_hyst = hyst_to_reg(temp - val);
 	err = i2c_smbus_write_byte_data(client, LM90_REG_W_TCRIT_HYST,
-- 
2.34.1



