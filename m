Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F42010E7ED
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLBJub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46747 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfLBJua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so39876151wrl.13
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCYfmL1/wCJrAvT+ACq87WMwGG7+rMaHvrzSdRlqSHM=;
        b=UGO2zcWWellV0haG6MUkR0NEECD4K4a5Ng0g8G1HjRGFICqwAKrxAqGPCciTv2Zjf0
         ZoUjajmiS60wSU1b3Y8+LwSq+WknsDj9l2b44E5S2DGtvRPrcj0jT6D+65iDbwdGsx0W
         I0/zkrOW43P3MF2vxUtfDtZDsEXoKC7TxS2bucorGbtr5S7D0hOQieaBh5zFNUgeF2K2
         paDlhDzr3o0n1drRR9ZELN1cJ0iauSb6WH7ZJkgqhN1f/SWXds4dwUarOy1wBgs10aXg
         5+LYJV4aY+srPY7zlwuwv3KH1dKwf9OheJNxuRWLDESDgaXf9Kw9okXZFh2k2WRHt4nA
         CYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCYfmL1/wCJrAvT+ACq87WMwGG7+rMaHvrzSdRlqSHM=;
        b=PYZZjuWJXdGlJyacKLVkmL6xIvKcrV6HPB7aJSQLq0WmwEVdzyoPJqOpAMgbpjgTkA
         bZ4CAUyfNI6t4VuHkRLn0Gu+Xd24kyOZObNKWKVGexkT0G2S4WYN6vJpxgWUMzxgK7eL
         7/Fq5+5B+az9sqsRs7/baZJZWesPKUBCRR0mLP5fN3qi7WJryX9dLV42FVZ2Bpswgv1i
         N1bw2j9Vta7hKhX7dRD246u8x/wEwgSKg7DpoGIQ5FVNvj2lEQ5ksfez6M0Ef46amdsV
         GE1/S/3nD916ofRguqF6nKjQ8y5zgV5sjzpW1OGvfadD5J0M0IZWw5msJX6oQYp2Us9k
         E8Rw==
X-Gm-Message-State: APjAAAVzo4B0hLJPbBubUQMF8Eho1hgypZSjuQOIPc1amg7X7kIHGZ/k
        SgHPav98YE7xtf57jifECmsZ/u7rUr4=
X-Google-Smtp-Source: APXvYqxKpK1bNzVwpx/38gq2p0xudQOshxGX4HPv9IlXyO1eWg+EeDnwkpNeDWzr/nIm+gTF4qTdAA==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr60894710wru.220.1575280228650;
        Mon, 02 Dec 2019 01:50:28 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id l3sm4629698wrt.29.2019.12.02.01.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:50:28 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 1/6] clk: at91: fix update bit maps on CFG_MOR write
Date:   Mon,  2 Dec 2019 09:50:07 +0000
Message-Id: <20191202095012.559-1-lee.jones@linaro.org>
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

