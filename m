Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33B57D718
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbfHAITr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34840 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbfHAITq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so33622544pfn.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=Y4Z6CBElGedbCLchp/1U5zm7RwIzsZW7sSPLelgGoB0UAR3fmAUIaWPRqbBzItY+SU
         dFonmxxfBMwagZLJREXeHezpHMh1Y3Qa90lYmEqpzmwy29/QR4lMPJUVtQqcTlzsoblx
         YvUQeTrTR+Rrgn6wBdIS/56xvJGBvX6qMt3nWeY6Yf+7kSNhghxr4XIm9GLXOVwOTBSx
         bMwSdkvjuTyiv2KCbxqdBmearRidRn1z3nSssV2qaK3kQU+stZQ6DIV2/gHkdIaGZ1iJ
         d0MueB6aYPyB3wiVuCenso27YAaY7cBchl80Fj6Qc729nXHTSmJRi2P+ieiXaWhAkbNl
         +6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=ivYpt2KSJt+PFy7V+UySdUHssiqT6tTwi+Ur3mKAwml+fKCKLECj0tX4kle7xeUMN8
         LIlNJjJLpKxvMGKFiVP0RncApXx8wnqwlh+XBiKqtuPwGRKKP9hcRzFHSBT2upxC5jKU
         Ym7VZaeOlHN2F07wfWl9r64yvX6SKnfp/bszikfeK5gzGzAFyiIPKZXW/+GUUOrK11Lo
         6siMPdHFyHKe6dBlEtTGr9g6Z2EDCLVNJutCWcQPvpelNZ4k1KN0MwF0o7OwRkqX2eyb
         6Lmvdtl3La/TzdjdULpp/h97soYKKCNRP2JlIK6HhHTw39OGALiDUJot0Z2R6CUUYIyT
         6FDg==
X-Gm-Message-State: APjAAAWtaTWMNLFi911j7zg6PxS2gr91yr99ygPIGr8un9AF0qIbvbvt
        nJi6qTCXxU1VhV50oPNgzOOuq39D1wY=
X-Google-Smtp-Source: APXvYqwBGdeJip4Cl0RM0Gp+T+ODw9bU7Zw9CWW60KiajPbXAE1SchPFqPiYgxpHdrwW0IJ2FkUxCQ==
X-Received: by 2002:a63:d34c:: with SMTP id u12mr103456545pgi.114.1564647585962;
        Thu, 01 Aug 2019 01:19:45 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id y23sm72885680pfo.106.2019.08.01.01.19.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:45 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 04/47] drivers/firmware: Expose psci_get_version through psci_ops structure
Date:   Thu,  1 Aug 2019 13:45:48 +0530
Message-Id: <64c1d3d45f10e811674aad1f583b346fcf3a8707.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit d68e3ba5303f7e1099f51fdcd155f5263da8569b upstream.

Entry into recent versions of ARM Trusted Firmware will invalidate the CPU
branch predictor state in order to protect against aliasing attacks.

This patch exposes the PSCI "VERSION" function via psci_ops, so that it
can be invoked outside of the PSCI driver where necessary.

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/firmware/psci.c | 2 ++
 include/linux/psci.h    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
index ae70d2485ca1..290f8982e7b3 100644
--- a/drivers/firmware/psci.c
+++ b/drivers/firmware/psci.c
@@ -305,6 +305,8 @@ static void __init psci_init_migrate(void)
 static void __init psci_0_2_set_functions(void)
 {
 	pr_info("Using standard PSCI v0.2 function IDs\n");
+	psci_ops.get_version = psci_get_version;
+
 	psci_function_id[PSCI_FN_CPU_SUSPEND] =
 					PSCI_FN_NATIVE(0_2, CPU_SUSPEND);
 	psci_ops.cpu_suspend = psci_cpu_suspend;
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 12c4865457ad..04b4d92c7791 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -25,6 +25,7 @@ bool psci_power_state_loses_context(u32 state);
 bool psci_power_state_is_valid(u32 state);
 
 struct psci_operations {
+	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
 	int (*cpu_off)(u32 state);
 	int (*cpu_on)(unsigned long cpuid, unsigned long entry_point);
-- 
2.21.0.rc0.269.g1a574e7a288b

