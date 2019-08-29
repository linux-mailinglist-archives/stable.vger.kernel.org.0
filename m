Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C3DA18DB
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfH2LgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34944 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfH2LgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so1458889plb.2
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sqSfnQDS8sjUZN/3AxA8S/yruKf46+OQJxAy5E4hEak=;
        b=mcZvlnlTjxDEMpsXVxgZHCis3EpF9YKEnl0Ae7vuyVNS2u5DsBmOpKu/RfyQY4zst4
         WJ6II+4t9IB2/P5txc1C3I3Np7nADPSzcXWHbYbRQ5mjaMV/Q70uDa1eXdwLx4L/H1LE
         h2/Z87csKjZVXK2Jk3u43fy7aoYHA+l58kS+mcD5zTVL2tNNGwHuC6GbGWrQVIQ90jvt
         aa+QaAM01GJcJeenk3D8K0YFFYwl1QQfsaBPmiHcBmnF9TfXbkRBjff1fVlefRtMNNhn
         YS1V3p06jYuC6sbH3f2RCtKxaMrWYTkXD2GmUCqwfUvFV0t0KJruEDE5MJpqDswVGQ9H
         m6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqSfnQDS8sjUZN/3AxA8S/yruKf46+OQJxAy5E4hEak=;
        b=iWxF2D4NyzIAZ2rmflDNYmZ2uXwhkcsTj9CtrYy6x8hWMtG+C/KgynsN1hTtEb+Lui
         G3Uct2QbwPD4+brWaD7rTgxX9lB/DSzP6aCEO9BHV1J54eYu8LJTjPTJefi+EcswctkB
         o64uBhCHWzg/JrgpTg81vxKrY2Sll+CTLM7UVpKWAHIbaEH5wsaI/kw9JZC+2kFkK9pG
         CjWxtUBDbrwoE8pan83Cy9Q0Y0ZOTkWORHtE3IQcAAxkN9JB2mhMfqcCT4lNuIiHFflH
         FoeR6M+lUzq2FuXSo1Is1gTjg1LaajrNtl3TlYQZx77nsMOVA+TiDJMZwePw3fAvOIFH
         4vYw==
X-Gm-Message-State: APjAAAUUoxUN3AX4tVFD8qmKhB3JNEenBUwJX/j4qsZzoc96UbFhW3C5
        otroOn5uQJMOnL5Rtq5iQEMbvHJZO4Y=
X-Google-Smtp-Source: APXvYqwCZXwu5vcPONS2qYEkV8H5ecBbe1iXOPdH6sQcBoJVFBV1yyeMBHa6eVLnnhTfZHNhRs6fDA==
X-Received: by 2002:a17:902:74c7:: with SMTP id f7mr5308584plt.263.1567078572662;
        Thu, 29 Aug 2019 04:36:12 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e66sm6401987pfe.142.2019.08.29.04.36.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:12 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 30/44] arm64: cpu_errata: Allow an erratum to be match for all revisions of a core
Date:   Thu, 29 Aug 2019 17:04:15 +0530
Message-Id: <edab29d004dba9603b3e594cd4e8d2cf5141107f.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
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
index 19c51d1cd302..80765feae955 100644
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

