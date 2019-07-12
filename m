Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8C66637
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfGLF34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41578 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfGLF34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so4180534pls.8
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=vcn+efFxVGF43UW996/RLB57/10XNju0qvaz5vdpRO72mRWLognFPo8qNtfpDPW9wZ
         +DUC8+warFb6QT7+oyWClKHjq1x7Wdfo/aWYabcKjOvy9OJC5YSJLHk+Llkcrc7PWLNw
         hEObSZdPSOj+qbesZy64H0GPnYB6dgzZRM2wUTE4OIVBekAlkk0plooX5qMEs3+kRGNP
         9WoLlzDe3UrNFGBGNAdvAzewknxhut+DtRloIv+azJdI5Tv09g+h7znmIT8vJW20Vp58
         lJCGPzQBWY/ou0OEARyGbcmhlPcwvASHjZQ8uArpijAbiTbcBAYX19zR0HC7G4vD6pmU
         s8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUK8ETga6k61l9Q+/z8rY6SIV6XG+DcjRuCd/1NWAIQ=;
        b=UpPa7aPiLGoy3FN1kwNpZvfYqLzpVDTrUKHzU3dL1iBGqalZQdb9pkVleqfQ9nFSDj
         YJDekWh6jsVd93PbgWnNtJToFuYk0kFMEQGjCYQt3HBlj++VKGpE5KkSj4icIxxLBMAz
         SuDsDd4QE8Dn3olAv+HBpAqmA/MrRWM0KUChLBwEu9YrbIeq4ZV3DBFswvvLVjgwdnpT
         NltvJYpq0djB/1s0HJ+mzOVCSDhSjgaBOSSWm5ywfgQodfetnuHHFSDf4RWf7qXfm6yB
         CGPh8fymtBOqz1EK5uHYWXRv80E2ASNHoxmE4urfGig1Kv51vCImMR8G/fhINbsnIqEs
         ExGA==
X-Gm-Message-State: APjAAAWBUvPEyhlxR1Gexj8rMWkvHHyXsFyPd2RLxd3nHlk97lCeS/NU
        o47MMRrN2jTmu2V3Iebeb4CNbN/uDCQ=
X-Google-Smtp-Source: APXvYqyFy4JQLOEnN7RL+n089tjGGTAVoGRatUOhx6aRRb96/JSuBrLDS9AjVFHFT73LqhEQLwtr7Q==
X-Received: by 2002:a17:902:aa95:: with SMTP id d21mr8772502plr.185.1562909395725;
        Thu, 11 Jul 2019 22:29:55 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id f6sm7757419pga.50.2019.07.11.22.29.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:55 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 21/43] drivers/firmware: Expose psci_get_version through psci_ops structure
Date:   Fri, 12 Jul 2019 10:58:09 +0530
Message-Id: <c34816cb2f4ef72596cb59b28f0aa06d79cfb548.1562908075.git.viresh.kumar@linaro.org>
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

