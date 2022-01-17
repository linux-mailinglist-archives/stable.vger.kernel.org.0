Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4C490CF3
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbiAQRAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241203AbiAQQ7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE00FC061755;
        Mon, 17 Jan 2022 08:59:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C226611EA;
        Mon, 17 Jan 2022 16:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0D1C36AE7;
        Mon, 17 Jan 2022 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438785;
        bh=4RrGe9wr71LWzqgF6XSoStKYKDl1f6S25cA8dDWoh9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xas4kFPk4iEINhYYtepIPLSY8GxKCbdMd+FZ6kZqvM0qtSdxgp1b0L86G7OCagD+n
         eWj4r2KNY8RXM4FtRstF+z/DSi/pXY2woy8XKvcfSnr9Plhr6Oy62mHsicXQD3e2AF
         06f+CHUqBy/RwYsdk4SEQ67h/ZEW5SJHayVJiKof4LLRexThTEDnemp5sel4+OHEC2
         c2Mzhzy46SNHBlP1e5UbtPzEzHMAkwCakK8BzhF1+o1rpa7e0GH8TgDfeg33pEDaq0
         NtuJrfufhCtCZ1foSTSy4EM4HqsRVPk1LNLapteITzHQx6w5ZgksZSD136OsNeToCi
         GODGHi3V3a3hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 21/52] interconnect: qcom: rpm: Prevent integer overflow in rate
Date:   Mon, 17 Jan 2022 11:58:22 -0500
Message-Id: <20220117165853.1470420-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit a7d9436a6c85fcb8843c910fd323dcd7f839bf63 ]

Using icc-rpm on ARM32 currently results in clk_set_rate() errors during
boot, e.g. "bus clk_set_rate error: -22". This is very similar to commit
7381e27b1e56 ("interconnect: qcom: msm8974: Prevent integer overflow in rate")
where the u64 is converted to a signed long during clock rate rounding,
resulting in an overflow on 32-bit platforms.

Let's fix it similarly by making sure that the rate does not exceed
LONG_MAX. Such high clock rates will surely result in the maximum
frequency of the bus anyway.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20211206114542.45325-1-stephan@gerhold.net
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index ef7999a08c8bf..8114295a83129 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -239,6 +239,7 @@ static int qcom_icc_set(struct icc_node *src, struct icc_node *dst)
 	rate = max(sum_bw, max_peak_bw);
 
 	do_div(rate, qn->buswidth);
+	rate = min_t(u64, rate, LONG_MAX);
 
 	if (qn->rate == rate)
 		return 0;
-- 
2.34.1

