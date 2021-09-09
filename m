Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40819404C58
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244895AbhIIL4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244321AbhIILyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9EA611C3;
        Thu,  9 Sep 2021 11:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187891;
        bh=ZMGrjSMZimhJuSbuiJ/hE2EWyRHaKnHeNyrA6L3KprY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH4tjT1U6IH7LKoZFDlveoqjLM9sydAz4Pb7bPaH1BZs+90mLmg4k0zOZfYVvW/it
         ll8tL313XNp/xitWpoMsKkDQ27EUF8guhP5B5EMqTrsplSvf0jmb1c1G6fw+0K7bU5
         KoRVESeSQnJbpm1JKBK3oJlESHpnJLkIfaQ7EF6JpLl1jwBstdTF6j7oYfaptCeS3B
         ldtg1WgS4Sg2EjyXU2pArBymJysVs0426zxhwC6OxPX5KK4kqSg8iN4ozBCt1GfNZU
         0WacOb6scSBpgWFyoSJQq2F4+I3mgtSFBUyAem5XiEfV16ozzD93o4Uou88FWVHJXn
         a/HAPhu7lp5qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 172/252] hwmon: (pmbus/ibm-cffps) Fix write bits for LED control
Date:   Thu,  9 Sep 2021 07:39:46 -0400
Message-Id: <20210909114106.141462-172-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

