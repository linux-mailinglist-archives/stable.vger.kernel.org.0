Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6CEC3985
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJAPwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 11:52:07 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32852 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfJAPwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 11:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569945126; x=1601481126;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=nLVYk2yIxDtYBWgS2GCvSmYfxdD9HmyEs1OoB1XIuSk=;
  b=k/Cn5wxTcmfZYVxNfhQ1iXGTKcTkkESZAyiFKizGYHTGRQheJTNtih5K
   oPyqHAPYq8nz60gufeIItGQfCl6geAhxfDhRiixplmKDRvuNgaCPS8oq4
   yYYCIwQV+kR0jqlwgXuHiD/b/abSDGsEgYHLG/IGa33nLl9zdtMA+49Fv
   o=;
X-IronPort-AV: E=Sophos;i="5.64,571,1559520000"; 
   d="scan'208";a="754678097"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 01 Oct 2019 15:52:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 9BA53A22D5;
        Tue,  1 Oct 2019 15:52:00 +0000 (UTC)
Received: from EX13D02UWC001.ant.amazon.com (10.43.162.243) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 1 Oct 2019 15:52:00 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D02UWC001.ant.amazon.com (10.43.162.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 1 Oct 2019 15:51:59 +0000
Received: from 8c859006a84e.ant.amazon.com (172.26.203.30) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 1 Oct 2019 15:51:58 +0000
From:   Patrick Williams <alpawi@amazon.com>
CC:     Patrick Williams <alpawi@amazon.com>,
        Patrick Williams <patrick@stwcx.xyz>, <stable@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] pinctrl: armada-37xx: swap polarity on LED group
Date:   Tue, 1 Oct 2019 10:51:38 -0500
Message-ID: <20191001155154.99710-1-alpawi@amazon.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The configuration registers for the LED group have inverted
polarity, which puts the GPIO into open-drain state when used in
GPIO mode.  Switch to '0' for GPIO and '1' for LED modes.

Fixes: 87466ccd9401 ("pinctrl: armada-37xx: Add pin controller support for Armada 37xx")
Signed-off-by: Patrick Williams <alpawi@amazon.com>
Cc: <stable@vger.kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 6462d3ca7ceb..6310963ce5f0 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -183,10 +183,10 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
 	PIN_GRP_EXTRA("uart2", 9, 2, BIT(1) | BIT(13) | BIT(14) | BIT(19),
 		      BIT(1) | BIT(13) | BIT(14), BIT(1) | BIT(19),
 		      18, 2, "gpio", "uart"),
-	PIN_GRP_GPIO("led0_od", 11, 1, BIT(20), "led"),
-	PIN_GRP_GPIO("led1_od", 12, 1, BIT(21), "led"),
-	PIN_GRP_GPIO("led2_od", 13, 1, BIT(22), "led"),
-	PIN_GRP_GPIO("led3_od", 14, 1, BIT(23), "led"),
+	PIN_GRP_GPIO_2("led0_od", 11, 1, BIT(20), BIT(20), 0, "led"),
+	PIN_GRP_GPIO_2("led1_od", 12, 1, BIT(21), BIT(21), 0, "led"),
+	PIN_GRP_GPIO_2("led2_od", 13, 1, BIT(22), BIT(22), 0, "led"),
+	PIN_GRP_GPIO_2("led3_od", 14, 1, BIT(23), BIT(23), 0, "led"),
 
 };
 
-- 
2.17.2 (Apple Git-113)

