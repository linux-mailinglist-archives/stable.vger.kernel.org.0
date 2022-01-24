Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED2049A3F0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369190AbiAYABL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847031AbiAXXSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BAEC06F8D6;
        Mon, 24 Jan 2022 13:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9215B81243;
        Mon, 24 Jan 2022 21:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3513CC340E4;
        Mon, 24 Jan 2022 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059589;
        bh=N5cFYl5qlbcsInQjVrE7IG8gddEZ3I2S9BMXo0GCtUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzEp380x6h16gR8g8EOhKZv+NWfjAHNeDq1I0pAqYh+09nKOHVy3He2ojtly21bAW
         hbL5fy+rXRMRb4EEJI8s7PBIY2E+5Znc5Rpo8GMiuQcDR/0e/NEFQ8j++IcPUkRWmh
         YZrqcbt4rXhcDhQHF9Zb1oM2dqndvCMZIS57dRRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0667/1039] cpufreq: Fix initialization of min and max frequency QoS requests
Date:   Mon, 24 Jan 2022 19:40:56 +0100
Message-Id: <20220124184147.797717994@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index 096c3848fa415..76ffdaf8c8b5e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1403,7 +1403,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->min_freq_req, FREQ_QOS_MIN,
-					   policy->min);
+					   FREQ_QOS_MIN_DEFAULT_VALUE);
 		if (ret < 0) {
 			/*
 			 * So we don't call freq_qos_remove_request() for an
@@ -1423,7 +1423,7 @@ static int cpufreq_online(unsigned int cpu)
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->max_freq_req, FREQ_QOS_MAX,
-					   policy->max);
+					   FREQ_QOS_MAX_DEFAULT_VALUE);
 		if (ret < 0) {
 			policy->max_freq_req = NULL;
 			goto out_destroy_policy;
-- 
2.34.1



