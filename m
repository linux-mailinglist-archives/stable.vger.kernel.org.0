Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC72D7D75D
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfHAIVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37954 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfHAIVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so24916788pgu.5
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VcM2nk9n3X98Yf/dvDVr4bULZaEs8I54Pvp1eUOtnUY=;
        b=wgago/zpfmyqQLLQdap7Xa8Uept+x1Qd1u033aMgpN9UcZ2k7xYDBKbb5+pAmTYGgD
         xC0edVXG08xxx5WF8v25YYSNhl7HmBj9YBcqUxBZKs17aXRlpwxG6PgS2mETq4g6D47P
         b/+wh1/eVUzBRinby/9SHWDbNCMO7HEhhQvRfOihSoqAuNP2z00/tm9PPpJqXaBngIua
         gUXFe57xxGWupNlan4xHj5ulZWnqY6FKmEJ00v+KbEbiHhP+rvhpjyEX1zjTqlJE75EW
         Iiyc2AY4u/qxd3536giEWMQrGCiPYXOZ0VVJbuqFv1J1Ws1noO/dSsWJolYOORmclwWU
         rPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VcM2nk9n3X98Yf/dvDVr4bULZaEs8I54Pvp1eUOtnUY=;
        b=VghF6NOH1GZdwfl77rm9tEgOBTieHUIB8ikTrcQ1mViMxEuafDntn+481g2AXOWhEf
         Ov4hdMAgdeTBxdyhw7Nq6gt8ajPVINhjUZcMIY/qoze4VfmARfmOhLM5PqSeZ3EY2Z3S
         bz7SZAgqArLvRvbyccp5UmMirUOhXTE3u4AZaEZ6AflG8HR98J1P24G2bFR8eb7XS+Q+
         ZMNRjq0FZ9FsXPMXn8Hf0sy9cWtSbDgk0eqoOgFoFZp6VL0LtAIggsKleNIG84E7Sxrg
         MNCj7A/MCxsFQjimdLoDIo5q7ihKOgqGrZc6i6K4PXZEMM6NoZyp6YGOkNjw/F0nRttg
         xjUA==
X-Gm-Message-State: APjAAAUp/nJnI6ohfMjbgku2p+o2noDsj8BWazLr9fZDbsMXXVOrqmcH
        TkEeQ5b3qBp8bKtZdcM8tsuG9qrUdHE=
X-Google-Smtp-Source: APXvYqz0smOXC/yRZCeLsmsqR+rYdReSDcJ5waTey1emtkemTksgldVG2ZffWaFMsTKpL11UnFLb9g==
X-Received: by 2002:a17:90a:8a91:: with SMTP id x17mr7257741pjn.95.1564647694091;
        Thu, 01 Aug 2019 01:21:34 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id p19sm80677529pfn.99.2019.08.01.01.21.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:33 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 46/47] ARM: ensure that processor vtables is not lost after boot
Date:   Thu,  1 Aug 2019 13:46:30 +0530
Message-Id: <1292f4e03c65f4cfa4665df9c0e6f7fb8bd526cc.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 3a4d0c2172bcf15b7a3d9d498b2b355f9864286b upstream.

Marek Szyprowski reported problems with CPU hotplug in current kernels.
This was tracked down to the processor vtables being located in an
init section, and therefore discarded after kernel boot, despite being
required after boot to properly initialise the non-boot CPUs.

Arrange for these tables to end up in .rodata when required.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: 383fb3ee8024 ("ARM: spectre-v2: per-CPU vtables to work around big.Little systems")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/proc-macros.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 212147c78f4b..d36a283b4099 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -259,6 +259,13 @@
 	.endm
 
 .macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0, bugs=0
+/*
+ * If we are building for big.Little with branch predictor hardening,
+ * we need the processor function tables to remain available after boot.
+ */
+#if 1 // defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+	.section ".rodata"
+#endif
 	.type	\name\()_processor_functions, #object
 	.align 2
 ENTRY(\name\()_processor_functions)
@@ -294,6 +301,9 @@ ENTRY(\name\()_processor_functions)
 	.endif
 
 	.size	\name\()_processor_functions, . - \name\()_processor_functions
+#if 1 // defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+	.previous
+#endif
 .endm
 
 .macro define_cache_functions name:req
-- 
2.21.0.rc0.269.g1a574e7a288b

