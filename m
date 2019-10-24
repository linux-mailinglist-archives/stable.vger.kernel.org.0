Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F8DE32D5
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfJXMtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46705 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbfJXMtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id n15so15144140wrw.13
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHLOvPlG3n0zrZ1s6GpObuHrC2FtNjmc/6afOucoSvg=;
        b=YKCyO53lOOE6KHgouNsNJx8P9etdM3UBW3lOKk+36GW9Uzy57S5QOkoUOYRjmx2Ere
         QkO6xm3XLwOc/ZTYkiZvKJD77M8Qq0J4sRhaQGBXqBiodG8Rmyl1zvaUE+5KchdQ1am8
         Y2jxwIJWe10qOxdQwpnxDgEXKwJPyAdoXTRN0i+bLSUGnNiomxZ5SvniOQea3OTlD43S
         p4xb4xmzCWHVEk4yXtxm9xVSB76f3Xurfq2OdHIUmvQF7KdING6Fi1YiKW/6+WEtCjvE
         eQBz0Y1jNfnYMfx3dGRFxXMxkz8Df4LrQZ31ASUPOyITD5Fk7Z3JGAHIXFbrCUqsVPMz
         pKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHLOvPlG3n0zrZ1s6GpObuHrC2FtNjmc/6afOucoSvg=;
        b=nMvm3eaq2ywC9gXp/FDjWY8wtLehVOu9Rj9UPX3wPUrpJO5zxHXk2qB7cusIn410xA
         akxwJX1NgXhf7Mas9x6XZw8NBEBPToYWfGB9Ud8c/zF7+52N3mUTJg5QWvOGec382e6o
         yxOkcxhxT3gp4jGYTu0saO4qHmMleknhlgxYpZktAa0jVSoRC1/Y4uPZUOww1m2AT+V6
         dBCOlyKDXWeyoAIgi77s4Hgsd04wWKLIS7qHfR1IeIBKbcVulKPzFvTAwLv7M80kfwVT
         FUfXWwmxdIqac8UrdYoFvjtc8LKzS0HpvwPvGTL9st+S4Wp0BHo6SwgRItojcgKBS5oy
         rbew==
X-Gm-Message-State: APjAAAUg8cAOnMJdoKyXdeRtW+iTVHo8SJB0xIELRBpS/MoouV0tSy0S
        QdRioJRRFqacM0hRtTzlhLQYiZ7VdG6xwdyP
X-Google-Smtp-Source: APXvYqyXdOLco3hqSCXqV8JpSDVkPWmRXrcFXQGaHFHOU5Gzbc19w6zxaN9r3v0Lx492vE1Yf/1KqQ==
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr3556438wrv.168.1571921344572;
        Thu, 24 Oct 2019 05:49:04 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:03 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 11/48] arm64: capabilities: Move errata work around check on boot CPU
Date:   Thu, 24 Oct 2019 14:47:56 +0200
Message-Id: <20191024124833.4158-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5e91107b06811f0ca147cebbedce53626c9c4443 ]

We trigger CPU errata work around check on the boot CPU from
smp_prepare_boot_cpu() to make sure that we run the checks only
after the CPU feature infrastructure is initialised. While this
is correct, we can also do this from init_cpu_features() which
initilises the infrastructure, and is called only on the
Boot CPU. This helps to consolidate the CPU capability handling
to cpufeature.c. No functional changes.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 5 +++++
 arch/arm64/kernel/smp.c        | 6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 17aa34d70771..1269d496db0a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -521,6 +521,11 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_MVFR2_EL1, info->reg_mvfr2);
 	}
 
+	/*
+	 * Run the errata work around checks on the boot CPU, once we have
+	 * initialised the cpu feature infrastructure.
+	 */
+	update_cpu_errata_workarounds();
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index b7ad41d7b6ee..e9b8395e24a7 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -449,12 +449,6 @@ void __init smp_prepare_boot_cpu(void)
 	jump_label_init();
 	cpuinfo_store_boot_cpu();
 	save_boot_cpu_run_el();
-	/*
-	 * Run the errata work around checks on the boot CPU, once we have
-	 * initialised the cpu feature infrastructure from
-	 * cpuinfo_store_boot_cpu() above.
-	 */
-	update_cpu_errata_workarounds();
 }
 
 static u64 __init of_get_cpu_mpidr(struct device_node *dn)
-- 
2.20.1

