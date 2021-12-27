Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0814800E7
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhL0Pv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbhL0Psj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:48:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D1AC08EAF4;
        Mon, 27 Dec 2021 07:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AD02B810B9;
        Mon, 27 Dec 2021 15:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF26FC36AE7;
        Mon, 27 Dec 2021 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619833;
        bh=/w0Z7Qyy6RMH59IZOH8dZvD049iY/ntHavHg+x7Zffs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5GU0wc2KDqGGEpiCr7xQS+mf2go5+5CUJOc4wJyy6z0Y/FqJhXiiBCcfneqly9uc
         g3LrY06jlvq6CfSd4zClL6ud2GSkJifbbZ2pRUVdaJsMUXM+Yyok7Y9aXX35JJnjd4
         V1zuFljGHbR7nZPRMgtSSHjXbHVfbAi/BB22J1gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/128] hwmon: (lm90) Fix usage of CONFIG2 register in detect function
Date:   Mon, 27 Dec 2021 16:30:28 +0100
Message-Id: <20211227151333.287837264@linuxfoundation.org>
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

[ Upstream commit fce15c45d3fbd9fc1feaaf3210d8e3f8b33dfd3a ]

The detect function had a comment "Make compiler happy" when id did not
read the second configuration register. As it turns out, the code was
checking the contents of this register for manufacturer ID 0xA1 (NXP
Semiconductor/Philips), but never actually read the register. So it
wasn't surprising that the compiler complained, and it indeed had a point.
Fix the code to read the register contents for manufacturer ID 0xa1.

At the same time, the code was reading the register for manufacturer ID
0x41 (Analog Devices), but it was not using the results. In effect it was
just checking if reading the register returned an error. That doesn't
really add much if any value, so stop doing that.

Fixes: f90be42fb383 ("hwmon: (lm90) Refactor reading of config2 register")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 567b7c521f388..d40e3bb801d07 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1448,12 +1448,11 @@ static int lm90_detect(struct i2c_client *client,
 	if (man_id < 0 || chip_id < 0 || config1 < 0 || convrate < 0)
 		return -ENODEV;
 
-	if (man_id == 0x01 || man_id == 0x5C || man_id == 0x41) {
+	if (man_id == 0x01 || man_id == 0x5C || man_id == 0xA1) {
 		config2 = i2c_smbus_read_byte_data(client, LM90_REG_R_CONFIG2);
 		if (config2 < 0)
 			return -ENODEV;
-	} else
-		config2 = 0;		/* Make compiler happy */
+	}
 
 	if ((address == 0x4C || address == 0x4D)
 	 && man_id == 0x01) { /* National Semiconductor */
-- 
2.34.1



