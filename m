Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA81A40E04D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhIPQUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241199AbhIPQTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8526C61130;
        Thu, 16 Sep 2021 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808799;
        bh=tJx5Me14Up6H331wYl0tEsLU0NwA6R6MkytkCBcxx38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahZIRuEDdhFVTLyVM6lpMn/zDK+LiQ2haHpqpkU7+/lL5tpfMPK6ANVN+Q1kvcafM
         /jfv/1sVlkiIquafkM6Gk6QdDTO1hAMNkwdsrvYWf+/AQjrpdVdzEyGDmuoq78yR4O
         oe9m7UD/h/eej0j1giI3EBdwZWMQx7xEpcaJ6JpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/306] hwmon: (pmbus/ibm-cffps) Fix write bits for LED control
Date:   Thu, 16 Sep 2021 17:59:32 +0200
Message-Id: <20210916155801.797580566@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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



