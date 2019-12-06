Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70692115130
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfLFNkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:40:22 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36752 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLFNkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 08:40:22 -0500
Received: by mail-pl1-f195.google.com with SMTP id k20so2753764pls.3
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 05:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=+qvH1fKU8akn1ivEXkhuxWeGCb/14Jyn5pqpcY23k+E=;
        b=t5YCNjFcE5HcAgGix/qVZBF6Ke1Nb8W7PzEJelZ4k4xJ+ATO26iRJS3uUm2xR0mU7Z
         f63e5vs8/4Gi3QyBAjOIQQgTwoQ14t5+aLsZGm74boIHJYhj+KjdE2oEsfF9YfMqp3dH
         bg/el71wjLupxumyMJ4v9V6O+McXq7EqxbPSSSIFDMfhxBNm2Fxu6T6rlmdFv4wT1snP
         I4NfcsH8QpKKQdC1nTCU8N43UTV5yb7xlP8exlRZHyFegjaca3Zl65FElkb9C3442iRI
         GDg+Xwh7cy+RAQc7bxiy1TH/osWsiNcnBmn2g+xR2GjVDKncqQzhy5WYYUKgEUY/dn4/
         6eCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=+qvH1fKU8akn1ivEXkhuxWeGCb/14Jyn5pqpcY23k+E=;
        b=oiNq2aZORdNeMLesVi7g03/y1/sN6CTHIrq5haI7FaKyGDbV0MKDy2N5yWCg8vuXGH
         5LhNpDL71JiwKHiL26Awoiwd0BUtR468xFev4iTsbFCdaKD/Hb+QxxPkgrPYH65vowdA
         QNX/mnoNTrqsvlHX8Ny6lSUPzNVQw126K/muB/JOg37IR+t+nWJ3+NAp9kx9MNujGw2C
         hRbq7EvqkHEOxczjCR7R9FgiVRY8tvWVyMxwJIR7otSRYv8Q7mZkNUwctUj/U4Z8SdR8
         6Xplu3NtX88t4cBtNMC5s5NG7o3mJ+4Bv6Y1Gyq1g2avXe8c9wzXKjpFOp/OuNRIORYQ
         q9Sw==
X-Gm-Message-State: APjAAAXmzCMsDiBGTNH9BZxkv2+dB7VqRpBz7RQznrWtyhh856a41IV+
        sVwErW/fhJKOSdo2Zv+YAdM=
X-Google-Smtp-Source: APXvYqwTcwrxFl9JWfaApbGq1OpeahhOMamVMMRvwesgAS9Qac08lW8+lcyi9LxoqrdOonIku2dwBQ==
X-Received: by 2002:a17:902:542:: with SMTP id 60mr14338480plf.207.1575639621748;
        Fri, 06 Dec 2019 05:40:21 -0800 (PST)
Received: from joy.test (107-204-215-49.lightspeed.sntcca.sbcglobal.net. [107.204.215.49])
        by smtp.gmail.com with ESMTPSA id d7sm17661554pfc.180.2019.12.06.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 05:40:21 -0800 (PST)
Date:   Fri, 6 Dec 2019 05:40:10 -0800 (PST)
From:   Richard Narron <comet.berkeley@gmail.com>
X-X-Sender: comet.berkeley@joy.test
To:     jbeulich@suse.com, tglx@linutronix.de
cc:     stable@vger.kernel.org
Subject: [PATCH 4.4] x86/apic/32: Avoid bogus LDR warnings
Message-ID: <alpine.LNX.2.21.1912060523520.6537@joy.test>
User-Agent: Alpine 2.21 (LNX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes my bug in 4.4.206:

https://bugzilla.kernel.org/show_bug.cgi?id=205729

It could use testing by someone who exercises the code in a virtual
machine environment...

-----------------------------------------------------------------------------------

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit fe6f85ca121e9c74e7490fe66b0c5aae38e332c3 ]

The removal of the LDR initialization in the bigsmp_32 APIC code unearthed
a problem in setup_local_APIC().

The code checks unconditionally for a mismatch of the logical APIC id by
comparing the early APIC id which was initialized in get_smp_config() with
the actual LDR value in the APIC.

Due to the removal of the bogus LDR initialization the check now can
trigger on bigsmp_32 APIC systems emitting a warning for every booting
CPU. This is of course a false positive because the APIC is not using
logical destination mode.

Restrict the check and the possibly resulting fixup to systems which are
actually using the APIC in logical destination mode.

[ tglx: Massaged changelog and added Cc stable ]

Fixes: bae3a8d3308 ("x86/apic: Do not initialize LDR and DFR for bigsmp")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/666d8f91-b5a8-1afd-7add-821e72a35f03@suse.com
[ comet.berkeley: Backported to 4.4: adjust context ]
Signed-off-by: Richard Narron <comet.berkeley@gmail.com>

--- a/arch/x86/kernel/apic/apic.c.orig	2019-11-29 00:30:25.000000000 -0800
+++ b/arch/x86/kernel/apic/apic.c	2019-12-04 07:47:16.913136344 -0800
@@ -1298,16 +1298,21 @@ void setup_local_APIC(void)
  	apic->init_apic_ldr();

  #ifdef CONFIG_X86_32
-	/*
-	 * APIC LDR is initialized.  If logical_apicid mapping was
-	 * initialized during get_smp_config(), make sure it matches the
-	 * actual value.
-	 */
-	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
-	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
-		logical_smp_processor_id();
+	if (apic->dest_logical) {
+		int logical_apicid, ldr_apicid;
+
+		/*
+		 * APIC LDR is initialized.  If logical_apicid mapping was
+		 * initialized during get_smp_config(), make sure it matches
+		 * the actual value.
+		 */
+		logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+		ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+		if (logical_apicid != BAD_APICID)
+			WARN_ON(logical_apicid != ldr_apicid);
+		/* Always use the value from LDR. */
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
+	}
  #endif

  	/*
