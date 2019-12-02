Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5128B10E8E1
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfLBKbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:08 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36402 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfLBKbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so16691997wma.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BVWjviiOfMrA2E5Cbz2YP4jWsTNfITZ1DLy7ZHFYwdc=;
        b=i5e9Ou6IzjKBJly4mAbQ5nR+a7LhRa+MC8FRy/8TrhJ7Aw33IdKR04qCVdTuR7F2t7
         s7meJ8o4MupZhe1Edlzq+tmgwdo9CPocpCN/zCXyE+9+cf8B1unJSOQLrJKrfSh1Bhms
         Rti+d5QHHkrZyjQRTMmIKgMSdP0oBevFriLW5IuSAahd6hlwH9xcWvuGe9Ut8RJrSdwU
         UxXqXGsL8S96qh9Ysvnxweae2c6Fof2OATd/HJIgUJFERdQE5yV0Oed46tk1+BcUKqdZ
         OfoBz0EIb+ynorqaXVyBbIGzQwIXphpyHcA9JTmBr9w7jvNcgIyFzj1+Tioz88tTgELc
         sacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVWjviiOfMrA2E5Cbz2YP4jWsTNfITZ1DLy7ZHFYwdc=;
        b=SYbjWW2ub/SYSpIERguz4xsqLt9YBXgoNNbdPigy7GMTYyCuzyzPtldVU/vPA42laF
         UAWQs3MM8/gPotvCAKeEd/iVji2uWEQ0K2LW/QS3v7c6WoxOw2dzRfS1BiR/8cQswmr7
         q3UthsG6WzjBDrl0Me+HWFbpMiCHHZujoiUOW1iHoDgJfhP3mAcjb+eSD/trj0flfv4u
         MqdqkSqDxbbhJFQbt0o2LGlOOj8FZJVSKyoYS/dV8qik6UFMpWeMkf3ZsqJx2t/UyjVS
         40krxCXZqVvV/9FaJSWuwDtarHcAY1itObUCrxw0F3kwhcmR+Ci4tAksL96UmBWpKvaf
         3IVA==
X-Gm-Message-State: APjAAAWHulJ9cURGrBe4/It1AbkaJ2E5Q1oIzyFU5z4xdrzJywxR7Fws
        cmaAD7Xb9Kbcve/Z2EMlQif0KYXrxZw=
X-Google-Smtp-Source: APXvYqxKbclbbAJgwUm4Lf6lYcIXiwEh2s740VQhn+qcNJTXOI2qQy2EUO7S7Jza/kjVR+tK/XxDLw==
X-Received: by 2002:a05:600c:290e:: with SMTP id i14mr27114833wmd.126.1575282665634;
        Mon, 02 Dec 2019 02:31:05 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:05 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 03/15] watchdog: sama5d4: fix WDD value to be always set to max
Date:   Mon,  2 Dec 2019 10:30:38 +0000
Message-Id: <20191202103050.2668-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 8632944841d41a36d77dd1fa88d4201b5291100f ]

WDD value must be always set to max (0xFFF) otherwise the hardware
block will reset the board on the first ping of the watchdog.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/watchdog/sama5d4_wdt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/watchdog/sama5d4_wdt.c b/drivers/watchdog/sama5d4_wdt.c
index 1e93c1b0e3cf..d4953365dd9a 100644
--- a/drivers/watchdog/sama5d4_wdt.c
+++ b/drivers/watchdog/sama5d4_wdt.c
@@ -111,9 +111,7 @@ static int sama5d4_wdt_set_timeout(struct watchdog_device *wdd,
 	u32 value = WDT_SEC2TICKS(timeout);
 
 	wdt->mr &= ~AT91_WDT_WDV;
-	wdt->mr &= ~AT91_WDT_WDD;
 	wdt->mr |= AT91_WDT_SET_WDV(value);
-	wdt->mr |= AT91_WDT_SET_WDD(value);
 
 	/*
 	 * WDDIS has to be 0 when updating WDD/WDV. The datasheet states: When
@@ -251,7 +249,7 @@ static int sama5d4_wdt_probe(struct platform_device *pdev)
 
 	timeout = WDT_SEC2TICKS(wdd->timeout);
 
-	wdt->mr |= AT91_WDT_SET_WDD(timeout);
+	wdt->mr |= AT91_WDT_SET_WDD(WDT_SEC2TICKS(MAX_WDT_TIMEOUT));
 	wdt->mr |= AT91_WDT_SET_WDV(timeout);
 
 	ret = sama5d4_wdt_init(wdt);
-- 
2.24.0

