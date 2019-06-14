Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA6145278
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfFNDM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40821 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so672413pgm.7
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y7D7di+hWLJT4S7T0euG3Tl4lwmsE/s4d/bbuco5Z4Y=;
        b=tn9ttUjCo/EPvIMutHSe21ptFw26CO8lMLTifKPIv38gL7+JQt+HP8TJghUQmKKFpp
         ZpLfHPaBsCa8fyB29TufhWsnLm1JxOkQqGXQjeEfNqHl3WjYf9Hi3tk2zMM/90BPaJCv
         PK4MM1eqbM5VvFktAiQ4S8uIcW3nVE8Sb0TcB9CJLZ+2C9LNRmiSvf4Gcy/TutPKIDJO
         6oRlTUHT+FdhBjMC+pgPt/ZadHh8hc8RVYcm5dPXTdWWLOaiaxFcRx7YhawcoLH7lJEs
         Z1PptH6hyBln/IZcxEGZcPwBuo4jSo3oywpV2aRUTn9Gn40jGiSFEryl9gCr02qIa/Ut
         I4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y7D7di+hWLJT4S7T0euG3Tl4lwmsE/s4d/bbuco5Z4Y=;
        b=pXXI+p3z0HMGKorA/P4d/o6AAYR3+vmDGdNkgnYlY0gtFkLsHM7ZO4eNSmlXKbgjaF
         X/7xRpKQz6J/H6E6wLlHPz//cxBzSKJIAwxMxADK3gTjdN+6TZOsstTSy4ee4+ohu5J4
         gHi0dfxreMukk219Jb8tGnyRx8E2nRPjaiEk4VlN0u4abYTDznfYrhwdUt71osPppckg
         i/1GtDkmBmNxk+pTL+ZUncg3PXkjfPHV/ncX/ndRt+krrfAHaMDol+KOLjK/JLI/wF8R
         +Vkc8ctQkoP2SUpmO38+oheYrhZQPRf9u+bvRpTqW6RlI3QismVOHK0ifRk/gLHOYO5C
         pD6w==
X-Gm-Message-State: APjAAAV47caU2BCdxfV0iLcVQiD1m2XdFBwtZ4qMYrU0JtoCUJCeDwOc
        n4puwOVrCEwTugw1CJsq/TsxSQ==
X-Google-Smtp-Source: APXvYqy1XoUqM5zu1PsPirXi5eV1NLgcorVG8nNQhT9EvyDCcgAzjv4/LVlEZkfFxuFNSqYr80p4Ew==
X-Received: by 2002:a63:140c:: with SMTP id u12mr33588467pgl.378.1560481978109;
        Thu, 13 Jun 2019 20:12:58 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id g5sm1064300pjt.14.2019.06.13.20.12.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:57 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 24/45] arm64: cpu_errata: Allow an erratum to be match for all revisions of a core
Date:   Fri, 14 Jun 2019 08:38:07 +0530
Message-Id: <1b836bac823d576986a9e893e2d2509776ff3565.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 06f1494f837da8997d670a1ba87add7963b08922 upstream.

Some minor erratum may not be fixed in further revisions of a core,
leading to a situation where the workaround needs to be updated each
time an updated core is released.

Introduce a MIDR_ALL_VERSIONS match helper that will work for all
versions of that MIDR, once and for all.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6c5e9e462629..c05135cd53fe 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -124,6 +124,13 @@ static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
 	.midr_range_min = min, \
 	.midr_range_max = max
 
+#define MIDR_ALL_VERSIONS(model) \
+	.def_scope = SCOPE_LOCAL_CPU, \
+	.matches = is_affected_midr_range, \
+	.midr_model = model, \
+	.midr_range_min = 0, \
+	.midr_range_max = (MIDR_VARIANT_MASK | MIDR_REVISION_MASK)
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
-- 
2.21.0.rc0.269.g1a574e7a288b

