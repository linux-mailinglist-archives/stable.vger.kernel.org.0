Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94A610E821
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfLBKDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:52 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56206 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfLBKDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:51 -0500
Received: by mail-wm1-f68.google.com with SMTP id a131so16735808wme.5
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sVbw3UdezQ0sD9BTneNk/tIPQpwqVy7LB+WYRpuD1iU=;
        b=Qk5HwfTf32NYPQMIGTFwZEY52SK16t9YODfdA3aRJFKTBbQZI7gOpiJE26OI6gmIXT
         PMiOo958L01JPifVa9ORmz46iqKzao1LfUlHUBuxc/VFbbr1r/ti6ccwtV8BcRtAKKDL
         38z5hGBRu+G4G3mmhucw1UTfvD8Cl3pktUvXRQzkGUWGeSoo+QR6wjvFP4kG6huyNJW9
         XIMX2pKYa2r/59Vu/X03YD519VvRFZuzFyy5a5b2P+p5Smt+pA/wHXJf4Bil14qdWOHP
         yrc+neFKi2O8Oey3js/Omv8/gFOgsc0hr3vKmCBdCzoDR2g0kDp/rEn9oNPTGI2qSVHt
         sqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVbw3UdezQ0sD9BTneNk/tIPQpwqVy7LB+WYRpuD1iU=;
        b=P8hiWDvSEwWo4mDrwEBo1oq8WeS4pf3K7v6Z5ox9iA1JvhP1I5K4bWwqiBFh0cMnom
         ZpQlDyF1segSe+FxNlzt+PRJ1jE+NFj3D5ImlSXS27FOlH75zs4NSBPO0Kb41k1wybkq
         Ac2zyIUS6iZ5n9g+eeNJmtwfHjqFtV/d15zwpnWnm2VG8ZJ6vK4NglushuIQDXivzsma
         AxeaZ+41ZF6lFDOQnDiLyJ6fyyZpmK1GaFUro2/+GnRsT/FT9QqN3kcTv2tClm2TXpyu
         P9iwI66qgPJJcn+auUCpEE5cJQJPq8xlPMW7m7ibH5J4n+jQh03Bw8i4mos9vXhDUlUC
         bldQ==
X-Gm-Message-State: APjAAAW6jwP/4sdyp6MW7HmPtesdMUveq7hwvrP+/xFN8gNJF1wwz0J5
        zDWuGvkiCZt/e6te6zyx/K5sJ5BBt3Y=
X-Google-Smtp-Source: APXvYqxHG2RuNK8ZvFku/8aVjYEz/HCuHoYoV7NYImThRu2bDc5AUlvzeFhGe4+S1oPGnJC3QYh1aQ==
X-Received: by 2002:a05:600c:1108:: with SMTP id b8mr11371586wma.17.1575281029709;
        Mon, 02 Dec 2019 02:03:49 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 03/14] watchdog: sama5d4: fix WDD value to be always set to max
Date:   Mon,  2 Dec 2019 10:03:01 +0000
Message-Id: <20191202100312.1397-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
index 0ae947c3d7bc..d8cf2039c6a4 100644
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
@@ -255,7 +253,7 @@ static int sama5d4_wdt_probe(struct platform_device *pdev)
 
 	timeout = WDT_SEC2TICKS(wdd->timeout);
 
-	wdt->mr |= AT91_WDT_SET_WDD(timeout);
+	wdt->mr |= AT91_WDT_SET_WDD(WDT_SEC2TICKS(MAX_WDT_TIMEOUT));
 	wdt->mr |= AT91_WDT_SET_WDV(timeout);
 
 	ret = sama5d4_wdt_init(wdt);
-- 
2.24.0

