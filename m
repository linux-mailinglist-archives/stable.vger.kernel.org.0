Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9725491A22
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbiARC6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347845AbiARCnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64DD860AB1;
        Tue, 18 Jan 2022 02:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108D2C36AEB;
        Tue, 18 Jan 2022 02:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473792;
        bh=qxKAY0lHjDaFDfgLk83pfnzmbbzeEt3hIFCB9qqI01Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJj0ObyrajEBFwJar5Jqb869D991jsF4hC3Sryh6gsyUAxxWeUASIF7czC/Avqrj2
         Zrr8ttDskU8wY0b0d0FnXgdcU2OPAMMwmn+KalxJ6e4t5KvY8jaiY39L6Ds4dllNJz
         EXIIdSNlI3VAuMkIbMtI5suBneqLWnSSfTFq2AtvBD8AjIK/3GZhA8GQjx0bP1oXE8
         QPY9BkwhtFR8DOE9E0FWVlJNzLRdA+TCHayudLI5Gh3/XJYloUl/1pim17uBaaTMCI
         vfq8qEWpycjYFfllb8c+5BhDYC+xzZzKOBaaJmYE8LNa+jLsvnWEoSmtJG6MaoQRTH
         pmAsG8f8c3aNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 075/116] cpufreq: Fix initialization of min and max frequency QoS requests
Date:   Mon, 17 Jan 2022 21:39:26 -0500
Message-Id: <20220118024007.1950576-75-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 8e159fb6af9cd..30dafe8fc5054 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1400,7 +1400,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->min_freq_req, FREQ_QOS_MIN,
-					   policy->min);
+					   FREQ_QOS_MIN_DEFAULT_VALUE);
 		if (ret < 0) {
 			/*
 			 * So we don't call freq_qos_remove_request() for an
@@ -1420,7 +1420,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->max_freq_req, FREQ_QOS_MAX,
-					   policy->max);
+					   FREQ_QOS_MAX_DEFAULT_VALUE);
 		if (ret < 0) {
 			policy->max_freq_req = NULL;
 			goto out_destroy_policy;
-- 
2.34.1

