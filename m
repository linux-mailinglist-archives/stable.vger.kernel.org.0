Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28825A18CF
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfH2Lfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45052 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfH2Lfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id c81so1851385pfc.11
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+Gdnz2jFF65J3PIUhAk0AHlnEqUM/+ROCtumKJNSeI=;
        b=Oe6Dz4153ltyD3BOVv2Y24vo+UtKfPsfPZvYFyr5fhxeB35Rbu8aymhVcDzOji8XSu
         7JIvGaxHIMY4EXvUznwSkztpEswYQ2WD/XqHg1Z9aye/Mt6Oh9a2vy5UrkWv5t457CgF
         x8b0CUqFARciHqOI3I/UFAchPFXRplP3lCdMz8/SNk2EDLelih/T0i3/ZyofTZ1L/mkS
         evSDeJfPr8ec36CGg7Y/rNsY9VDOg2HDzsEsbnbgzULvX+nyus4K/F8jQ8hQb9HZD37y
         Bp1I/ewwTABB/GzOgP/4hzZ7fVlk0mOQ166/7eWgZoKkdFSJW3x1qiyKtFaS4qmO2qKU
         C/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+Gdnz2jFF65J3PIUhAk0AHlnEqUM/+ROCtumKJNSeI=;
        b=WxyBYvcOjEcXsDqgLIxRFH5ZBLN2hgOG+TjlHlIDwAp+09ze/IBm9Osh2HOfBeqQZJ
         xs4m0z+4myDOvuXrLxv4Wtli2767rfeASjxn64ncPwxv6NOeSX4aKPFjENjWWsPmiuRW
         vTKiiMXDQ3sBljdmsujKYCCtTDYia76T0zaA0OJxoYIt6aY0kqd62Ibwnlw2AjeeZ3SX
         G5N2SdX2wUHSuw6TExk0G9gEYygA8I/5CKYJTgoLmK7JFuRFpRzf2cPbey/5xPP5n9j3
         B4WWIVp2Dm8MmGm76TohxctAEmZO8tIZssdb1InVqvKd4uKRUjUZwA9/4knVETnbTPC1
         NPYg==
X-Gm-Message-State: APjAAAVb9AeV1YCocK0C0q78oJ+s77E7vI+WnXV4TvkWuO6eBmKW0Rn5
        Uol8Fp7jgYciQrgSTysvMkkAPlAKSXk=
X-Google-Smtp-Source: APXvYqzdg9Ft56ac/COsE0vS4n0KUA7PrXu5NfXzsUUdMGAYAbcwFRDp/NY2ss27Ut2nNF+0Zr0Egg==
X-Received: by 2002:a62:f245:: with SMTP id y5mr10845178pfl.156.1567078548910;
        Thu, 29 Aug 2019 04:35:48 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id z24sm3727353pfr.51.2019.08.29.04.35.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:48 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 21/44] arm64: cpufeature: Pass capability structure to ->enable callback
Date:   Thu, 29 Aug 2019 17:04:06 +0530
Message-Id: <fa88efee3142609dedecc00a58e31bc8583d49b9.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 0a0d111d40fd1dc588cc590fab6b55d86ddc71d3 upstream.

In order to invoke the CPU capability ->matches callback from the ->enable
callback for applying local-CPU workarounds, we need a handle on the
capability structure.

This patch passes a pointer to the capability structure to the ->enable
callback.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Use &caps[i] instead as caps isn't incremented ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c74df3ca000e..474b34243521 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -832,7 +832,7 @@ void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 			 * uses an IPI, giving us a PSTATE that disappears when
 			 * we return.
 			 */
-			stop_machine(caps[i].enable, NULL, cpu_online_mask);
+			stop_machine(caps[i].enable, (void *)&caps[i], cpu_online_mask);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -881,7 +881,7 @@ static void verify_local_cpu_capabilities(void)
 			cpu_die_early();
 		}
 		if (caps[i].enable)
-			caps[i].enable(NULL);
+			caps[i].enable((void *)&caps[i]);
 	}
 
 	for (i = 0, caps = arm64_hwcaps; caps[i].matches; i++) {
-- 
2.21.0.rc0.269.g1a574e7a288b

