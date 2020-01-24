Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B1F148F17
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 21:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391906AbgAXUIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 15:08:32 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34865 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391798AbgAXUIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 15:08:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so1637942pfo.2;
        Fri, 24 Jan 2020 12:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6ErqDnPmvotTKNe1KfqwWHr2o3aJpwAhGPt+q+2RIGY=;
        b=j5++EJNQx/pjiInQRmR1C7PmvfNsiq2RQhNl8BaqnCPdx4a+wAFMN8wLG7w7bb9Vnz
         ZjnuJhqdGlB3TU/IZ6LRpAEbanmwIjkvON4qMIlxY93ay8RMdS3SXC+K9crIPyTc48x0
         FHfk9xbI4rm9ZXqkp0/u7iGDyQvdrP/8MIbqWJ64ClmYb59cFFjuaIrKEcr2y7EDw4S2
         V8m9by4tOdeJsC8pq+oNl/2B5FmbXTl+1zkjRpofaN7M1dVBK0T9k+jDy5hOKqAP6EPi
         74O34mVEfi2AW+bEPmenVuKYw+KeHQkbVbqHMcIxi/rqLDdtQ2va5N/4NG7PIGcyNuNJ
         q7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6ErqDnPmvotTKNe1KfqwWHr2o3aJpwAhGPt+q+2RIGY=;
        b=IenKAAmV6BA+dWWaCOUxG4xUbXK/bYxAZTHV/G7uR0NfqkaUTPpFiRDiPemX1gaiPv
         HjUd1sSUmopfexiAhZJkiDkka9RnqtzsNRXcdt84DdM4RKtw5jkkxQ6LaV5dF3MpI9zY
         oyXyuHWJIv3H6AdCLQ8+MXOMxskzlFSmylbaRifYrk/j+4iMDFZR95JrJNXQTUUFd3Oq
         7c3OsnYmTazOGLxqVE7SZxGF+Cwp0wkNlK1EvzcvpBjJtPq3XGAJh3So4QsFUpjS8Jyg
         P5fsudNglUNxRhbApcDzMFTzxSojTL/FpNmkEnwC/oukqtlBvw+QgztJlBf+aqp2hsP9
         W68w==
X-Gm-Message-State: APjAAAWauwOYL3Y7JjarMH7U1c9BZ+IL3HIDIgEqpGW0EkfwvCg/uxsU
        VwZYonbNa1xyJwtpYEhlYis=
X-Google-Smtp-Source: APXvYqyDX71JE8oPFq73PkIkrg9qSc6xt8FGKqhatmzDASLi9r0401eu++SsDf608mt+iTH/hcz4gg==
X-Received: by 2002:a63:5a23:: with SMTP id o35mr5912160pgb.4.1579896511412;
        Fri, 24 Jan 2020 12:08:31 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j38sm7363809pgj.27.2020.01.24.12.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 12:08:29 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, sashal@kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable 4.9] arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field
Date:   Fri, 24 Jan 2020 12:08:20 -0800
Message-Id: <20200124200820.18272-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 2a355ec25729053bb9a1a89b6c1d1cdd6c3b3fb1 upstream.

While the CSV3 field of the ID_AA64_PFR0 CPU ID register can be checked
to see if a CPU is susceptible to Meltdown and therefore requires kpti
to be enabled, existing CPUs do not implement this field.

We therefore whitelist all unaffected Cortex-A CPUs that do not implement
the CSV3 field.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[florian: adjust whilelist location and table to stable-4.9.y]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/cpufeature.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a8e45dc36bd..8cf001baee21 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -789,6 +789,11 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	switch (read_cpuid_id() & MIDR_CPU_MODEL_MASK) {
 	case MIDR_CAVIUM_THUNDERX2:
 	case MIDR_BRCM_VULCAN:
+	case MIDR_CORTEX_A53:
+	case MIDR_CORTEX_A55:
+	case MIDR_CORTEX_A57:
+	case MIDR_CORTEX_A72:
+	case MIDR_CORTEX_A73:
 		return false;
 	}
 
-- 
2.17.1

