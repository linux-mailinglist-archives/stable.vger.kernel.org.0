Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3416B195F33
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 20:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgC0TwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 15:52:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39214 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0TwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 15:52:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id e9so1839786wme.4
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 12:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/UVoIXoW4LEqnqz3DzIVuWbAx22+a09oNDzhz+nOUWE=;
        b=h0y9OOV6qgPpOq6V1R3L6PC9h9/EAWYouZ3p0VVBFzlm4uJDVqV8kQFKZqdNnmYSc8
         w68H/BMGDHmudSRBiwNf7oWQzWhjpTeCzVbh0rysQgaTLcOd8++NxLF7YvLIQQw1Ikb1
         lWfCWVKvuIBTzNjkuDN6vgtH4EpJ5JoKh5U05DZeay5J8hHrFHJFK3735RvbenhtEfUM
         owQMNurrqBEhKSB/xlobSXfYzrsOZBd76UGKjYDRwgAk1Q4ZkXS1OsUi6caABUGakKmh
         Maifu/HG0zJA8eRPbJezF+HHnuZazDqHICly4FC4ounmZw1V6UV1P5fD4RXQooJSpzQI
         EUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/UVoIXoW4LEqnqz3DzIVuWbAx22+a09oNDzhz+nOUWE=;
        b=TKKhUN/WKBk4y1QNrQEscPqT8gAgOFWT6A+cPGedeMSTTSa/Eyz2rRjxrZrD0NF/Ce
         9evUr36vyCe/hewazYRCNzT1LKoMaQ5Uo0/bmeyr/Agj3o2gueJGmkPXCITQu/JwBHlk
         kFDdUxh9hbz2Tdg5krJ0wzPjcaYnNX9T5Kea+3TBp62Tj7D2GBWI4j2WYdNyXWA3vfFM
         nfHa6Hxdj+TtDj/k3ikMTq+GGG68BPtZN2MrMm8dRk5qQIz/BnX7RwoimCJk9v3VZSLP
         bJlhVIHeiXZei2r4W25PcpBiT/jsNIUL1oM8Tu9NjHRULW/bNG9eoLdN5zIkYzqGmtDw
         8P+w==
X-Gm-Message-State: ANhLgQ3Grd4Lk9QRFTJfNAZZEhSkK0hTSDxns7d87oBQWvfncAxuSKeq
        KFVJLh2uWRR6QrwZf0qN0rRbtABX2g==
X-Google-Smtp-Source: ADFU+vuw75MYNZ5muVInoqhm7a0lfbpXIgR2Ky7xDBuWoAxFuB4EWQoRGrreJHGD/RCDEaYI841Qqw==
X-Received: by 2002:a05:600c:581:: with SMTP id o1mr264340wmd.111.1585338723036;
        Fri, 27 Mar 2020 12:52:03 -0700 (PDT)
Received: from ninjahost.lan (host-92-23-82-35.as13285.net. [92.23.82.35])
        by smtp.gmail.com with ESMTPSA id u13sm9698197wru.88.2020.03.27.12.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:52:02 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jbi.octave@gmail.com
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 01/11] rtc: max8907: add missing select REGMAP_IRQ
Date:   Fri, 27 Mar 2020 19:51:40 +0000
Message-Id: <20200327195150.378413-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

I have hit the following build error:

  armv7a-hardfloat-linux-gnueabi-ld: drivers/rtc/rtc-max8907.o: in function `max8907_rtc_probe':
  rtc-max8907.c:(.text+0x400): undefined reference to `regmap_irq_get_virq'

max8907 should select REGMAP_IRQ

Fixes: 94c01ab6d7544 ("rtc: add MAX8907 RTC driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 34c8b6c7e095..8e503881d9d6 100644
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
2.25.1

