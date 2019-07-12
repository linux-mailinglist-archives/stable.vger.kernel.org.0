Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEF066636
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfGLF3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34657 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so3800253pfo.1
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+Gdnz2jFF65J3PIUhAk0AHlnEqUM/+ROCtumKJNSeI=;
        b=O28H3hJbcm//HM+U/MWBuTNk2PRepOPX88YnoORFVdxZm09Mikdw3xD5PNVZAZcyJe
         SbkalfujGuflSOEKDuz9pC45lyZQhzbUFb7eZBEv5TnP6mQk8SvYOnFZ0TAHg6XgjTO1
         M4vVkB+MqXqFKCP5J1/py2/4yb93120qicinbyThs1y/CAvkwHcoXZ4UWNASDaZYbr/o
         KYF1Zg1rmYn7w1Sp2W48nAkF5hIm0uUEOTg57A/O2D8Nr6d+6wXJNmGb5uKfNpzD01Ii
         iBwFDSQSY7S7s5vf8Mcz0jnUo5cUdJL1ne7hbWENSdlHLL+vqy0eyBtxP15jn46Jl6RI
         A0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+Gdnz2jFF65J3PIUhAk0AHlnEqUM/+ROCtumKJNSeI=;
        b=dWLjpMmproeZeoqW+SLuWLZZHkHju0/3SY9dkCpXhTMLEY2u1h27QlZXzwvMDk0Uwt
         5/FAgkhxs+VP1PxfWuELSxPWef8LT2SdXgPIO0I4BjO78kqjV++3gVMdpUNPcOCKcFID
         hQbvUlyN7br5S4Imnkv7qRZpJlyp2DuCsUu95Nu2N8K2ggnRb1QcYAfRg9HfiYNJGTN7
         Xx7u3LjCP372IURTKd75DBlw1exS10YDFhAWMIl2UVyeZEpSjOtbJtcVsB58HelvpmAJ
         eddm/I7oK9WQwRhjddfFEirD3ihAnI4VC3Boq+MKI6bRZ/2AJLoHPvwR/KFdBDTzOsX+
         Q7UQ==
X-Gm-Message-State: APjAAAXXFqBsJJgR2+DZBAX3ol6PAVBwiLRSf3sqn8Lhs1o9aYPNfvjO
        /w0vwhDtJoyC46A84LYKVWkn0VTE/GI=
X-Google-Smtp-Source: APXvYqySDIdYWy9WVN9dq7htvm9SEf0NK8A2MgefQ4Dnsk3qNx5H8fF5U/DWEkK+xekUp77hGNQSSA==
X-Received: by 2002:a17:90a:fe5:: with SMTP id 92mr9537112pjz.35.1562909392738;
        Thu, 11 Jul 2019 22:29:52 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id p20sm11193369pgj.47.2019.07.11.22.29.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:52 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 20/43] arm64: cpufeature: Pass capability structure to ->enable callback
Date:   Fri, 12 Jul 2019 10:58:08 +0530
Message-Id: <a0fc0ca67b4069d37addb44fc7aabe3f4f7d53e5.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

