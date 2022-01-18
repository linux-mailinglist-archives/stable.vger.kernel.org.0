Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7B949160B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiARCcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345191AbiARCbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:31:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F48C07E5FE;
        Mon, 17 Jan 2022 18:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB760610AB;
        Tue, 18 Jan 2022 02:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252C7C36AEB;
        Tue, 18 Jan 2022 02:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472911;
        bh=Zlb1GxZyQU5sZAlAtxJ1xvGbM1W1LxN/N01mLYXusvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWgweuE7DwAFp+/4BedNB2FmEcv11fK5noZZlBFRT6ckE3ixtQwWzTgoo4KSvgwRj
         vpQ+d2OdGQQmQjT95VDUgSu0lKCwf487KVLKMcm5AIJbXr9gbIf5RCYv5fu6K11hsG
         u5HWbd1Hx0qQTfGj0js8sKux/LKeGBQx+EL0ZHeNapd+5TBmCLuqsaiCH24TW3Fy7G
         4+B8UUGa5XIScKZ2UiTj5oX5VNrPdLqUC9fUkW78pzkiShLQR8qekm42rbQORnWadZ
         OZzK54CJ5u2aD+sOhM4aD3ZGe/3isGt/IIq0sA2fOzi6Lmc+oL8j+c1kOQ1Rd9cSHw
         yRxJo/cpF9/Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, nks@flawful.org,
        agross@kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 162/217] PM: AVS: qcom-cpr: Use div64_ul instead of do_div
Date:   Mon, 17 Jan 2022 21:18:45 -0500
Message-Id: <20220118021940.1942199-162-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

[ Upstream commit 92c550f9ffd2884bb5def52b5c0485a35e452784 ]

do_div() does a 64-by-32 division. Here the divisor is an unsigned long
which on some platforms is 64 bit wide. So use div64_ul instead of do_div
to avoid a possible truncation.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211125014311.45942-1-deng.changcheng@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cpr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/cpr.c b/drivers/soc/qcom/cpr.c
index 1d818a8ba2089..e9b854ed1bdfd 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1010,7 +1010,7 @@ static int cpr_interpolate(const struct corner *corner, int step_volt,
 		return corner->uV;
 
 	temp = f_diff * (uV_high - uV_low);
-	do_div(temp, f_high - f_low);
+	temp = div64_ul(temp, f_high - f_low);
 
 	/*
 	 * max_volt_scale has units of uV/MHz while freq values
-- 
2.34.1

