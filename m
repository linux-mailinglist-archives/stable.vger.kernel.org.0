Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE935530D
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 17:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbfFYPQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 11:16:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39619 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbfFYPQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 11:16:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so18318789wrt.6
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 08:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JJ65PYSwq9lHbap5+/eYVEe6uBbmNNIS8cKuG+4aQHM=;
        b=ksJu/lYM5QnmLSPoluMTTQ/cRukJmIwktRNyGqrTaY8uKdSyPKM/jut3sVcnj0Tmg0
         DnfK/chEnLFtZdjJS956/3EWm5SzHKDhS1UbhcA3sD3BlxJihPZC1bMYQXDWbRhRanUp
         ujrecaXEJCukCWUei7CBPwk8ltCtCE8rNbKaLsdwPXBk6TZXe5NyY+zbz3HsnvyyseFj
         xD5c9zeMa0bv2T0ySY0AEOEB7dYek8fV8xNMGLcKouZOu3mtYDmKaZrdbyBd2WxrNJfN
         bWAk/hZNI9gjFaav3pHFluT/VzVMHUUQ2t5qnXO4khDGV0I1gZebTv0CUjrPkFXHbOJP
         1Jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JJ65PYSwq9lHbap5+/eYVEe6uBbmNNIS8cKuG+4aQHM=;
        b=iEk3d2sNCdxEySEqbplVY4Ky6LwpRkVR6eqYL9bN/4WcuHVKgKD9wTdcNNz9zuF0Vv
         mR5cVYhdPnA08HYiBzC8r3LeAP8yzdJzsBPv0sICoq+UwgPCpsfwWZGb5ZVx9vI2AxKr
         /iOXsqcyZaLKcd9JCSPR6FptJnzw4p9nqhASpopSMK3UBMy14rJr5f60AWuKDW8mHXMs
         5ZUWUvIea8ipC72UPWND+DXwYDpflQkHjcftNHNB7wCx/oxblB6odcsJZbOlh6iUQHWM
         VjP0OgCVpYJy9VtUe8RwwpBlMIOPDa+LCar8cK8Bd3X1lUOqSf+5orO34yh7u2fgdWRj
         4FQw==
X-Gm-Message-State: APjAAAXpXqprYnUrWkCOPUzBoUmWX88Wg2EbGu7mR5Gp59yLCGomGf2t
        ZrrDJLILN0KHkeDSXP20byfYMQ==
X-Google-Smtp-Source: APXvYqxcAJrcmpvr7/K/LFeB9QoRDG9hoW/+Wh0dvHT93oYnsjvEnWP3OfC0MlMmKOgGg6wJ4n/yag==
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr29440105wrx.153.1561475774684;
        Tue, 25 Jun 2019 08:16:14 -0700 (PDT)
Received: from debian-brgl.home ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id t1sm18456995wra.74.2019.06.25.08.16.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 08:16:14 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: davinci: da830-evm: fix GPIO lookup for OHCI
Date:   Tue, 25 Jun 2019 17:16:12 +0200
Message-Id: <20190625151612.6204-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The fixed regulator driver doesn't specify any con_id for gpio lookup
so it must be NULL in the table entry.

Fixes: 274e4c336192 ("ARM: davinci: da830-evm: add a fixed regulator for ohci-da8xx")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/mach-davinci/board-da830-evm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 51a892702e27..aba10a2bc6b9 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -88,7 +88,7 @@ static struct gpiod_lookup_table da830_evm_usb_oc_gpio_lookup = {
 static struct gpiod_lookup_table da830_evm_usb_vbus_gpio_lookup = {
 	.dev_id		= "reg-fixed-voltage.0",
 	.table = {
-		GPIO_LOOKUP("davinci_gpio", ON_BD_USB_DRV, "vbus", 0),
+		GPIO_LOOKUP("davinci_gpio", ON_BD_USB_DRV, NULL, 0),
 		{ }
 	},
 };
-- 
2.21.0

