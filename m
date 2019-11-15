Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09725FE7FA
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfKOWe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45906 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbfKOWeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:06 -0500
Received: by mail-pg1-f195.google.com with SMTP id k1so5313047pgg.12
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XjmHZ2r/4EcW1pjM4Rd69/tyPSpvDzWdjKn2vf5w1qY=;
        b=a5q+0xMs8tIeJh8UJ8TVx8rZWUYZ16E5HxEnB0bRUqdlVxfqcyrfWViLr9Pn7dJisY
         VqRFpH8/EN3p18o/KhB6P43Ky8JCimROhKeXLcPYbCV9IN4oJ2CVylJtMtP7qfwro7o7
         SxdF13uvII4gAOlurEJrm50rCXFufEWhRyX+jcjvLDDHPbDNOBjiwTeiV6mHv4gY2lCf
         v6zbwJPxmKb/vDqIU9Wohh6rRB9E8a5QwUHIEM0ATxuwA7uLwKPIO6cIdiBE5ysfdmSV
         afv+gI97KSg+6usaoQb/OTeraFQQt+e/l1ahp52XQnTElIh1w5nC/Zk54P7lMFFDyeem
         GE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XjmHZ2r/4EcW1pjM4Rd69/tyPSpvDzWdjKn2vf5w1qY=;
        b=QhU0B+2ShaosgOev0AUaRx9D2bwdZj1Z/NubpFFpD4f55nXP9xwHjIWg/+9c5anwIw
         +RXcrAJ7xt01E23uGwj0NBPqrpbJb1oBq3+vbyubEjId+igZMmNrKolztjvUUEhkVs1X
         HausQlCmQoq9JwqRx+5bcaJq4Kt+xufMDTrCROZGU3harkzLmTGAmfKnQE9cIJXJdR13
         8Ya3WxJx654t2993EaqFOVmfB6NuotROkARVQQYTdGTkrgzjWV4+AT3INe70U5zYhL2c
         uQDC8ji2h43G++rlWartg5QjLRxb362zcWkw8mkGEblYt+xDqWUXU9XUlB/T/AZg1zvL
         zQkA==
X-Gm-Message-State: APjAAAU8MGbezSSgdBpekg2gORZJaYuTks9BzpVi3ZmyFwIBL5Csnsvj
        rJ9zXOUy3Qti/cRfu3TcK14UWhIu/AM=
X-Google-Smtp-Source: APXvYqx5QjFoyTLodbBskheBnK+zVxbguR/K9b4TV6wtQaQaNjBS6bpq3F/W36BhzlJQbuO0lG4qiQ==
X-Received: by 2002:a63:181f:: with SMTP id y31mr18239880pgl.186.1573857245156;
        Fri, 15 Nov 2019 14:34:05 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:04 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 09/20] clk: stm32mp1: fix HSI divider flag
Date:   Fri, 15 Nov 2019 15:33:45 -0700
Message-Id: <20191115223356.27675-9-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

commit d3f2e33c875de5052e032a9eefa64c897a930ed1 upstream

The divider of HSI (clk-hsi-div) is power of two divider.

Fixes: 9bee94e7b7da ("clk: stm32mp1: Introduce STM32MP1 clock driver")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/clk/clk-stm32mp1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-stm32mp1.c b/drivers/clk/clk-stm32mp1.c
index a907555b2a3d..d602ae72eb81 100644
--- a/drivers/clk/clk-stm32mp1.c
+++ b/drivers/clk/clk-stm32mp1.c
@@ -1655,8 +1655,8 @@ static const struct stm32_mux_cfg ker_mux_cfg[M_LAST] = {
 
 static const struct clock_config stm32mp1_clock_cfg[] = {
 	/* Oscillator divider */
-	DIV(NO_ID, "clk-hsi-div", "clk-hsi", 0, RCC_HSICFGR, 0, 2,
-	    CLK_DIVIDER_READ_ONLY),
+	DIV(NO_ID, "clk-hsi-div", "clk-hsi", CLK_DIVIDER_POWER_OF_TWO,
+	    RCC_HSICFGR, 0, 2, CLK_DIVIDER_READ_ONLY),
 
 	/*  External / Internal Oscillators */
 	GATE_MP1(CK_HSE, "ck_hse", "clk-hse", 0, RCC_OCENSETR, 8, 0),
-- 
2.17.1

