Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673E2450E21
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbhKOSLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240021AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4114A63378;
        Mon, 15 Nov 2021 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998094;
        bh=QNFuzzIGZvHT10f41ue52fnyrfdFD2+x6iyDw/yT3mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1jLm1LoxztC7sjKiClCZyAaiECwwBZe8XunLfxZFusM1jNbh9RhH08qJj6O6+0kv
         FrUdYhnHWf1dclhHmN7Z0STwSAjkdhEcKCGiCPbCO8DUVbhV40Ns1L+TzIRApzdwLM
         9RoGfhYBtiVRu9owKHSwypdToJXxrl9ats6mA7os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/575] of: unittest: fix EXPECT text for gpio hog errors
Date:   Mon, 15 Nov 2021 18:01:50 +0100
Message-Id: <20211115165357.094751176@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit e85860e5bc077865a04f0a88d0b0335d3200484a ]

The console message text for gpio hog errors does not match
what unittest expects.

Fixes: f4056e705b2ef ("of: unittest: add overlay gpio test to catch gpio hog problem")
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Link: https://lore.kernel.org/r/20211029013225.2048695-1-frowand.list@gmail.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index eb51bc1474401..1d4b0b7d0cc10 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1682,19 +1682,19 @@ static void __init of_unittest_overlay_gpio(void)
 	 */
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-B-input) hogged as input\n");
+		     "gpio-<<int>> (line-B-input): hogged as input\n");
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-A-input) hogged as input\n");
+		     "gpio-<<int>> (line-A-input): hogged as input\n");
 
 	ret = platform_driver_register(&unittest_gpio_driver);
 	if (unittest(ret == 0, "could not register unittest gpio driver\n"))
 		return;
 
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-A-input) hogged as input\n");
+		   "gpio-<<int>> (line-A-input): hogged as input\n");
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-B-input) hogged as input\n");
+		   "gpio-<<int>> (line-B-input): hogged as input\n");
 
 	unittest(probe_pass_count + 2 == unittest_gpio_probe_pass_count,
 		 "unittest_gpio_probe() failed or not called\n");
@@ -1721,7 +1721,7 @@ static void __init of_unittest_overlay_gpio(void)
 	chip_request_count = unittest_gpio_chip_request_count;
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-D-input) hogged as input\n");
+		     "gpio-<<int>> (line-D-input): hogged as input\n");
 
 	/* overlay_gpio_03 contains gpio node and child gpio hog node */
 
@@ -1729,7 +1729,7 @@ static void __init of_unittest_overlay_gpio(void)
 		 "Adding overlay 'overlay_gpio_03' failed\n");
 
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-D-input) hogged as input\n");
+		   "gpio-<<int>> (line-D-input): hogged as input\n");
 
 	unittest(probe_pass_count + 1 == unittest_gpio_probe_pass_count,
 		 "unittest_gpio_probe() failed or not called\n");
@@ -1768,7 +1768,7 @@ static void __init of_unittest_overlay_gpio(void)
 	 */
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-C-input) hogged as input\n");
+		     "gpio-<<int>> (line-C-input): hogged as input\n");
 
 	/* overlay_gpio_04b contains child gpio hog node */
 
@@ -1776,7 +1776,7 @@ static void __init of_unittest_overlay_gpio(void)
 		 "Adding overlay 'overlay_gpio_04b' failed\n");
 
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-C-input) hogged as input\n");
+		   "gpio-<<int>> (line-C-input): hogged as input\n");
 
 	unittest(chip_request_count + 1 == unittest_gpio_chip_request_count,
 		 "unittest_gpio_chip_request() called %d times (expected 1 time)\n",
-- 
2.33.0



