Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673B3490DA9
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbiAQREd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241859AbiAQRCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE271C0613A0;
        Mon, 17 Jan 2022 09:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F093611C0;
        Mon, 17 Jan 2022 17:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358C2C36AE3;
        Mon, 17 Jan 2022 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438927;
        bh=Ht43UxNFhdmKPNTqhSR/k8BwiUdZV1+y0lRQ40YRnCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbHjZ2wCfBHmsSG17snbTTu7l9UzJIW91PRVl1fJPNooeARPLHPMb+2H6AIYHE0Ko
         6culZs94USRHLk6anvFlmENQ//I9KKSuUUjR2TDohmK/Yrb1rE8SwnrfvFyDGWGzn3
         lIjyfS5/LAcagGo1jSPYOt50Wh7mQx8FOe/gGEap8rtah4Yzu1mT8FcvSXJeDscNSt
         AvAsy5x8WdpTaHCpSdIvlPDdrstqGqZWjTCP8peOnwGE7/ffkzXtB8lwLr6ec6T8Yj
         Xsawc6Rt9Fokt7s8hpo/rdarbQN29FMBrUwdx/+wrtt+9KUwZHbd/iowfm3PVYTJFC
         g/vbbbbPM/9TA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/44] interconnect: qcom: rpm: Prevent integer overflow in rate
Date:   Mon, 17 Jan 2022 12:01:01 -0500
Message-Id: <20220117170127.1471115-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index 54de49ca7808a..ddf1805ded0c0 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -68,6 +68,7 @@ static int qcom_icc_set(struct icc_node *src, struct icc_node *dst)
 	rate = max(sum_bw, max_peak_bw);
 
 	do_div(rate, qn->buswidth);
+	rate = min_t(u64, rate, LONG_MAX);
 
 	if (qn->rate == rate)
 		return 0;
-- 
2.34.1

