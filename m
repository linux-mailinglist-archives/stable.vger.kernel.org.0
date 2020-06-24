Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EA6207697
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404369AbgFXPEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404338AbgFXPEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:04:51 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18829C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so2591434wrw.12
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ss7PoxbYLKDr3LBMlu1h9z6F9Bwyl8YcpPLuuDtA3OM=;
        b=zQRqE+UPlzudn+/cNp26hST9pkqlAF/Roysjl/ZK7hSOKrbhU0+ps/0hPMPZsbtq/y
         7wkqhhZfdcOFJBlLfaVIq6w0vtexOBLwbp/pjJGSxtLakMB6+zk27rhGv9J+ON8zZ6kn
         fzdXdcthiNFm1fkpxraeMNnxwh/t26zQo4S5e/5NFtzLHCzm4EadHFojnWIy7JuQe9cK
         6ySZiZs6+kQpTsrLLTyxUW9nVNMXkbf3Ry1jJreYdNgKWyGYrXJxBMXhSJlWyVkmkG+7
         0TNrihNQNOQlLEAzLWkhnniT+Ri1c30kv54Kd4HYaALy++kosXWN5+toAf8VcB8ifg3z
         Us4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ss7PoxbYLKDr3LBMlu1h9z6F9Bwyl8YcpPLuuDtA3OM=;
        b=c8Lx1NI4ydszwcKVeOBka2YLIP+qS/oSQ3+Ci1Xk0fRxY/GXGa4jZpaIA6b/Ddl5yk
         VBWk5KWIfU4xxvV+E1rMJME/3KXDlNU8+LCKjeL459JHV14HAy025QadqLW0/2iShEh/
         j16JyUczcbh9tED0GQBV4nHBC7dz7JfXXWKJfxsFHYah/n/zK6AoTThffyiarJBOehD2
         2l/8TYL0ZgDnIFGLaIIRn8NzKfpw2PEKPhSAHoQEmo3M417RAPI5ku4g0159YLjxY2MV
         TW4lfSgANLwOPL7cbaNptgCXtBS8EEgQ/fejUdJQply6KZ3Pc5p6H54zImUgEhXysVJY
         ht+w==
X-Gm-Message-State: AOAM531M/ke680LaIhQr0JuNwmdTnIYY9XNiltKJAoTiaFjYMMoR3HCl
        joJYTEj1ypWwfzmCap1Xxv8s4g==
X-Google-Smtp-Source: ABdhPJyBKk6kJ02PvMM7Uyi6GPyHgQUfHnlBQcJ7n1r9LSHJv+EmY6svcQnxsVdBuisOhIR5XeqR9A==
X-Received: by 2002:a5d:6a07:: with SMTP id m7mr32024458wru.324.1593011089754;
        Wed, 24 Jun 2020 08:04:49 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id f186sm8200319wmf.29.2020.06.24.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:04:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     daniel.thompson@linaro.org, jingoohan1@gmail.com,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Jeong <gshark.jeong@gmail.com>,
        LDD MLP <ldd-mlp@list.ti.com>
Subject: [PATCH 7/8] backlight: lm3630a_bl: Remove invalid checks for unsigned int < 0
Date:   Wed, 24 Jun 2020 15:57:20 +0100
Message-Id: <20200624145721.2590327-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624145721.2590327-1-lee.jones@linaro.org>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

unsigned ints 'sources' and 'bank' cannot be less than LM3630A_SINK_0 (0)
and LM3630A_BANK_0 (0) respecitively, so change the logic to only check
for thier two possible valid values.

Fixes W=1 warnings:

 drivers/video/backlight/lm3630a_bl.c: In function ‘lm3630a_parse_led_sources’:
 drivers/video/backlight/lm3630a_bl.c:394:18: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
 394 | if (sources[i] < LM3630A_SINK_0 || sources[i] > LM3630A_SINK_1)
 | ^
 drivers/video/backlight/lm3630a_bl.c: In function ‘lm3630a_parse_bank’:
 drivers/video/backlight/lm3630a_bl.c:415:11: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
 415 | if (bank < LM3630A_BANK_0 || bank > LM3630A_BANK_1)
 | ^

Cc: <stable@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>
Cc: LDD MLP <ldd-mlp@list.ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/lm3630a_bl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index ee320883b7108..e88a2b0e59046 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -391,7 +391,7 @@ static int lm3630a_parse_led_sources(struct fwnode_handle *node,
 		return ret;
 
 	for (i = 0; i < num_sources; i++) {
-		if (sources[i] < LM3630A_SINK_0 || sources[i] > LM3630A_SINK_1)
+		if (sources[i] != LM3630A_SINK_0 && sources[i] != LM3630A_SINK_1)
 			return -EINVAL;
 
 		ret |= BIT(sources[i]);
@@ -412,7 +412,7 @@ static int lm3630a_parse_bank(struct lm3630a_platform_data *pdata,
 	if (ret)
 		return ret;
 
-	if (bank < LM3630A_BANK_0 || bank > LM3630A_BANK_1)
+	if (bank != LM3630A_BANK_0 && bank != LM3630A_BANK_1)
 		return -EINVAL;
 
 	led_sources = lm3630a_parse_led_sources(node, BIT(bank));
-- 
2.25.1

