Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204B21623B4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 10:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgBRJnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 04:43:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37655 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgBRJnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 04:43:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so23057703wru.4
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 01:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZG2z268/d1ZPCLix4+2Jyx7EtKyi7olNnGdRbAveZ2A=;
        b=Wl2zXwiSHFbZl2UICxYrGvJRg6ZyvtsBfE6EzhmieYr3vsVZxG+oAFpwBc0io5tf0b
         W9mS7dXqwmia5CFkB66HGC61jim0o86iOvg7l7vW5fpUDUrCDqiVIUkZ0OSQ/ZltBLhK
         BFV2tdAvHYSLtBHyhQw++uXUqEw2hAEIHKStrkCDzd/Pn/quB3ilcHgq5BDLkx0dnHi+
         KpUsanlT/LXV/mqoPLHPZsZLwGI299ahwEoZLaSwcAu+b7NI2h3wPeqhGNvSfs71inhe
         AE2IH6lvfBUSYpY31zOq9XE/EVEWhJu8u0uxF+feqE5wun3gN4jy+r57hgbrCrd0OHO8
         JP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZG2z268/d1ZPCLix4+2Jyx7EtKyi7olNnGdRbAveZ2A=;
        b=MXcK7/kIQwAPcCNvPaoYBeZkdV64H/xWZEtDwGLB+A+81qfgunlC0xEbierLmsGyXd
         8BQD9sDBUVB4l2JpDoTNJUvA+phohfeYTpYLL3CSuN356UuEbvYsoSpZzxEdLBbkE5VY
         8Hgfdd34AMtp5r08iFZvC3fp59GAZtZ25bpp5RYH/yFVmKTLj+yoYYnO446BRB1WXv/+
         OQ8eelVJ0V+9NGLO7LIPRIfUMW8W1h+ggT2RwYg/hSyx8CLlowp+LIYEE49H82OqZnl7
         KaespPoIq/bUcxmQ99uSaJ326z4VQXcaFQeybAbMKznlYHjO24bjHo3gDPt1tpuP3SFp
         nHzg==
X-Gm-Message-State: APjAAAWIPbkqDNNaxyI9AiCxWRLGvz5GhXUqSHAeZsN1j6gnHfrgXWcM
        Prby4XAjA3oouCS4Gw1LJLphrg==
X-Google-Smtp-Source: APXvYqxbdKA1tOMV0VLCP3MMxkPL381W0uMOD0VBrLz3nDGgTSECjqZQnAItsFAYSzfbPyzcLkNJjQ==
X-Received: by 2002:a05:6000:128a:: with SMTP id f10mr29135170wrx.116.1582018978979;
        Tue, 18 Feb 2020 01:42:58 -0800 (PST)
Received: from localhost.localdomain (lfbn-nic-1-188-94.w2-15.abo.wanadoo.fr. [2.15.37.94])
        by smtp.gmail.com with ESMTPSA id s23sm5351095wra.15.2020.02.18.01.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:42:58 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Khouloud Touil <ktouil@baylibre.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/7] nvmem: fix another memory leak in error path
Date:   Tue, 18 Feb 2020 10:42:29 +0100
Message-Id: <20200218094234.23896-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218094234.23896-1-brgl@bgdev.pl>
References: <20200218094234.23896-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The nvmem struct is only freed on the first error check after its
allocation and leaked after that. Fix it with a new label.

Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/nvmem/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index b0be03d5f240..c9b3f4047154 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -343,10 +343,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		return ERR_PTR(-ENOMEM);
 
 	rval  = ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
-	if (rval < 0) {
-		kfree(nvmem);
-		return ERR_PTR(rval);
-	}
+	if (rval < 0)
+		goto err_free_nvmem;
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
 	else
@@ -432,6 +430,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	put_device(&nvmem->dev);
 err_ida_remove:
 	ida_simple_remove(&nvmem_ida, nvmem->id);
+err_free_nvmem:
+	kfree(nvmem);
 
 	return ERR_PTR(rval);
 }
-- 
2.25.0

