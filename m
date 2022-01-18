Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BC84917D5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245115AbiARCnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45732 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344667AbiARChq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:37:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4080B81233;
        Tue, 18 Jan 2022 02:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0913AC36AF2;
        Tue, 18 Jan 2022 02:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473463;
        bh=pPw5cqi3vaScQsJmozSNEe1jYl0Dhr9g/WHQQQq/ucI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJRXDVYHxcGu0qoIaVIVIm0G0i8rOuXPpmTVGFM0xA+rIrmfu4WY5vi4lz5HOaMGT
         D5BvvQKdatFAh8+Zc/+YNE/DfbNV62TOqrDOO/wONvbizLYwb+y6+QWdjAL4AMFYyc
         LqN8hj+o73GW6rHfuHXl2FtqQ5mrDqMSqxAUnlbBn1kn8JBYAMvhgh2AQofBG8P6po
         tjgsqOPhNPcfMe0l9id+lEgzXnIVetiw3Y4zqLB4Wrg5HPfGbzjQy7+XxuPobeZR5v
         q1rdDEjDvlHZ01yo6LfrpA7qxKwVcFBfqNUEWwIEyTXT3KZ/1PXN/cZ1TqPV5diKWr
         mL8EKWB3iBOyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 128/188] cpufreq: Fix initialization of min and max frequency QoS requests
Date:   Mon, 17 Jan 2022 21:30:52 -0500
Message-Id: <20220118023152.1948105-128-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 521223d8b3ec078f670c7c35a1a04b1b2af07966 ]

The min and max frequency QoS requests in the cpufreq core are
initialized to whatever the current min and max frequency values are
at the init time, but if any of these values change later (for
example, cpuinfo.max_freq is updated by the driver), these initial
request values will be limiting the CPU frequency unnecessarily
unless they are changed by user space via sysfs.

To address this, initialize min_freq_req and max_freq_req to
FREQ_QOS_MIN_DEFAULT_VALUE and FREQ_QOS_MAX_DEFAULT_VALUE,
respectively, so they don't really limit anything until user
space updates them.

Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fcb44352623ee..eeac6d8092298 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1402,7 +1402,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->min_freq_req, FREQ_QOS_MIN,
-					   policy->min);
+					   FREQ_QOS_MIN_DEFAULT_VALUE);
 		if (ret < 0) {
 			/*
 			 * So we don't call freq_qos_remove_request() for an
@@ -1422,7 +1422,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->max_freq_req, FREQ_QOS_MAX,
-					   policy->max);
+					   FREQ_QOS_MAX_DEFAULT_VALUE);
 		if (ret < 0) {
 			policy->max_freq_req = NULL;
 			goto out_destroy_policy;
-- 
2.34.1

