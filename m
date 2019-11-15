Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F562FE7F9
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfKOWey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:54 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34372 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfKOWeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:07 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so7346843pff.1
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JeAIVfldLUVTvSXCSoIJcdwhrHS7EelSGWycmLvcpHo=;
        b=tD6THbMUpRjMLKRy7mjdFZRPWf6FlQ9n8BkmlAuG3KvMrw6+4glewlNU998SaSVKF8
         K1uXfh+VqFX7pN5G1dMZ+PDt3sdSRJUjziV9sIlmfI6iD8wG/dc3DBFAZQvyjct+zTae
         JDTIYU6eMfFwrytgreUfC0TJi6nwhYOUbr1NUKRqk7A/JJCsETttQq2N/aTbs7oVKz/B
         5ePF67K4RWaW231sXOBynfpzKnZ6ZoDkZIG30ycvhJ8hI5uGb0Ulrf+yNIWs61bJjyiw
         PC/6KEg/oqocsQ5/U1x6oZnJpoTwp0Y67DPWOBkJQ5DYuPj8gJIctO4Awi8svthRg6rH
         TAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JeAIVfldLUVTvSXCSoIJcdwhrHS7EelSGWycmLvcpHo=;
        b=Le7QGFnje4k3z39JJnBS7tacyuIJwz6VUeoCwCntiUcZ12vIRREjWtcL9GqsxjhIgU
         U4CbU1LkE8eTfVWnybPtjefZxgNsVqjWKMvMgtNnJqVIJ2VJWWgvgjlxVCxgAVcvJkS5
         3h5pc3N66a93KY7t4hz7qPlQW/cZxWqYYQ4T8Z5eAVMd8O4TpnOqBwNQzNqIN1dT5xtQ
         bcTVSRohWq3xR/d/YTSitw1aIZkQzLRnYOJFIUItjp/rYvNb2KRD+NIGgem3Z9IIvfIu
         pNDvsui2mtNz7EYHkprovDVM8dKbxWSUMurqsHAMR7AuEwccBngkjriJWhG7l2bbUcSA
         NgxA==
X-Gm-Message-State: APjAAAV7nyeHNK5dPN6yX9EyCglCxNaBM387Jk3ts1MB1+9nUcdfo9xC
        Ad5zQ820RIumjEvcniqY1FLzy4alWGA=
X-Google-Smtp-Source: APXvYqxEuvWJPe5IPrGR1qUJFfqVEooRRTzfUt59swIGQbMJtrGOpHkD3l0yKEsEFfb7ErCC6auxCQ==
X-Received: by 2002:a63:6c4:: with SMTP id 187mr19457722pgg.421.1573857246083;
        Fri, 15 Nov 2019 14:34:06 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:05 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 10/20] clk: stm32mp1: fix mcu divider table
Date:   Fri, 15 Nov 2019 15:33:46 -0700
Message-Id: <20191115223356.27675-10-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
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
Cc: stable <stable@vger.kernel.org> # 4.19+
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

