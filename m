Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25367125ACA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 06:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfLSF2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 00:28:49 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38241 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSF2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 00:28:48 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so2531853pfc.5;
        Wed, 18 Dec 2019 21:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWOehvqpXv6OawJrlmRDByhBUZ+tWPDIeTBZc/6GCfQ=;
        b=qiLztxrZMsI9XLuisxdv0QIs5ojPlPFLlGH1KBeFxij5Kvfk4r+LDXcJyOGzUBRoVT
         3cuS3GoP+j5+kgQM6jobGYKl3lRufCq+2VL1ovUkBtyT7To001eRSD7hefvVj8oNeeGB
         KlqK/eEl0iFN2yOPedfqa3F/1ADCzfk09o0D5YizkuQGGlRDePgcSDcNDKNSosYqtQp1
         L3vu4zpg2JAZ6XNRoIhdX0Fg41SFkyc2/p/FGGTcPeDDoXzGwxqg0qGGCl67RASYsDdU
         8Z80zMOXxg50eYj5c4jgjkqFS0N/vJoFl019Zyty40mSp33FZrqKO+/+2ewYG8WnxlA8
         B7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWOehvqpXv6OawJrlmRDByhBUZ+tWPDIeTBZc/6GCfQ=;
        b=uPdebBpKAt88SXTa0wlPznQ7LFN5i0cMZXQtZbSLvcDNDcHHXmCYWmYFTY6tOQDJ3G
         1SYDBUVTGowgiXnc23SNYMzt7RjPUnOsEpHXhKr7YkFCTLDjJn0beaS8rO89ZVd8Hrko
         Ics8fsRm+ckGwdSAWQA8MKeSo6dZ1Kbxd7PEJVaQBR06g49ANJ8vzMJ5hTxyj00NILxO
         tfeejyx+gkLj4V6uC3ribFnhAaZ0+Yg5/MjOwf+QscifZKkUv9BRb9HuxrKb9Yi8ePB2
         9BPIsFE93vArD1Smd/XdAw856/BG25L6qcMwoIkLIL6ihP89NxrfVtqp/fa8+YU/nY4q
         r1sw==
X-Gm-Message-State: APjAAAXsIviISXrCcZrX1QF4MHdzgCpjJurvEglWeSVi/TS1qkeXUkpx
        /8MOF2/50ipQrf6eolBDQ2o+eIbgtPU=
X-Google-Smtp-Source: APXvYqzGeo5jRRDBKjCYPgpdsBTeYU9wvWq7UqMVJVQnl/d5yhSP0a36sKDjfd5cEC5gGaYgT9Nquw==
X-Received: by 2002:a63:5950:: with SMTP id j16mr7441814pgm.314.1576733327995;
        Wed, 18 Dec 2019 21:28:47 -0800 (PST)
Received: from vipul.mgc.mentorg.com (nat-sch.mentorg.com. [139.181.36.34])
        by smtp.googlemail.com with ESMTPSA id j22sm4818129pji.16.2019.12.18.21.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 21:28:47 -0800 (PST)
From:   Vipul Kumar <vipulk0511@gmail.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Vipul Kumar <vipulk0511@gmail.com>
Subject: [V2] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
Date:   Thu, 19 Dec 2019 10:58:25 +0530
Message-Id: <20191219052825.4146-1-vipulk0511@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Cc: <stable@vger.kernel.org> # 4.14+
---
- Changes in v2:
- Added linux-stable along with kernel version in CC
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

