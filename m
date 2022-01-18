Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00F4491A30
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344345AbiARC6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38644 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348805AbiARCqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB1C6130A;
        Tue, 18 Jan 2022 02:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E7FC36AEF;
        Tue, 18 Jan 2022 02:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473967;
        bh=dCmLun5k8+53l0a2rmKskLmjLJcPJKfcQnoQY+F6V1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2PQAOqyFHbhc0577d2W0iXTv108CAwuog6d3zNACNWtWgf89Os8ZnU2mW5UKeSHH
         wqiPZ0+rX/hqqEJ1JjShoS7IfJwlG5Tz9eCdE206FRUwp80+dIygvDxq3Iiz8oR6kB
         htv6CUu3u0oqJ+jlv6f0lp0Shw/xV3q0LjklZA19ajVOaxTthUMVK5HM3nceXHOV/d
         ayi3JzKeqRyR0gG2lgPJ2hc5n0hGvjVWMdl1j9rV5f7IF6DglgjEk/fqe3mh6PmMGG
         0ZwbltRAoxVsGw5cyhfzCHNiinQHfk3e/zRC6TUHjEUojQnOyI3F9usqUXskPV3bSg
         LHCpJLrRxDmJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 46/73] cpufreq: Fix initialization of min and max frequency QoS requests
Date:   Mon, 17 Jan 2022 21:44:05 -0500
Message-Id: <20220118024432.1952028-46-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index cb7949a2ac0ca..af9f348048629 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1393,7 +1393,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->min_freq_req, FREQ_QOS_MIN,
-					   policy->min);
+					   FREQ_QOS_MIN_DEFAULT_VALUE);
 		if (ret < 0) {
 			/*
 			 * So we don't call freq_qos_remove_request() for an
@@ -1413,7 +1413,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->max_freq_req, FREQ_QOS_MAX,
-					   policy->max);
+					   FREQ_QOS_MAX_DEFAULT_VALUE);
 		if (ret < 0) {
 			policy->max_freq_req = NULL;
 			goto out_destroy_policy;
-- 
2.34.1

