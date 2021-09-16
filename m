Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF4040E800
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349460AbhIPRgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353612AbhIPRea (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885D06322B;
        Thu, 16 Sep 2021 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810922;
        bh=ZMGrjSMZimhJuSbuiJ/hE2EWyRHaKnHeNyrA6L3KprY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTcmAC/MGbvYBNEns8xmQjMRdVu5KNkwKujUJL3/K5Qz1fyXNBhmRGDhjGzB/bEAC
         40yd4GfPv6ldQgRyB8siZdLrbhNisYtT80BEaQdy0A91BMQr/SQisWXLYT/jIA+JA5
         QoQ08R6Df6bB2gL9r3QkC8Yhfkn1mB+YjdeaF3ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 318/432] hwmon: (pmbus/ibm-cffps) Fix write bits for LED control
Date:   Thu, 16 Sep 2021 18:01:07 +0200
Message-Id: <20210916155821.603476621@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



