Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C18D66641
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfGLFaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44856 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so3990804pgl.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sqSfnQDS8sjUZN/3AxA8S/yruKf46+OQJxAy5E4hEak=;
        b=VyKNs/FIWF1WM+ek3qH+rFuK/9b+IRraNhUiCTZq+VByH2PDsFM+ZzVRunnTcmKPD8
         rcT+7o4Q6LLKSt+hECJSfZsOnVxQksi9+G04j+7c9D+rwj9fSFy9Bpmcxoj9P9beID+B
         mFxmSs4x0uUuTqCK4SLHZYIB1fFHlEs+U0rFQUCAEsnq32OieHmCUChUPgxm3M8moBit
         f4d9vB5rosS/682Fu9nyRtWjXyU4dyNkeXfOzFPFtkpCQfw0HjV3lIgeGX/bsztZaCdB
         WmK7QSt3X2aL1zwLoYlC78RttynyAtWptxxt5zlcSvEcI64wkoyifVkVwoWtjr1lNAQ3
         v6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqSfnQDS8sjUZN/3AxA8S/yruKf46+OQJxAy5E4hEak=;
        b=Xeue+2zT1m39Kzxt3x/jLrzFYoo8LxgOHlQXf8/VdccPalzhmgQQqdhI1b9XdXO5PE
         wK/N0am/kqMnc7mXLdxaZFDDF2AeZ8THi5Mr3RqEyLwqSJ8IKIKV7yp9PyDkuwXbjUpS
         4X9xs7Egg5mm0Nkdimf9TkwhMDPbhwO1N7D2E2L+RAp414D29rQyaWQUkFa4jp9QmQiW
         w0QL59UrpEP7eqhyuvs5KpN6uu5Yw0dzwSHbJhtKIBS+VznJE3TZeyr6Uf2fmqQJboW+
         KiygA8cTAmSdpdYVFcz0Ooy9vT8JmoCUeqgRi9p7mtlr/WI2zxhTYIzmFflf3pxNty8n
         shCQ==
X-Gm-Message-State: APjAAAV+LEG+aTm34NsIrbAQXN5pY+ailQNWAabHrrt78dPYAgzPZu/I
        3fNdSvbHSd2kQTHonK7zlYr/kDktBz4=
X-Google-Smtp-Source: APXvYqwgrbbCxE4dbpRKlJf5JhnfIACbOONUeZFADdEt3q4RlWiQrn0w82b76eeWuOP+qfExkEiz6A==
X-Received: by 2002:a17:90a:4f0e:: with SMTP id p14mr9130229pjh.40.1562909418024;
        Thu, 11 Jul 2019 22:30:18 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id n26sm8177303pfa.83.2019.07.11.22.30.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:17 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 29/43] arm64: cpu_errata: Allow an erratum to be match for all revisions of a core
Date:   Fri, 12 Jul 2019 10:58:17 +0530
Message-Id: <c9df74a24c8cd28416fd0c67e7bcbb0aa116db28.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

