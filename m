Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8047FFB3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbhL0Pku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbhL0Pic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D998C07E5E1;
        Mon, 27 Dec 2021 07:37:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E12A61119;
        Mon, 27 Dec 2021 15:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A11C36AE7;
        Mon, 27 Dec 2021 15:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619457;
        bh=6hS58f7R7ZEEHxmFlRA5AfRtmnvy02N0fZplQ/UklTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rO3U4IebAJgG2ZGRZxejdGVhoquUJirzikGX3mHWPR6g4Jsjq8rGw/9uDXcVIlZL
         p7sw7yIACx4Ji2mgvlkO3fyXa/3Oeh3EaWuE1poaojgGsYOzRXwnrLbayUVJyMuXiX
         lUichAKJQy7Yt8KxkEAFSF50fgfgDlB7jFdOgkcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/76] hwmon: (lm90) Fix usage of CONFIG2 register in detect function
Date:   Mon, 27 Dec 2021 16:30:45 +0100
Message-Id: <20211227151325.734500476@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
index ebbfd5f352c06..ef55a1486099f 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1438,12 +1438,11 @@ static int lm90_detect(struct i2c_client *client,
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



