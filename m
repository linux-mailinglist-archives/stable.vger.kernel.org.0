Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86C0189F9A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCRP06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:26:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50961 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgCRP05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 11:26:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id z13so3916739wml.0
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 08:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=fUfuRt6oxx3leUSmTuFPTrK4xKpBYnjQ93vBCHZXuX4=;
        b=yLuS9F0cGTZf9LZ1iiqPC6GpTTIeAz/SdSMaqzBeaoFjiZTkLhttnSF5/UX9uxO/s4
         zmXVfiQx3/3rL0NhiRvSYMHersb3dTK0dbQJza45dcefD1AYPZsJdteBj4/wKpBb6iNp
         he2QnvxW608PCtN1yMMSKi+eQKl8Q11uPgXYZhSpQ4AwJEnfofzf5gtcHGU/c1/GfFc5
         NNoCHiQr6YYwmIwVbd/pEAPyxSUgpIbSYeYdpNHBY3LzGB4O8S7lUFjkGdfzRlxn9kCG
         E4LxEPkyKxcc4LdEp9zylpgGly0tFMHCGlSdIQr+ZLV6x7wlrH2x5bbFcDoA8rqGGmz9
         lezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fUfuRt6oxx3leUSmTuFPTrK4xKpBYnjQ93vBCHZXuX4=;
        b=Q2+YOuwN2U0LJg6RZrW/27LetDxDPHD9/fmCn4Tx1IocvSAVBTXgCpnck5D1byGqGQ
         s+J7exOWJb0RiB6OCQQnQTucLL8HNKv5BrFBYo/DxXjGKgWF6hh6VwB61MXmIInaRN8B
         f1utbZNOeXCCA6Gm0B1+39Ac1FHxIbro23SYpXZRIC+gZ8o35stiXJaKHf1rl/sojZzT
         j+nJqjn7P5n8hFhDwJl01IwdMT+USguyUhtQRKHOynwnv+tRcFvbDB3g0h/YtEJgnzbp
         9Xjgz30OdO1C9rxe1LBW1tY6+wN6MG6TtPe+lIeBVyf8QBP/IBqEf+6uV68g0wbypmmq
         th6Q==
X-Gm-Message-State: ANhLgQ1FLdmHRSI6me2fk4vFGiKN4eVkkO15RvMeYX3ADYcHjGE61EX+
        5B32lo7PIzA/dBc9+xnxao4Yrw==
X-Google-Smtp-Source: ADFU+vuSq9fGIwkaFfnv935xJPaLgRcrUkBfhGJ7wvIjJMqb87bDFa+H+3A+EDj1ksKv7CDpms2YmQ==
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr5622975wmg.52.1584545214448;
        Wed, 18 Mar 2020 08:26:54 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id h15sm9390552wrw.97.2020.03.18.08.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Mar 2020 08:26:53 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     a.zummo@towertech.it, alexandre.belloni@bootlin.com,
        torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] rtc: max8907: add missing select REGMAP_IRQ
Date:   Wed, 18 Mar 2020 15:26:49 +0000
Message-Id: <1584545209-20433-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have hit the following build error:
armv7a-hardfloat-linux-gnueabi-ld: drivers/rtc/rtc-max8907.o: in function `max8907_rtc_probe':
rtc-max8907.c:(.text+0x400): undefined reference to `regmap_irq_get_virq'

max8907 should select REGMAP_IRQ

Fixes: 94c01ab6d7544 ("rtc: add MAX8907 RTC driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 7d6cb60ee010..6c99156cbe57 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -327,6 +327,7 @@ config RTC_DRV_MAX6900
 config RTC_DRV_MAX8907
 	tristate "Maxim MAX8907"
 	depends on MFD_MAX8907 || COMPILE_TEST
+	select REGMAP_IRQ
 	help
 	  If you say yes here you will get support for the
 	  RTC of Maxim MAX8907 PMIC.
-- 
2.24.1

