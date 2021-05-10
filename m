Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B67378793
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhEJLQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236603AbhEJLIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A552E619B6;
        Mon, 10 May 2021 11:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644554;
        bh=U5VH1FjoHIBdj44rOau1N1EsQ+mJhMw5NKpHZphx7UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQEpaupf+y+N+ecIPS8xQFn4i5WGjE3At8k0Ug5m12ynVo8cN3j2ziKVBFCAK+ved
         Ips/7PeWNPo9tBWbzzvyyy/12o0cLXh0JrdB3iSd3I/SGLQZnFsbSSuOVo3DPVN8Oo
         zI/TJK6f3fN3tPekVWF2nPIWI7GkuXfUNuZPbhm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 112/384] clocksource/drivers/dw_apb_timer_of: Add handling for potential memory leak
Date:   Mon, 10 May 2021 12:18:21 +0200
Message-Id: <20210510102018.591114191@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 397dc6f7ca3c858dc95800f299357311ccf679e6 ]

Add calls to disable the clock and unmap the timer base address in case
of any failures.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210322121844.2271041-1-dinguyen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/dw_apb_timer_of.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 42e7e43b8fcd..b1e2b697b21b 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -52,18 +52,34 @@ static int __init timer_get_base_and_rate(struct device_node *np,
 		return 0;
 
 	timer_clk = of_clk_get_by_name(np, "timer");
-	if (IS_ERR(timer_clk))
-		return PTR_ERR(timer_clk);
+	if (IS_ERR(timer_clk)) {
+		ret = PTR_ERR(timer_clk);
+		goto out_pclk_disable;
+	}
 
 	ret = clk_prepare_enable(timer_clk);
 	if (ret)
-		return ret;
+		goto out_timer_clk_put;
 
 	*rate = clk_get_rate(timer_clk);
-	if (!(*rate))
-		return -EINVAL;
+	if (!(*rate)) {
+		ret = -EINVAL;
+		goto out_timer_clk_disable;
+	}
 
 	return 0;
+
+out_timer_clk_disable:
+	clk_disable_unprepare(timer_clk);
+out_timer_clk_put:
+	clk_put(timer_clk);
+out_pclk_disable:
+	if (!IS_ERR(pclk)) {
+		clk_disable_unprepare(pclk);
+		clk_put(pclk);
+	}
+	iounmap(*base);
+	return ret;
 }
 
 static int __init add_clockevent(struct device_node *event_timer)
-- 
2.30.2



