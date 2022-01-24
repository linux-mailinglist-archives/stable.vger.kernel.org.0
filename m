Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656B549A029
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842108AbiAXXAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836484AbiAXWjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B40C054870;
        Mon, 24 Jan 2022 13:00:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1DC9B80FA1;
        Mon, 24 Jan 2022 21:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FE3C340E5;
        Mon, 24 Jan 2022 21:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058054;
        bh=MkNJ0R11zL6n7hF6vlIkD+vGmpNLfrFTWV3DUt/AYkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRgLAbuc26JFrl1fLWfK7k1ABfkSR6VjAxOp4EKcKaTa+pglcA1e6PO5HoAmnoq41
         3mFkUZ8lBXvs/faqMtrqLVil/5plnuuj6f3y25w1xKHPZI7TwsnijtGIIwJR+dW+yM
         GLjdwoG9arZZaYYCfqVS3FmBZIDL3AwL7mZE+12k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0167/1039] cpufreq: qcom-hw: Fix probable nested interrupt handling
Date:   Mon, 24 Jan 2022 19:32:36 +0100
Message-Id: <20220124184130.833736034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit e0e27c3d4e20dab861566f1c348ae44e4b498630 ]

Re-enabling an interrupt from its own interrupt handler may cause
an interrupt storm, if there is a pending interrupt and because its
handling is disabled due to already done entrance into the handler
above in the stack.

Also, apparently it is improper to lock a mutex in an interrupt contex.

Fixes: 275157b367f4 ("cpufreq: qcom-cpufreq-hw: Add dcvs interrupt support")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 0138b2ec406dc..35d93361fda1a 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -343,9 +343,9 @@ static irqreturn_t qcom_lmh_dcvs_handle_irq(int irq, void *data)
 
 	/* Disable interrupt and enable polling */
 	disable_irq_nosync(c_data->throttle_irq);
-	qcom_lmh_dcvs_notify(c_data);
+	schedule_delayed_work(&c_data->throttle_work, 0);
 
-	return 0;
+	return IRQ_HANDLED;
 }
 
 static const struct qcom_cpufreq_soc_data qcom_soc_data = {
-- 
2.34.1



