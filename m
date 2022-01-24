Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305F0499C57
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579071AbiAXWE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577818AbiAXWBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:01:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4875C02B844;
        Mon, 24 Jan 2022 12:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E3861382;
        Mon, 24 Jan 2022 20:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F7C340E5;
        Mon, 24 Jan 2022 20:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056836;
        bh=VjeGrVWKUxuNF7cBz0+iP8hkmF9ifj/wPGSoiuV5FjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bylGvJ+PS+mIe41rrC/t5uK3fhYHwjyxQcqyM5rU8vgQSD58dSYQ9ffWy5mgjDknb
         sJOodgIqyR5ZjmYttS51dZ3HXRmHxU513YmnGp4/rPym1cQe7eK0cX6xl56tLWWkEs
         c0Aipw741wbMQTf3j8qLCqYUjxfXrOXpSeV83zeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 574/846] PM: AVS: qcom-cpr: Use div64_ul instead of do_div
Date:   Mon, 24 Jan 2022 19:41:31 +0100
Message-Id: <20220124184120.836060659@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4ce8e816154f9..84dd93472a252 100644
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



