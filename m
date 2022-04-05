Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6AD4F3220
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiDEKGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344238AbiDEJSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBFA496B3;
        Tue,  5 Apr 2022 02:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE95CB818F3;
        Tue,  5 Apr 2022 09:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD30C385A3;
        Tue,  5 Apr 2022 09:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149574;
        bh=W/lcVOcoPY+v/WrwziGHG8JE2ki8hpSfLXopMnCP2oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyrGP4JsAGrCtmBEenWC/UhPCpGRxmPGVOvsiKhtJQJolT+TWi4Ubh+GqhaHF7tAx
         ul7Eif+3zwI/4r4/T/XPYPQbjCDZjwkG+vmVNkiw/L03zNHW8bj3ht70A8NfCCJlLA
         zckJ/5XmB4/uZYoJrxmTKOsVgXWv2iEz81b2OQN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0765/1017] powercap/dtpm_cpu: Reset per_cpu variable in the release function
Date:   Tue,  5 Apr 2022 09:27:58 +0200
Message-Id: <20220405070416.969633584@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 0aea2e4ec2a2bfa2d7e8820e37ba5b5ce04f20a5 ]

The release function does not reset the per cpu variable when it is
called. That will prevent creation again as the variable will be
already from the previous creation.

Fix it by resetting them.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20220130210210.549877-2-daniel.lezcano@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/dtpm_cpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/powercap/dtpm_cpu.c b/drivers/powercap/dtpm_cpu.c
index b740866b228d..1e8cac699646 100644
--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -150,10 +150,17 @@ static int update_pd_power_uw(struct dtpm *dtpm)
 static void pd_release(struct dtpm *dtpm)
 {
 	struct dtpm_cpu *dtpm_cpu = to_dtpm_cpu(dtpm);
+	struct cpufreq_policy *policy;
 
 	if (freq_qos_request_active(&dtpm_cpu->qos_req))
 		freq_qos_remove_request(&dtpm_cpu->qos_req);
 
+	policy = cpufreq_cpu_get(dtpm_cpu->cpu);
+	if (policy) {
+		for_each_cpu(dtpm_cpu->cpu, policy->related_cpus)
+			per_cpu(dtpm_per_cpu, dtpm_cpu->cpu) = NULL;
+	}
+	
 	kfree(dtpm_cpu);
 }
 
-- 
2.34.1



