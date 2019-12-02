Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5B10E81F
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfLBKDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39490 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfLBKDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:50 -0500
Received: by mail-wm1-f68.google.com with SMTP id s14so15699624wmh.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCYfmL1/wCJrAvT+ACq87WMwGG7+rMaHvrzSdRlqSHM=;
        b=tLiZimft9l1MaLwsRUbedscWEoRPpMHWKF8eaQxx24yeF8yVCEwZYKxMN8GNv3lflT
         9S2TsnON9P+KXIrtcmLL5W8cTXGvt/ukhM2jV6NeUCUaa7QgO0YqHv3TooNpwQsnDLB2
         DTTtmHVwoW6z9y65eHCeNQHusdVB+vmOtTtlRelAM+EdS8UyYyBfpbNIFSK4+lsEyYPS
         GIiVmqIFWy/uLCtp/G0d61m6zZsVeqQ7Cj+oqcAjuux73eKFokIY8NfmHbt4A7Ef29Vy
         PJRX+nPEXBL7cqKN78WTjawq41ollEGretpKHcfntZ8tuEaMpFjorIFhe+jBIDXR20/Y
         kUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCYfmL1/wCJrAvT+ACq87WMwGG7+rMaHvrzSdRlqSHM=;
        b=IEvIMtiRinKzfmxDl8AEGv3Xb7w1dp2/BcPLiIT+HCi1yQgTfCX7z332QTTIfWoKQP
         rigGulx83Omejq9iMN3eLCQSSFcJpcJ10CUWVEX1VYQlhX2wiwHz2Q6iRmiMm38Nua+i
         acdIJ7+2ki7KEOBPPx6eb5/jJvNkYQpOuN1vFYhTDY9OQSrIf6BO1fW82+RNaiROvH+h
         Ek5ZMiXtspenMtvzjeb6tPebfraBaXtRaSyhxG43y3MtWSdHTE+QBNuCfw2rsHlIoli+
         Kr1R8M2SKRBmcfXYwGsOcl5K0w1320EQA8Gi4uZFLmE5ke3MMKgNoP0nUyFI9W1xiG3w
         AJcg==
X-Gm-Message-State: APjAAAUEapX8xxobYO1/e3mdU6rz/DojFxdxNToOInzLnAdZOCWivciv
        m+7SG/+ybnMqFSI8rkRrOxROFY5zvIM=
X-Google-Smtp-Source: APXvYqwuGNDCMZqozyOM/2E2RIeQYLL3mexAvzfoKO0xo1CPbfsS8cJH8AaYB+yC2KPQGAZwLDrkUQ==
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr4010610wmc.158.1575281028196;
        Mon, 02 Dec 2019 02:03:48 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:47 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 01/14] clk: at91: fix update bit maps on CFG_MOR write
Date:   Mon,  2 Dec 2019 10:02:59 +0000
Message-Id: <20191202100312.1397-1-lee.jones@linaro.org>
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
index 2f97a843d6d6..b29bc7ec2ef9 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -162,7 +162,7 @@ at91_clk_register_main_osc(struct regmap *regmap,
 	if (bypass)
 		regmap_update_bits(regmap,
 				   AT91_CKGR_MOR, MOR_KEY_MASK |
-				   AT91_PMC_MOSCEN,
+				   AT91_PMC_OSCBYPASS,
 				   AT91_PMC_OSCBYPASS | AT91_PMC_KEY);
 
 	hw = &osc->hw;
-- 
2.24.0

