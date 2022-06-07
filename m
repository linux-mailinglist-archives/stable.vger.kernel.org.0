Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD40541989
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352333AbiFGVWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380698AbiFGVQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3047A14AF70;
        Tue,  7 Jun 2022 11:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C036D61311;
        Tue,  7 Jun 2022 18:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACF2C385A2;
        Tue,  7 Jun 2022 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628183;
        bh=r3DLkc6jEcY3i0/3z56pH0qiShiXBiSeWD+DV9othKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wtGeOixaWLcyLofPkvsBSJC3xddUg+Tqu9olhOX1qpKZWCsh/lGfycSdggZb4f7MO
         +eMmp73dXpBo9SseJ3HcDKCKhUqh34jCr3gL7HwyadO8Y0LbcfJj0R1qGI0oYUqOyF
         NxGYVRzAI0xEfav57eAme1q03k8/RsBs+y5ZsDvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jia-wei Chang <jia-wei.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 234/879] cpufreq: Avoid unnecessary frequency updates due to mismatch
Date:   Tue,  7 Jun 2022 18:55:52 +0200
Message-Id: <20220607165009.646354366@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit f55ae08c89873e140c7cac2a7fa161d31a0d60cf ]

For some platforms, the frequency returned by hardware may be slightly
different from what is provided in the frequency table. For example,
hardware may return 499 MHz instead of 500 MHz. In such cases it is
better to avoid getting into unnecessary frequency updates, as we may
end up switching policy->cur between the two and sending unnecessary
pre/post update notifications, etc.

This patch has chosen allows the hardware frequency and table frequency
to deviate by 1 MHz for now, we may want to increase it a bit later on
if someone still complains.

Reported-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Jia-wei Chang <jia-wei.chang@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 80f535cc8a75..fbaa8e6c7d23 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/tick.h>
+#include <linux/units.h>
 #include <trace/events/power.h>
 
 static LIST_HEAD(cpufreq_policy_list);
@@ -1707,6 +1708,16 @@ static unsigned int cpufreq_verify_current_freq(struct cpufreq_policy *policy, b
 		return new_freq;
 
 	if (policy->cur != new_freq) {
+		/*
+		 * For some platforms, the frequency returned by hardware may be
+		 * slightly different from what is provided in the frequency
+		 * table, for example hardware may return 499 MHz instead of 500
+		 * MHz. In such cases it is better to avoid getting into
+		 * unnecessary frequency updates.
+		 */
+		if (abs(policy->cur - new_freq) < HZ_PER_MHZ)
+			return policy->cur;
+
 		cpufreq_out_of_sync(policy, new_freq);
 		if (update)
 			schedule_work(&policy->update);
-- 
2.35.1



