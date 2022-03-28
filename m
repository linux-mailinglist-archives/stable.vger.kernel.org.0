Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7C64E93B2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbiC1LYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241340AbiC1LXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA42959A47;
        Mon, 28 Mar 2022 04:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC957B81055;
        Mon, 28 Mar 2022 11:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C33C340EC;
        Mon, 28 Mar 2022 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466436;
        bh=W/lcVOcoPY+v/WrwziGHG8JE2ki8hpSfLXopMnCP2oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1PZEuZuFmB6O3A1pjlN90VnVw8oZqr24FCo1MJFPlVKHFQPPzLEWlcDnVcjdvIlr
         h0sxVe5jMpsxT5di1gJqkbYgKbpECddQIRCpKUIDUuSjhBcOTn9/lDQa29QX2aqYQv
         unw3457EbPKpNENQp7blubSNKYeZYo5mGK3i98G4NuhOpfNke2vQEhRbEjd8CKWh8a
         S3GKM/iAb2vAKn+scYjAdiZq3geiLouLKhp3XCkt+E4IFVRNGEqR9XHmHT1r5hgWdM
         RFJf3UFngP8lND6oLUJ6RCl0Rkw402uJg7GC5FZ/85hcfkn87+HBT/Fk6WQdTUIgOs
         lqva7k+KjJnEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, daniel.lezcano@kernel.org,
        rafael@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 15/35] powercap/dtpm_cpu: Reset per_cpu variable in the release function
Date:   Mon, 28 Mar 2022 07:19:51 -0400
Message-Id: <20220328112011.1555169-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112011.1555169-1-sashal@kernel.org>
References: <20220328112011.1555169-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

