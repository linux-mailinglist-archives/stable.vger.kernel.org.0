Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3875666635
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfGLF3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38025 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so4204055plb.5
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j1PYP8TRl6+XUUI1RLnfOfH8okdoaEeO+GZk5UMu4vo=;
        b=Z1T5KKS7sNDEi/IQxRwePvThY79cxIuM8jVZotuq2NGxiAwXonzL71TrDAJ+NOINcG
         XZEZcoUvnOL6p6bVAsApeEUEJ2SRm48nlUNF/YI+vGkAsgf/11vLcuA0ATE52MAD2Mgq
         WYBorAqWtx07SV7NeE0CJab0OvNwmz+fzL/nv4FSJ5OrVmnjIZt0gr053dkDbju6rj+3
         1hohWEUv3vywAFgyEJO1XbsXgCrOX1fRca34QJzZnsXWb/Kjj0tpzXEPClRemW1sZmuO
         JsFW3P+l/mMUJXBEB+391WuDVUOttFRi05A1CJ0ynJSojO3RMFtfCjL/fqO3zp9hfBrC
         uP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j1PYP8TRl6+XUUI1RLnfOfH8okdoaEeO+GZk5UMu4vo=;
        b=ud94CksOx8avSmqOIUERL70aQCbWfmG7K4I8BQRuDb3Afx+8BLC3m2jHMGXrl3jEdc
         uVMMOqrtVTWk8ZSYLdLAbw4WT2rN6pitO+e4/hZopzh1Wm2F/FFcg39AL4feFnAKN/nN
         fexmo/q9heRQISeB1sQplTdtJgF2ULXM5GmJXidd/PKNK6X1B2qUTGH5WZDw56TOr8Af
         ujWEEIFeYV30pQyJM0Cqs2JBKeVzLy9Q3X+73nf+2Q4dFhDpM23pnXARYdFfkUIn5RME
         +0yf2nffy1XWiN5gw8LB/PVWXJzCEtK2Yvzbji31dhyUBusJ5TryE+EFoGkG55PGBqT1
         TClA==
X-Gm-Message-State: APjAAAWqMg+9Uxqry/Jt5zyhzKEa+pJbNzcbfuD8rzagL3SubHfUSEEq
        psmhRS0pDC6BjQuOXdI0oBluz2oUp5I=
X-Google-Smtp-Source: APXvYqys8vWhmpina70E9EPffNv7bS/Q2ML/2o1J+YDBZzLoEePJaZ+nGpFWn/W9ZeEm8KAc288M4A==
X-Received: by 2002:a17:902:9688:: with SMTP id n8mr8940813plp.227.1562909390040;
        Thu, 11 Jul 2019 22:29:50 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 33sm13037930pgy.22.2019.07.11.22.29.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:49 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 19/43] arm64: Run enable method for errata work arounds on late CPUs
Date:   Fri, 12 Jul 2019 10:58:07 +0530
Message-Id: <3da005579bba7e4b225408b18c6aff7400933bd5.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 55b35d070c2534dfb714b883f3c3ae05d02032da upstream.

When a CPU is brought up after we have finalised the system
wide capabilities (i.e, features and errata), we make sure the
new CPU doesn't need a new errata work around which has not been
detected already. However we don't run enable() method on the new
CPU for the errata work arounds already detected. This could
cause the new CPU running without potential work arounds.
It is upto the "enable()" method to decide if this CPU should
do something about the errata.

Fixes: commit 6a6efbb45b7d95c84 ("arm64: Verify CPU errata work arounds on hotplugged CPU")
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d9f095439011..047f1da59cb1 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -125,15 +125,18 @@ void verify_local_cpu_errata(void)
 {
 	const struct arm64_cpu_capabilities *caps = arm64_errata;
 
-	for (; caps->matches; caps++)
-		if (!cpus_have_cap(caps->capability) &&
-			caps->matches(caps, SCOPE_LOCAL_CPU)) {
+	for (; caps->matches; caps++) {
+		if (cpus_have_cap(caps->capability)) {
+			if (caps->enable)
+				caps->enable((void *)caps);
+		} else if (caps->matches(caps, SCOPE_LOCAL_CPU)) {
 			pr_crit("CPU%d: Requires work around for %s, not detected"
 					" at boot time\n",
 				smp_processor_id(),
 				caps->desc ? : "an erratum");
 			cpu_die_early();
 		}
+	}
 }
 
 void check_local_cpu_errata(void)
-- 
2.21.0.rc0.269.g1a574e7a288b

