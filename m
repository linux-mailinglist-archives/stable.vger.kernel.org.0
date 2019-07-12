Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7D6662D
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfGLF3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43502 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so3784679pfg.10
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/kfHaZYBMHfOrWZM24aWUbS5m2tlkmGASsL26R9/1y0=;
        b=cGmYhryoCvANnaH4geFrp/J9iYbsc93CKBZgUMA9oUfaIiy5wdBhR4DlJmw3lRYYkA
         aVW9vCmzdn45ZIMZ1dMMq/N8JVs1GCVa8B89kv/v7c3FKhtB39xYSiG73QQR4kuM3JAb
         cL1tc5wyGgB1cEYzqSLcMKjG3Zfs2ngs3HKGI2Fy4Xyuya6kSkwu/P5920GkpBbj4Wk5
         0q+nHiS2Ldbb8I+Wr9P0dryCEaZ2EiWQbjXGgDW2oeZoZQq2mF8seW0WrqTaTajMVkse
         GAdrTI0Kwc1mmnP0MN7Jp2dKsjRroebJ8GorFrfv+bWbEsgna60JLumwtDgx9vOMEbyA
         /O1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kfHaZYBMHfOrWZM24aWUbS5m2tlkmGASsL26R9/1y0=;
        b=oc9m+7Gwzd57Vqbm0wXOkrw44ElTrILA5Z+vTfsu7N7vmv4LL+AAJIpaEPLS/lH5Mg
         Tjqd6HREcF46ns5ONXue0yOEVrD7pqpD1h1ies3eiYzRlRh0au4RqNvdCTCS2OiwXCuY
         TndjILNRSHQPNLLwm6na5Z1H3xh+FGSU1uOmDXOwFqBThe2ttUSz2VwI8i2LvTdipF6p
         hJerLulQjW9mAxxGEIPVLuVR/NyIsuwh+YomgTmiBngABk90UkF/8JMhkRAwdn6nQHoG
         HrhmVZ/QydL+AWfP9TUw+gUdqNTZW4KWXbiLWhGlRfZIrBpeadTv5/mKIOnDH/XHmRa/
         7S1Q==
X-Gm-Message-State: APjAAAXoSNjVYTfwg+nGgGNtme8yxb+HgpbUVKdphNhiTCuL22rtI4hj
        l2vkjeRlInRPzjhvo/vmV09wozqJSvs=
X-Google-Smtp-Source: APXvYqw7lqHGTZ/Hgm2eHFlKzbfZLmRpmoEOP/cJeO/kZZ64V5Gso2jlmm+jCBMaKiG2BEsX52gCLw==
X-Received: by 2002:a63:6981:: with SMTP id e123mr8520931pgc.136.1562909371293;
        Thu, 11 Jul 2019 22:29:31 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id e6sm8850058pfn.71.2019.07.11.22.29.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:30 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 12/43] arm64: cpufeature: Test 'matches' pointer to find the end of the list
Date:   Fri, 12 Jul 2019 10:58:00 +0530
Message-Id: <64c9f2c29cd2e63aecbd233aa96fd9d18e165330.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

