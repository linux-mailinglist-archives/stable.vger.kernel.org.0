Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA18FE7F0
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKOWeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:08 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34373 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfKOWeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:07 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so7346862pff.1
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/sm9ffuHyQlqHKvL/cAQ/Bj58CBN3LS1S5BSazdWb9s=;
        b=pM8P5t4PtpN4KMbwNUNzh+mn2x2kH6Il5JxeWrKcKQ8kx58doVIPMM4rtWksFJl4Yi
         xpsRjLEis5CKrLOAjaRS2tsUqYI7mBV7IEsmC35MdUVzIJq1+U59yl5C8M/5ckGv0OO2
         WsTXDoKyWjG+RTKzRIP3NmhG82iAuiyJHdHZJlXS2fg0egy7r7NhIwEmTwuwZI/snEuz
         HyEtEYXEheT/4bI8e0D8VFssUGtO3ESnWqkrCqal5Bv0wWXjt+RLeWPfWKS2b2ElEOdH
         b5dok1fcKq2xCkY6DxuuptOWNO3qxCRJOsuscR83yFKy8B3Q3vLeQv1yOg9D+rhmxnPG
         /v0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/sm9ffuHyQlqHKvL/cAQ/Bj58CBN3LS1S5BSazdWb9s=;
        b=L/rDi9rSRUQqleOMJtPuX4mseL/luYD5FbI/1DbE/NNdka945L2K+KZKQuw5RfnQJ6
         e7BUMYuMwyxQ4BZMoYdUorXZH00ghJKycC73FAivlBZGDteq1fliJMYcykVAcN/MRBWO
         LHj9SySVb1sbQasEoax92Sw71qYPFy8enq3DnC2dnbTYy9vkW1ZwYxkZdMQOXNzdCSfe
         PsikwU0SG4GvdFZq52iPoHMWXuYUp7JNiW/uqDrFCWZbCVOAVqQZYIScGG/T/WH2YD57
         zPP5MlreqbNkU0JL7yeuMaOWDVUsDzGCOvMSqDMEZDqWbKn2Z+Y6+8vQztVltdKhWXkO
         ZMww==
X-Gm-Message-State: APjAAAVBt/WDc2lB85NXgCaWSIamrsp7Hy8OdBJzlmJeOoMBQCOM/1F4
        qzVdx9XPkrKV5CBSXXv4LcfJm9YGBTk=
X-Google-Smtp-Source: APXvYqxhiASeIh6AbbOCOM1G3JW5aTZMnQlTM00qyXfaFHU8biTlEeNgh5n5hJS1PlX3q3qN6XW4ig==
X-Received: by 2002:a63:9247:: with SMTP id s7mr19675322pgn.334.1573857246932;
        Fri, 15 Nov 2019 14:34:06 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:06 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 11/20] clk: stm32mp1: add CLK_SET_RATE_NO_REPARENT to Kernel clocks
Date:   Fri, 15 Nov 2019 15:33:47 -0700
Message-Id: <20191115223356.27675-11-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

commit 72cfd1ad1057f16fc614861b3c271597995e57ba upstream

STM32MP1 clock IP offers lots of Kernel clocks that are shared
by multiple IP's at the same time.
Then boot loader applies a clock tree that allows to use all IP's
at same time and with the maximum of performance.
Not change parents on a change rate on kernel clocks ensures
the integrity of the system.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/clk/clk-stm32mp1.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-stm32mp1.c b/drivers/clk/clk-stm32mp1.c
index 851fb4e9ac44..8e25ed62f67b 100644
--- a/drivers/clk/clk-stm32mp1.c
+++ b/drivers/clk/clk-stm32mp1.c
@@ -1286,10 +1286,11 @@ _clk_stm32_register_composite(struct device *dev,
 	MGATE_MP1(_id, _name, _parent, _flags, _mgate)
 
 #define KCLK(_id, _name, _parents, _flags, _mgate, _mmux)\
-	     COMPOSITE(_id, _name, _parents, CLK_OPS_PARENT_ENABLE | _flags,\
-		  _MGATE_MP1(_mgate),\
-		  _MMUX(_mmux),\
-		  _NO_DIV)
+	     COMPOSITE(_id, _name, _parents, CLK_OPS_PARENT_ENABLE |\
+		       CLK_SET_RATE_NO_REPARENT | _flags,\
+		       _MGATE_MP1(_mgate),\
+		       _MMUX(_mmux),\
+		       _NO_DIV)
 
 enum {
 	G_SAI1,
@@ -1952,7 +1953,8 @@ static const struct clock_config stm32mp1_clock_cfg[] = {
 	MGATE_MP1(GPU_K, "gpu_k", "pll2_q", 0, G_GPU),
 	MGATE_MP1(DAC12_K, "dac12_k", "ck_lsi", 0, G_DAC12),
 
-	COMPOSITE(ETHPTP_K, "ethptp_k", eth_src, CLK_OPS_PARENT_ENABLE,
+	COMPOSITE(ETHPTP_K, "ethptp_k", eth_src, CLK_OPS_PARENT_ENABLE |
+		  CLK_SET_RATE_NO_REPARENT,
 		  _NO_GATE,
 		  _MMUX(M_ETHCK),
 		  _DIV(RCC_ETHCKSELR, 4, 4, CLK_DIVIDER_ALLOW_ZERO, NULL)),
-- 
2.17.1

