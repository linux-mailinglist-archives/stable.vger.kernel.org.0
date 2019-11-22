Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C231106ECC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbfKVK6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730502AbfKVK6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8341F20721;
        Fri, 22 Nov 2019 10:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420280;
        bh=yW1ZY926CRyEvYL8nf0PNItB9Msvnl5KBJPysHlwXVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAHzKmrLXwAX8HfWj8eYN6ogp/frZfYLAgikXiQIP/9DjXQu2IEhsHiizhkIf9H1V
         gAv+XQDfnV10eb67z7pPymG5d10BFvU31vgQH7tRY6Zqwr+W2zFDo68zQyCs/BmkBt
         3ynTdartDY3ngnwlP0LNxaOsupG7pytgGHxCI2eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/220] watchdog: w83627hf_wdt: Support NCT6796D, NCT6797D, NCT6798D
Date:   Fri, 22 Nov 2019 11:26:58 +0100
Message-Id: <20191122100915.975229254@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 57cbf0e3a0fd48e5ad8f3884562e8dde4827c1c8 ]

The watchdog controller on NCT6796D, NCT6797D, and NCT6798D is compatible
with the wtachdog controller on other Nuvoton chips.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/w83627hf_wdt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 7817836bff554..4b9365d4de7a9 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -50,7 +50,7 @@ static int cr_wdt_csr;		/* WDT control & status register */
 enum chips { w83627hf, w83627s, w83697hf, w83697ug, w83637hf, w83627thf,
 	     w83687thf, w83627ehf, w83627dhg, w83627uhg, w83667hg, w83627dhg_p,
 	     w83667hg_b, nct6775, nct6776, nct6779, nct6791, nct6792, nct6793,
-	     nct6795, nct6102 };
+	     nct6795, nct6796, nct6102 };
 
 static int timeout;			/* in seconds */
 module_param(timeout, int, 0);
@@ -100,6 +100,7 @@ MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=0)");
 #define NCT6792_ID		0xc9
 #define NCT6793_ID		0xd1
 #define NCT6795_ID		0xd3
+#define NCT6796_ID		0xd4	/* also NCT9697D, NCT9698D */
 
 #define W83627HF_WDT_TIMEOUT	0xf6
 #define W83697HF_WDT_TIMEOUT	0xf4
@@ -209,6 +210,7 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 	case nct6792:
 	case nct6793:
 	case nct6795:
+	case nct6796:
 	case nct6102:
 		/*
 		 * These chips have a fixed WDTO# output pin (W83627UHG),
@@ -407,6 +409,9 @@ static int wdt_find(int addr)
 	case NCT6795_ID:
 		ret = nct6795;
 		break;
+	case NCT6796_ID:
+		ret = nct6796;
+		break;
 	case NCT6102_ID:
 		ret = nct6102;
 		cr_wdt_timeout = NCT6102D_WDT_TIMEOUT;
@@ -450,6 +455,7 @@ static int __init wdt_init(void)
 		"NCT6792",
 		"NCT6793",
 		"NCT6795",
+		"NCT6796",
 		"NCT6102",
 	};
 
-- 
2.20.1



