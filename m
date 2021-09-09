Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986D5404FA0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348731AbhIIMVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347874AbhIIMRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:17:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCC361A82;
        Thu,  9 Sep 2021 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188192;
        bh=ZMGrjSMZimhJuSbuiJ/hE2EWyRHaKnHeNyrA6L3KprY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMB5c/FSSAQOKzvozxONUbb9i0SMdzwJmgS0Dbo+KrTsvq5mJtrd/XOnPbrKYaxDW
         Tr5r66lWjRJOaXdguDZthT0VaokDHm0Lia4dxth7Vs9o0cciWvC5hZBuCZqe6tDsJ+
         ffyyqyahBMaPoW//vIxhXGf5VlX1oBOjFQP/HBFb4KAINWXVjkMnp8pLtbbGTZcOXW
         yDHRlnC488dBsGA16WWI9RRDN1f7pKs/MY6aoXb3ZIpbSsZuDadPTmVnqS1+Jk6Hbf
         Dkjy/MznMxyZ5zSdQVRdjTS8cSP0DiVN3TgmnfYPv0BxMOo+2sfZ2WBO/StNQyUbjT
         unZLLm8DX2sUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 152/219] hwmon: (pmbus/ibm-cffps) Fix write bits for LED control
Date:   Thu,  9 Sep 2021 07:45:28 -0400
Message-Id: <20210909114635.143983-152-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Wyman <bjwyman@gmail.com>

[ Upstream commit 76b72736f574ec38b3e94603ea5f74b1853f26b0 ]

When doing a PMBus write for the LED control on the IBM Common Form
Factor Power Supplies (ibm-cffps), the DAh command requires that bit 7
be low and bit 6 be high in order to indicate that you are truly
attempting to do a write.

Signed-off-by: Brandon Wyman <bjwyman@gmail.com>
Link: https://lore.kernel.org/r/20210806225131.1808759-1-bjwyman@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ibm-cffps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/ibm-cffps.c b/drivers/hwmon/pmbus/ibm-cffps.c
index 5668d8305b78..df712ce4b164 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -50,9 +50,9 @@
 #define CFFPS_MFR_VAUX_FAULT			BIT(6)
 #define CFFPS_MFR_CURRENT_SHARE_WARNING		BIT(7)
 
-#define CFFPS_LED_BLINK				BIT(0)
-#define CFFPS_LED_ON				BIT(1)
-#define CFFPS_LED_OFF				BIT(2)
+#define CFFPS_LED_BLINK				(BIT(0) | BIT(6))
+#define CFFPS_LED_ON				(BIT(1) | BIT(6))
+#define CFFPS_LED_OFF				(BIT(2) | BIT(6))
 #define CFFPS_BLINK_RATE_MS			250
 
 enum {
-- 
2.30.2

