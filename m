Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68678499267
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351180AbiAXUTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:19:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42938 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380870AbiAXURB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:17:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BFD761371;
        Mon, 24 Jan 2022 20:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B65C340E5;
        Mon, 24 Jan 2022 20:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055420;
        bh=MkNJ0R11zL6n7hF6vlIkD+vGmpNLfrFTWV3DUt/AYkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHdkHUI3CHO24dizMh3z827SZXQ0TGj1qIhNDWQRBAIyqt8WZXlTH1u13q43FQYNC
         TDlUx3qz3tQ/oC7PfBitnj6nNgaxgHzHYkqM+cP93hAQSxygnPdH7BlOvgPdftJja2
         Hu92ceU1ZfY9V9/kPlPmiSXYjTf5RAuxKcCxJTOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/846] cpufreq: qcom-hw: Fix probable nested interrupt handling
Date:   Mon, 24 Jan 2022 19:34:21 +0100
Message-Id: <20220124184105.953052126@linuxfoundation.org>
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



