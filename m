Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4F10E8DF
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfLBKbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51830 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfLBKbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id g206so21195963wme.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCYfmL1/wCJrAvT+ACq87WMwGG7+rMaHvrzSdRlqSHM=;
        b=mD1bHEp/B8H6GN9AeiZIX5POlpTSpygz9avrY37hOfgPDxtmJcCUNT+CxdsiehAsu7
         Bb9ltFeUR2qIG3sDitfpJ24oxFMolgOlQhen7R+m/9mOpvkdZRskty5Be+KHmUh3HuFd
         EQkzye6DGgLZPpstHBeT4vOkyiKPRRX8v6lAYOGqGsxm7O4gnW9YmndI49Jr0GRAiX4d
         YavfxdSBbuQG7C8U6Wn6tsHsN2tFKqCuy7kL7ktugJmio/7up83D4TqtVBhZrK/eufug
         o/mAc0nWtedg9NbGabK/8SU+bfEclnxshsE/WyJGX1+iRWxgestj65JHzaka6Mdv/j6U
         jDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCYfmL1/wCJrAvT+ACq87WMwGG7+rMaHvrzSdRlqSHM=;
        b=FVOCujS0SvKvVUVH88kGN6Zx8S6WUppWhhZNmnFT1SbGxSNulQ4BdDf9RJjMoZ0lU7
         R1o6HEpGkhXJRlma4zIp/TQalLvEF1FaWxHAk65+Voiw03wqDYDBqT1tYvvQ4Xenmizc
         MnFkAY/7GE20Qp478Se0x0kiaDA6oWDryBitNjR+g1lO+W698B1JmwxF00mWpGe3Rqv7
         hgFetNoWSz9l07qJgp+KogjtrU3dqeXIRtCJK6q49b/IlRt6ts19hS0pZpG75Sdy9rAn
         QHE2gCv5t5s/X/195oQ8YvEMyNMr+QifBI5NSq7rcI607D991DG2TYE9BuJy3+XXHaP/
         GLhA==
X-Gm-Message-State: APjAAAVJMErVMgScRjq08/iosOmjjfs4ncSIEuo3V5VXFM3U3ma+GJ4j
        Db59v11Lst6KpDuU7koQYrOkicTBtg0=
X-Google-Smtp-Source: APXvYqzn72/EM6kP1aH7UidcSBapSk/uR4tDDTCWxGMsRPUmtl7QIBZyZtAG8zMigryz6AtTXG9hqA==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr27102637wmc.125.1575282661938;
        Mon, 02 Dec 2019 02:31:01 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 01/15] clk: at91: fix update bit maps on CFG_MOR write
Date:   Mon,  2 Dec 2019 10:30:36 +0000
Message-Id: <20191202103050.2668-1-lee.jones@linaro.org>
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

