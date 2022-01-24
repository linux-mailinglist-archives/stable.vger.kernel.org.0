Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6049909D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349657AbiAXUBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:01:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45018 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359599AbiAXT7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:59:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE2FFB81215;
        Mon, 24 Jan 2022 19:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D05C340E5;
        Mon, 24 Jan 2022 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054391;
        bh=lqjG8Z5Qsq8axODgfIxil7lLhZeJUVwF0kCwte+SYhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUPkqUcwcklvffbIRjZHxIcH1KSskQvLdvqImfuuy0NxDMCoRmzrM72QicI3oQLgy
         Y81U8R6l0W9S94+GJlIVINCKkTsLI30Xsdyho498cxPigvb643W/SC/q+Xnn0aj/lp
         dEy5VIN3ZZwl6u/rOw4uoBMsmxgplFydxG2GBEHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/563] PM: AVS: qcom-cpr: Use div64_ul instead of do_div
Date:   Mon, 24 Jan 2022 19:42:19 +0100
Message-Id: <20220124184037.346047259@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index b24cc77d1889f..6298561bc29c9 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1043,7 +1043,7 @@ static int cpr_interpolate(const struct corner *corner, int step_volt,
 		return corner->uV;
 
 	temp = f_diff * (uV_high - uV_low);
-	do_div(temp, f_high - f_low);
+	temp = div64_ul(temp, f_high - f_low);
 
 	/*
 	 * max_volt_scale has units of uV/MHz while freq values
-- 
2.34.1



