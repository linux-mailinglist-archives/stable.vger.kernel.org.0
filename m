Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD44051EB
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354647AbhIIMjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354564AbhIIMfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BA16138D;
        Thu,  9 Sep 2021 11:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188436;
        bh=tJx5Me14Up6H331wYl0tEsLU0NwA6R6MkytkCBcxx38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kt7ajq/E25s4RTzaTTidyeBQGenVZUPt2eGOv/18hp4/araqn+KAvC7wg+o1zMUnf
         SEFYpCRCNHnJObjXF+eVDRKfsoCJ0j9oREdCRQAswhmzIm2wnf3jXDNBA7Lq4EFV0i
         /ijhcvmmhcR9lK41aghHjynim100PNfBKvEejRfZTShcX5AB2hZQeZSKylHQG/dhHa
         V/aXabqeksnRdRbw1v3HKjW5it9myYp709bpzgQ+MsmZ96ir+821pDXwQCD3k1LHCI
         PZ9ERQBnNBsDcajWGYqnKqX/MaRm00CB4nciVE4VWLjBK/YVd9slz9VQU984+1mBIh
         9KELMZR+UOGYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 122/176] hwmon: (pmbus/ibm-cffps) Fix write bits for LED control
Date:   Thu,  9 Sep 2021 07:50:24 -0400
Message-Id: <20210909115118.146181-122-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 2fb7540ee952..79bc2032dcb2 100644
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

