Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0945209E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345153AbhKPAzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343500AbhKOTVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F4036359A;
        Mon, 15 Nov 2021 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001660;
        bh=JfiPDyhmrqTYhgVXyzzXfoesRZvsrR53ySIMjPrByOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8m1djFoNS0jinqeX+xCSwYxzpeQGm0P/8n8U7uM5C91xTtR4epnO2Az/uFhcYKVW
         DdkGDPN5jlQDOSakFU8AcJCsutpO2ZcprxbLsUOpFovfUG4vRzphDrhBwMzKT0W+c7
         OK52dNyzGJzbFzkcyxt5CO+ctXJAcDxqbW8K89uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/917] cpufreq: Make policy min/max hard requirements
Date:   Mon, 15 Nov 2021 17:55:35 +0100
Message-Id: <20211115165436.932147530@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit 15171769069408789a72f9aa9a52cc931b839b56 ]

When applying the policy min/max limits, the requested frequency is
simply clamped to not be out of range. It means, however, if one of the
boundaries isn't an available frequency, the frequency resolution can
return a value out of those limits, depending on the relation used.

e.g. freq{0,1,2} being available frequencies.

          freq0  policy->min  freq1  policy->max   freq2
            |        |          |        |           |
          17kHz     18kHz     19kHz     20kHz      21kHz

     __resolve_freq(21kHz, CPUFREQ_RELATION_L) -> 21kHz (out of bounds)
     __resolve_freq(17kHz, CPUFREQ_RELATION_H) -> 17kHz (out of bounds)

If, during the policy init, we resolve the requested min/max to existing
frequencies, we ensure that any CPUFREQ_RELATION_* would resolve to a
frequency which is inside the policy min/max range.

Making the policy limits rigid helps to introduce the inefficient
frequencies support. Resolving an inefficient frequency to an efficient
one should not transgress policy->max (which can be set for thermal
reason) and having a value we can trust simplify this comparison.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5782b15a8caad..284e940084c61 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2523,8 +2523,15 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	if (ret)
 		return ret;
 
+	/*
+	 * Resolve policy min/max to available frequencies. It ensures
+	 * no frequency resolution will neither overshoot the requested maximum
+	 * nor undershoot the requested minimum.
+	 */
 	policy->min = new_data.min;
 	policy->max = new_data.max;
+	policy->min = __resolve_freq(policy, policy->min, CPUFREQ_RELATION_L);
+	policy->max = __resolve_freq(policy, policy->max, CPUFREQ_RELATION_H);
 	trace_cpu_frequency_limits(policy);
 
 	policy->cached_target_freq = UINT_MAX;
-- 
2.33.0



