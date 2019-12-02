Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2718E10E934
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLBK6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:58:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36453 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfLBK6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:58:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so16812809wma.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLUFa4tV4a+fQ9GWI2gwGlyZ99iH1jGRMyQougWlTfU=;
        b=fbzCjX9ETrtu9GZJ96GFRdJq05dUYLMJjU1QoWRxg3lIUuSQJ0DfpbmLvA+BYoVUrD
         s63xS11NUt+9hCKAkRlbHAqN1WzRAoDOiSb+xnqixsEcy0wUVhasE8oL4T1VEHYAOeqy
         UBQucjlYBAnhUH3Q+gctpbhbe2zbNFTk8AU5YeMMZ7Y7HLzO40PMEoz6IDjwTkKkG4dV
         Tf2pEFIzvlGi+XN/3sIcExiRlXC9U/V4p4kmssMhkHAcPIOh+Vikj6wqTiRINuFbQuJH
         hs1gkK12CDteOMTIGtdjfD1Fd+gWiYI+6cYwoEleftiUJORRZNP3IKp2f4YANlZ1t+DH
         Nqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLUFa4tV4a+fQ9GWI2gwGlyZ99iH1jGRMyQougWlTfU=;
        b=jnHRYe77NAPLqJEHbSDWvy5Q9m/3ze0qdbVWoOk+6DBxCN8+NwmH3aq1CNJl7OIaoz
         X1saP3w89OpLGLerMvUu/93y/4U5hl89IC1MDMbrvwZxnb5jC8BL30JWyh8aNWsfzanK
         +fPRcsueAbRjIadJaTpaQl8QiUn4uwpw3OY3f1gkdCDyzTjblFX5r4yYVKSHDFOPIo1b
         6c1EZLEpgCQD5/e8GRu3V01Od/c2MDElpY9gOvYwMvE28xbvwQQATTJMzLAEs4qdGJjF
         C4cnHHJwtaWmFdpOnmEx7fIwYoZ7+TyA37D6MgRVfx0RgVz7OhQ6q6lTt7CdWPYNH40h
         y0TA==
X-Gm-Message-State: APjAAAXLQa1ue1HS15ziDp0LuJJXrDoEeMpnJC0aMHJYx1WqVtbZX3TX
        +hScj3Qy/bnP8AWvAsVE7Ul4PobjsLs=
X-Google-Smtp-Source: APXvYqxMFsn17crXKOM1VPB8BpzrkjWrWD2ULOAdASzTOTsTdsPw7CtpGgA5nTWi+s6qkO44VbYBpg==
X-Received: by 2002:a7b:c357:: with SMTP id l23mr27570863wmj.152.1575284301707;
        Mon, 02 Dec 2019 02:58:21 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id k19sm5766121wmi.42.2019.12.02.02.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:58:21 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 5.3 1/1] clk: at91: fix update bit maps on CFG_MOR write
Date:   Mon,  2 Dec 2019 10:58:09 +0000
Message-Id: <20191202105809.4227-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 263eaf8f172d9f44e15d6aca85fe40ec18d2c477 ]

The regmap update bits call was not selecting the proper mask, considering
the bits which was updating.
Update the mask from call to also include OSCBYPASS.
Removed MOSCEN which was not updated.

Fixes: 1bdf02326b71 ("clk: at91: make use of syscon/regmap internally")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lkml.kernel.org/r/1568042692-11784-1-git-send-email-eugen.hristev@microchip.com
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/at91/clk-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 311cea0c3ae2..87083b3a2769 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -156,7 +156,7 @@ at91_clk_register_main_osc(struct regmap *regmap,
 	if (bypass)
 		regmap_update_bits(regmap,
 				   AT91_CKGR_MOR, MOR_KEY_MASK |
-				   AT91_PMC_MOSCEN,
+				   AT91_PMC_OSCBYPASS,
 				   AT91_PMC_OSCBYPASS | AT91_PMC_KEY);
 
 	hw = &osc->hw;
-- 
2.24.0

