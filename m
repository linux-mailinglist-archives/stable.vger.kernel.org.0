Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0514526D
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFNDMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41526 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id s24so372145plr.8
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=G2wmSB0wl3ZSst3wBKM0lmkGVB3EAHRbdwUzF55iA5Zc7PyVUPSzOlglM3cYPWwRdH
         kG5s+Oc45ZUBoFc7mYCpXBsXAu5XGmy/7ktcJKN5fvs5gGGo+RUG59zBtu0U0c7OD1G5
         rCdw3QRLYuHQN2CR2z5SNEW280SeN+8hmo3JnWq17WmQ0XAbAnBQB+8kSzeiv2GOos6N
         i3DZfvNnVkzqtXL9ayx0CfRlKWcSGFcOx2QhOmHPWcoJi1efyzQBp+8/rbWneAGyAo7p
         6b75570FcqLite+nlTb86LYO3NmyJ9+l6P9/g2w84R7+Ws1R4y+j1181T/YYXzDR4xsa
         qF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=rFT4DWeanzrXN6Ghm8M0Y4Ne7Lw35GQxAVDj5ZqeqC5QlMSBi0Un+k30Pt8Cai/LMv
         XjAbOm63q0ruZ34vtm4hWqDl7Mfbs6WPYtXt39jMFB5bT9JT/mXlnWKfszUlUQoQjXif
         2sLng9nRRnMMzbO3/OUzsopi35+sH44HQ83hnC9+CPBN2+HdDdhXavPpAKUalBonVhYX
         JhCG0Bc3PTNqVIcDPpMGAAwBlWlUOOcnw1gYdFyt77BZwGU5R+hbQlkhbY7PTqedxQ11
         XonOhV+h00A2XjzPDmB2A193eR4XekrgIh0ykaxH1UAx7efwtmOHbJC/SIXpb0UtATrA
         uBNw==
X-Gm-Message-State: APjAAAUVFiHnTvjGKjGWPSau1J7rT4+OWWuWcBh29kyAf2lYZbAfB+bA
        EgJi19+rAvmxoqUe/qjl/faqRA==
X-Google-Smtp-Source: APXvYqy0h/l06dEAqb68tyJjmoqTO4IsmomXMrOr3ePgip3/iFchSjUdjaq0IfSo5o/2v8S6XIqJCw==
X-Received: by 2002:a17:902:522:: with SMTP id 31mr86143113plf.296.1560481951066;
        Thu, 13 Jun 2019 20:12:31 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id p68sm1036348pfb.80.2019.06.13.20.12.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:30 -0700 (PDT)
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
Subject: [PATCH v4.4 14/45] drivers/firmware: Expose psci_get_version through psci_ops structure
Date:   Fri, 14 Jun 2019 08:37:57 +0530
Message-Id: <5f5b6ed2828ebd885fa4bc8e764483d81f419bc5.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

