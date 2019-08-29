Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCFFA18C5
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfH2LfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45718 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbfH2LfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id y8so1436315plr.12
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/kfHaZYBMHfOrWZM24aWUbS5m2tlkmGASsL26R9/1y0=;
        b=Gta/BjHJoeHx/0jnh1mD82z3khHO6OWus+AnqVK3jTMQburxYF8f+9Z5B3h2u7q1bT
         84dbThD5qRne9UCWmSA+BYv0pk23FljWmIz76uW6/Ow8fWPVKhgag2RjQ6C4kBvCWQo9
         +4QnJy6S6Fy5mLK5goPYNl7hYK4g/iMvBFs5tQeZTDY7DzYSBAIBNbPY3jKdVZb0GX1H
         +cMY5BX/5+4HCogaMqFgyON4hoe5hlRVX4WX/ekBlqCc9oWfPxiXwJI87eJ5Nd7Kz2Nn
         VkDV29OAc3yUJ8RMRXiQii5iSlSIIW1kucniCtdKxTkhYG+t2ECVSJf8APZjLZZk1x6V
         4kaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kfHaZYBMHfOrWZM24aWUbS5m2tlkmGASsL26R9/1y0=;
        b=C94XcVjB5aC91LVgcwCufOKSxcEBiArBexUZUv6xChoQ6YsaRie+I4oD1rHTnogujE
         x3a0BsTwGmJ7KRwGggzD3Vw6r/jwVEFcdV6z4LCdxXLvrIBSCn2XVAPJ8iNSkQHMl7Hn
         lFvHLJrFJAsUbIbE7PvOGXHevDOtvEuXMTjUG2x5iJOyQ+h11pmY+VrhGbRL6SyFJnEh
         Ez6IB9Ut+Pob+GXKOu0DDL7et6Hd35amI54l/sOXTexq938b88MK4bkhGzqP0QmFwpM1
         IIHGFhLF2mcuTL/Qp9EOmbykF03kZ08J34NbSHNpB/RnoG7FKqfVufDMp1ZOK0k8muM/
         SiwQ==
X-Gm-Message-State: APjAAAWGUPXbrVHVymmbvwMG3ZSFtfQDnsb8f81NQOCzMIOokYYEOpKB
        K6wlzUDqcNpmRdhYDPtGK2ay0XQp0Zk=
X-Google-Smtp-Source: APXvYqxM7jGRGQbSDy0SY4dxZ9IYLXcQDCvC70WuEYKduu0+qKWIRZX9TkcmWY5iFePShrSkm3BmVA==
X-Received: by 2002:a17:902:7c16:: with SMTP id x22mr6330064pll.234.1567078523996;
        Thu, 29 Aug 2019 04:35:23 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id y194sm2790098pfg.116.2019.08.29.04.35.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:23 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 12/44] arm64: cpufeature: Test 'matches' pointer to find the end of the list
Date:   Thu, 29 Aug 2019 17:03:57 +0530
Message-Id: <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 644c2ae198412c956700e55a2acf80b2541f6aa5 upstream.

CPU feature code uses the desc field as a test to find the end of the list,
this means every entry must have a description. This generates noise for
entries in the list that aren't really features, but combinations of them.
e.g.
> CPU features: detected feature: Privileged Access Never
> CPU features: detected feature: PAN and not UAO

These combination features are needed for corner cases with alternatives,
where cpu features interact.

Change all walkers of the arm64_features[] and arm64_hwcaps[] lists to test
'matches' not 'desc', and only print 'desc' if it is non-NULL.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c1eddc07d996..bdb4cd9ffccf 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -744,7 +744,7 @@ static void setup_cpu_hwcaps(void)
 	int i;
 	const struct arm64_cpu_capabilities *hwcaps = arm64_hwcaps;
 
-	for (i = 0; hwcaps[i].desc; i++)
+	for (i = 0; hwcaps[i].matches; i++)
 		if (hwcaps[i].matches(&hwcaps[i]))
 			cap_set_hwcap(&hwcaps[i]);
 }
@@ -754,11 +754,11 @@ void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 {
 	int i;
 
-	for (i = 0; caps[i].desc; i++) {
+	for (i = 0; caps[i].matches; i++) {
 		if (!caps[i].matches(&caps[i]))
 			continue;
 
-		if (!cpus_have_cap(caps[i].capability))
+		if (!cpus_have_cap(caps[i].capability) && caps[i].desc)
 			pr_info("%s %s\n", info, caps[i].desc);
 		cpus_set_cap(caps[i].capability);
 	}
@@ -772,7 +772,7 @@ static void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 {
 	int i;
 
-	for (i = 0; caps[i].desc; i++)
+	for (i = 0; caps[i].matches; i++)
 		if (caps[i].enable && cpus_have_cap(caps[i].capability))
 			/*
 			 * Use stop_machine() as it schedules the work allowing
@@ -884,7 +884,7 @@ void verify_local_cpu_capabilities(void)
 		return;
 
 	caps = arm64_features;
-	for (i = 0; caps[i].desc; i++) {
+	for (i = 0; caps[i].matches; i++) {
 		if (!cpus_have_cap(caps[i].capability) || !caps[i].sys_reg)
 			continue;
 		/*
@@ -897,7 +897,7 @@ void verify_local_cpu_capabilities(void)
 			caps[i].enable(NULL);
 	}
 
-	for (i = 0, caps = arm64_hwcaps; caps[i].desc; i++) {
+	for (i = 0, caps = arm64_hwcaps; caps[i].matches; i++) {
 		if (!cpus_have_hwcap(&caps[i]))
 			continue;
 		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i]))
-- 
2.21.0.rc0.269.g1a574e7a288b

