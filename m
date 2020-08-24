Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF724F85B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgHXJaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbgHXJaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 05:30:15 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30033C061575
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 02:30:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so3978345pjb.1
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 02:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pK5bVNvEUkGmkHt7h+22p1PRjllmkBfGKoPd86o06Lw=;
        b=zb6H8ukRfhieLWr3DBnUXOTmg55+e5EVKeqsfa2altwwB4K1VmjB+xm8dp0KBc1B0F
         KH/tRUbVH5H9kDw1etY4+d/Urtgr+0Uix5vBzCbL7jtkQ1eORBWByV8kv2G/GTNO34Vt
         mSH6FAZHzaRAefjA6cu7fJfPaD6DxdXrTBmzBKhB6v3cEnUrPrwh8faxFALumEMVOqJA
         CTTMXQeHQ8MSlQBI1kcnwyGWnp1vQ2Y8z7P0NgI/6mlqv0ZgTeOsB4RhP2gBC/WJvl+H
         E/7v/z49lP1blJipG/yCn02u9NiwT7GRfdVRKXa+EBMMQvQmxFyFlkyzbmIzDvLjy4lx
         1+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pK5bVNvEUkGmkHt7h+22p1PRjllmkBfGKoPd86o06Lw=;
        b=tN0zj1UPSwY0T1kwN8O9ZJwcdrVsSZR5SqNGwod47quhAIruICzL5wYzxlzbIBZNLH
         Kv4zSvjqhFXhzZHgM7Tf55p5vaI8whs4MrXz1YXHVpN6vLi6j+iTVkKPZoP/O5aegJEG
         9K/Z9YN8jRfKbUV8x1StDhahFh5OADp6K8N4ZpnyXv0AUFbGEOIdaX8a1z8BVIPRpPyZ
         zZhOL0jlmI0VD3hGBt/exR2sDOfqhDxuKT5SX8HujIthG3FOxiOeGnRcjbd9Gp3Vab6H
         YTPuE60MYWE0aCjTLdbBHvzR3N2OwcyzqFFvuPStelU3/J8tXR811iEQ52X4fuQOheeG
         2+Dw==
X-Gm-Message-State: AOAM530iAp3UcQ8m6+Q4ZdBdhlS8gNieWKWCzY1wVuNTUSyUnNd7i6QK
        2e9ZSK1T3q6WS/9qIG1BnTosrnDorXwu5Q==
X-Google-Smtp-Source: ABdhPJwzqLJz/+aP8JzlsLfMYGqG9zUEjWrPHt0rxu0+/5xAZOVgSxNCJ+v8x4WUX1WjzQRFq4pUgA==
X-Received: by 2002:a17:90a:448e:: with SMTP id t14mr3829392pjg.59.1598261414267;
        Mon, 24 Aug 2020 02:30:14 -0700 (PDT)
Received: from localhost ([122.172.43.13])
        by smtp.gmail.com with ESMTPSA id y3sm9647312pjg.8.2020.08.24.02.30.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 02:30:13 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Viresh Kumar <vireshk@kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Rajendra Nayak <rnayak@codeaurora.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH - for v5.7 stable] opp: Put opp table in dev_pm_opp_set_rate() for empty tables
Date:   Mon, 24 Aug 2020 15:00:03 +0530
Message-Id: <e7e9f887328c06800a79f3b48feb623fd15aa3d5.1598261323.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 8979ef70850eb469e1094279259d1ef393ffe85f upstream.

We get the opp_table pointer at the top of the function and so we should
put the pointer at the end of the function like all other exit paths
from this function do.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: aca48b61f963 ("opp: Manage empty OPP tables with clk handle")
Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
[ Viresh: Split the patch into two ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
[ Viresh: Update the code for v5.7-stable ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index bb7060d52eec..c94e725e6522 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -820,7 +820,7 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 		if (opp_table->required_opp_tables) {
 			ret = _set_required_opps(dev, opp_table, NULL);
 		} else if (!_get_opp_count(opp_table)) {
-			return 0;
+			ret = 0;
 		} else {
 			dev_err(dev, "target frequency can't be 0\n");
 			ret = -EINVAL;
-- 
2.25.0.rc1.19.g042ed3e048af

