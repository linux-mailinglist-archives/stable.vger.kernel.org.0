Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C332124BBD
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 16:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfLRPbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 10:31:09 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36743 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfLRPbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 10:31:09 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so388348plm.3;
        Wed, 18 Dec 2019 07:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y1KOP5OdhQQyB92O19ghP7GuEEOHhGyvDRkY0vdHulg=;
        b=QAZz+nnYo72dbTCkCYKr5WIrsUo2K+fi/czRJIuuWn4sHAe4/7jxOWuWLK6Vj59ElA
         Bbop+G46vyQA65gHtBQ/rH8svkHVJCVdAXYrTKHoQhsPt2eOKJhDZ0Zc+idnCn0+AM/F
         +kKDfboSZVJQI9IFr5KRLnVQy8/hc7SfCb3+wIKBFeWHbrD91dTACIRXmF020DvansIm
         K/xV+hmfaXij6SW1KQNuWeFBf7qpHZspmjqyLZCqvIME32Uf8SAcgGu48yKfZWfRoBVF
         T7eIz+xK6VA7mr5vRLQMm/Aw7gSvbYTQh8SBJo09AbPMhWdVW2lUjeB493Kdz8ErfAMg
         gubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y1KOP5OdhQQyB92O19ghP7GuEEOHhGyvDRkY0vdHulg=;
        b=Ub0ViT48k/4v9rYQWaYhDYeOHgQK78shgWBPdXSDOL8Mcq9E5PACD9+B2xhlw4fkIc
         riUnv/uGzokVZJSlVrk1PXO7C0f+G7Fr7Yj7OSDJUDI9F90zm54PkdcvsA932JKCB3v9
         gkzureM+XgW5vJlNe9PmEjgLsrNNH9cPYxlg741iAm2wd9ecbLT7vlOInppU/sZtJxtl
         dRs3+Xaedg9JG6o1Dzh0q3apLZX9mvgA+n0RGwitTA6fTUvNybeGMXFFr9eGlrgeiQ9s
         NRmaa/PX7lhG8kwPUD2RX802wKDku1ANVAs6JQDdIEFZ1EIdITg5HoRMfdWVeY/quOMB
         nyug==
X-Gm-Message-State: APjAAAW5LxvRY1QI0ghIHPHUEn3fDl3IV36l4CcDvksBE2UEdG9Z7eHc
        px4FSEMJbykzfjk5UciliF/2fnPHMew=
X-Google-Smtp-Source: APXvYqx+xl9RXuXsfmgBpWu8fE6Hhzu1qaJGCb9BuOaMuG6F3yvwAyGBOYMX+O8vtkjgeZhvgfjsWA==
X-Received: by 2002:a17:90a:e28e:: with SMTP id d14mr3659378pjz.56.1576683068374;
        Wed, 18 Dec 2019 07:31:08 -0800 (PST)
Received: from localhost.localdomain ([27.59.35.166])
        by smtp.googlemail.com with ESMTPSA id j125sm3741982pfg.160.2019.12.18.07.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 07:31:07 -0800 (PST)
From:   Vipul Kumar <vipulk0511@gmail.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     <linux-kernel@vger.kernel.org>, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: [PATCH] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
Date:   Wed, 18 Dec 2019 21:00:39 +0530
Message-Id: <1576683039-5311-1-git-send-email-vipulk0511@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vipul Kumar <vipul_kumar@mentor.com>

'commit f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE
flags on Intel Atom SoCs")', causing time drift for Bay trail SoC.
These flags are set for SoCs having cpuid_level 0x15 or more.
Bay trail is having cpuid_level 0xb.

So, unset both flags to make sure the clocksource calibration can
be done.

Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
---
 arch/x86/kernel/tsc_msr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index e0cbe4f2af49..1ca27c28db98 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -112,6 +112,9 @@ unsigned long cpu_khz_from_msr(void)
 	lapic_timer_period = (freq * 1000) / HZ;
 #endif
 
+	if (boot_cpu_data.cpuid_level < 0x15)
+		return res;
+
 	/*
 	 * TSC frequency determined by MSR is always considered "known"
 	 * because it is reported by HW.
-- 
2.20.1

