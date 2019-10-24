Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDE3E32EF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502123AbfJXMts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38123 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502111AbfJXMts (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so2487521wmi.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfWULgmJqd8T+PmSRMz5Rp543oTuaEBf6eIosbfBz94=;
        b=oCWnAebNBO44PY2QvXAVts9eL182XPqQaXBRuDpUmoqlO+skeTBW/5CkbW93x39d21
         BTPQ/zgqWoCmoL+CbPmPJTKcYbA7na8r4vyvf4I8lceCO+FEp6IkrdS5T1q0HBRkMA2L
         jQaEcZ9ZVJGkwUdqvQJ6xmIIi30+aeBFwvS6O/nVjXIlBP0/Lb1xgM3Bf6u1PSgp5VSc
         8Js/uJ2V1skjpYHqrSgTKZTTsbplmTDD2w3/pYc7eij6XAeqW7lFWKPckrLU7gDyOouI
         z8H4lK6n38paJOi2EN9tPkX0RRVi9+sna/89hpTj2u+IzaI2lV1HF2cAE8fYm577BsWP
         RcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfWULgmJqd8T+PmSRMz5Rp543oTuaEBf6eIosbfBz94=;
        b=NYjcQHpUi25cgFYc8LHPJadQc5Rlwd7H4Im5vlwO3sJveCcsfH5HU8/CJ7v6689sDg
         3umhacM4iVg4EVs1DpwoBtoy92DKjNxJof0yDWGDkWyTb8ZvbSp3nQzqLcY9JS5U76wD
         C8kaAmv0Esry2a0Ph5LkWK7A2N7HI50FRH4ggOpVhJYjopSO3TeBDIuvtzXPNsGlsyaj
         X05F9XBFwmRqNphQEO5oOJY1Qf/nAsgp7/mkq2RpP+PzC+ooH2w6N3uSQuepvwbNLt/C
         NL2dl7UXJ4CBOo20zGgpFaHlXHutCbICm9rHMjd+tx0t+NWgqwrZ4LZprPnYjJomIk7U
         UBiQ==
X-Gm-Message-State: APjAAAX1DRHjf/mC0yzzX8IiwP/QryIdY9JxZmFnyzo/L+f5MPL+4fzB
        QjYM2hzvITcHRATEztv28MV7I2h+qCEc563J
X-Google-Smtp-Source: APXvYqwaXHqjosLY6M0qC5YV2U+N800x31X6Nnuv5y0x/ZMoFsoYlFKu3nDzhSW/ysIyPLV7m6zggw==
X-Received: by 2002:a05:600c:228b:: with SMTP id 11mr4902465wmf.112.1571921385568;
        Thu, 24 Oct 2019 05:49:45 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Mian Yousaf Kaukab <ykaukab@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 36/48] arm64: Add sysfs vulnerability show for spectre-v1
Date:   Thu, 24 Oct 2019 14:48:21 +0200
Message-Id: <20191024124833.4158-37-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 3891ebccace188af075ce143d8b072b65e90f695 ]

spectre-v1 has been mitigated and the mitigation is always active.
Report this to userspace via sysfs

Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 105741487a86..8b0a141bd01d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -638,3 +638,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 	}
 };
+
+ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+}
-- 
2.20.1

