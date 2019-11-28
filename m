Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557F210CD31
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfK1Quu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:50 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44300 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfK1QuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:14 -0500
Received: by mail-pf1-f196.google.com with SMTP id d199so8731197pfd.11
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k+cv9/8Sp0jhDfTqkaHbtLM5d5QXQGR0f5kzjPotgaE=;
        b=Yd4WyxjAx8E7rd/IcnhXBtcueXEooIqKr5vao3pVuHgjBkGq4ZaAjKekSK7fI51QyS
         T3Go3A5pmOJD17IMW7rhikGV8N8kij+CEOuUarK5xLKoctOAsj4Rwd5wLAAmr56yeoyD
         zLb+afITrkuBO3hkpfMtWS9ljhFWzf2DmSRynq3/Drb6buIrQvZyLD/qSjBn1wF37Klz
         SUfduIUpjzIj3ZXYWTg5lTfyf4oEsu4X+a+SmVxzVpFdXbFqeexKBTcFf1WGUfXo/+y0
         JZ8/aLdbI5VdH2fl9l6bNZIjyKdw5iC78x5Nk8JVNTcsyaxnMNyL91gSeYPRZBsOvJRf
         q8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k+cv9/8Sp0jhDfTqkaHbtLM5d5QXQGR0f5kzjPotgaE=;
        b=hf+JG8DXXzDP2GOScurPnyQQERysSfZJmfQ5YiC1F9G43+dIMMFr1Tm8+cxV0GpPDO
         Kh53ZyQjGp153mS1YjrOwrD+eU05qbsbuzMOLTkl+V4hYSoZ78SPGPwPL2luFVKySrfs
         0Url5qMsvjuw/eTfZoVFodWiLmgwbV/eXW+vZf8N4AzFfuxbuQBinzXCIxgVasKyOYeb
         4+/zZvCeeBBg9W+FFXY2gOTWavIssuBGQWs9dizYVZ+0VLfmftf/8J4eovSL0YrkhZaN
         GNQEaaNBQVCWB4cTNpB35RMT57hCi7u51ak7Ug3dJaJMYVf/4CQnLkWFvDBSNoCxmAhu
         qkHA==
X-Gm-Message-State: APjAAAXbv087nNLIEaXaNhpsCVs6w1FJmRTzjwSlIe7ilfFu0gC2WMIU
        xTwUWmN3UPESy+Vj4+NRI5H5gNNLmB0=
X-Google-Smtp-Source: APXvYqxMUMxa1h9uLzPiRHvcVLAXZAzEiAO/Y3bGcLiK5S5NnPVSNJLYsMbhcXpVdJJdVxnfyIP2MA==
X-Received: by 2002:a63:3409:: with SMTP id b9mr12187554pga.320.1574959811725;
        Thu, 28 Nov 2019 08:50:11 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:11 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 08/17] clk: stm32mp1: fix mcu divider table
Date:   Thu, 28 Nov 2019 09:49:53 -0700
Message-Id: <20191128165002.6234-9-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

commit 140fc4e406fac420b978a0ef2ee1fe3c641a6ae4 upstream

index 8: ck_mcu is divided by 256 (not 512)

Fixes: e51d297e9a92 ("clk: stm32mp1: add Sub System clocks")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/clk/clk-stm32mp1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-stm32mp1.c b/drivers/clk/clk-stm32mp1.c
index d602ae72eb81..851fb4e9ac44 100644
--- a/drivers/clk/clk-stm32mp1.c
+++ b/drivers/clk/clk-stm32mp1.c
@@ -269,7 +269,7 @@ static const struct clk_div_table axi_div_table[] = {
 static const struct clk_div_table mcu_div_table[] = {
 	{ 0, 1 }, { 1, 2 }, { 2, 4 }, { 3, 8 },
 	{ 4, 16 }, { 5, 32 }, { 6, 64 }, { 7, 128 },
-	{ 8, 512 }, { 9, 512 }, { 10, 512}, { 11, 512 },
+	{ 8, 256 }, { 9, 512 }, { 10, 512}, { 11, 512 },
 	{ 12, 512 }, { 13, 512 }, { 14, 512}, { 15, 512 },
 	{ 0 },
 };
-- 
2.17.1

