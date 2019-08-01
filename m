Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E317D725
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfHAIUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36543 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbfHAIUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so33605444pfl.3
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TdEXa/ACn7xvRmbVhm+K3Nf7xZB7iBxOAU/Z5YPY+9w=;
        b=Yc1AA1CJGqSJYLBpPb6+g8zXpFF097IJpE/ujUlSotcolHoh6Y10BNwwJfWdTdJKMs
         /Dlw2wfdWh9TVJ7mGv2zsjbrtaGgR+O375wcrQ5HyBRwIuUBJQf4xfWEonF0z8yGsZ1U
         HzxbcfvgC6DxgjV9aRwgvrwmlM49P4J92MjZ1wPS/8wlr5s+nfyFCM2g+ZLaRbWIjYtE
         txZOPZGuFVQsutVx5gwoLFl/60jilYmI/fOWrIiD7kMj6BT9jRZV2mlzAGt43nPdY85c
         IDRrxRIGx84kE4fcqmVqCPx2MicByt81b5TcVBrsEIWo+MqvzZrp578iEhPlN0HpxEsw
         f0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TdEXa/ACn7xvRmbVhm+K3Nf7xZB7iBxOAU/Z5YPY+9w=;
        b=b6Z0fV+vAoN11chcz9cRzKnZECMSpnQ4Yeiq6v9cYtwDM8azrORyks57H5EGdzLQh2
         LsV6CfCpz4YDFpxvzamJMBIw3V51W5rsgaG89jRvLpkeMQ5FTMeSZuhXCOar4rAz5e2a
         cfuDHlStraOSZFafca3OtRQpMs14E8hGcrJ9Pyh7ypOLkuy+nXR5KS+mrdmQAOG7PXdb
         SbtzHx7RBW9c5GMVFXIDaCrjra26si/GxOyjRlR9q2/nM5gj8MX225vj9z9wNasOjQqw
         Vsi4C9Am+VxwyYTQX+1R7rBGmxiz8qWQdiPhqnWmS2N1dzZEpCYdIyha3jD/FSkaSSTp
         DVUg==
X-Gm-Message-State: APjAAAWgB2m+ztyPNwEfzJ8xzq52Xmg+NypgSsFVLk4bscdk7O7ly2zx
        lM9v62G0EyXszFxu3NzmUutIkZDxvcY=
X-Google-Smtp-Source: APXvYqzg+k1IMsuY/0YlKSVfy0FSYlyP0aAAvifk3LfPZy6nOREz9peYXx0wqLLpaox0jbRn5W145Q==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr7231563pjs.119.1564647606812;
        Thu, 01 Aug 2019 01:20:06 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id a15sm94846475pfg.102.2019.08.01.01.20.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:06 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 12/47] ARM: bugs: add support for per-processor bug checking
Date:   Thu,  1 Aug 2019 13:45:56 +0530
Message-Id: <812038dccaf90fed1b1331878beb0354e7e4c1d1.1564646727.git.viresh.kumar@linaro.org>
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

Commit 9d3a04925deeabb97c8e26d940b501a2873e8af3 upstream.

Add support for per-processor bug checking - each processor function
descriptor gains a function pointer for this check, which must not be
an __init function.  If non-NULL, this will be called whenever a CPU
enters the kernel via which ever path (boot CPU, secondary CPU startup,
CPU resuming, etc.)

This allows processor specific bug checks to validate that workaround
bits are properly enabled by firmware via all entry paths to the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/proc-fns.h | 4 ++++
 arch/arm/kernel/bugs.c          | 4 ++++
 arch/arm/mm/proc-macros.S       | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 8877ad5ffe10..f379f5f849a9 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -36,6 +36,10 @@ extern struct processor {
 	 * Set up any processor specifics
 	 */
 	void (*_proc_init)(void);
+	/*
+	 * Check for processor bugs
+	 */
+	void (*check_bugs)(void);
 	/*
 	 * Disable any processor specifics
 	 */
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
index 16e7ba2a9cc4..7be511310191 100644
--- a/arch/arm/kernel/bugs.c
+++ b/arch/arm/kernel/bugs.c
@@ -5,6 +5,10 @@
 
 void check_other_bugs(void)
 {
+#ifdef MULTI_CPU
+	if (processor.check_bugs)
+		processor.check_bugs();
+#endif
 }
 
 void __init check_bugs(void)
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index c671f345266a..212147c78f4b 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -258,13 +258,14 @@
 	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
 	.endm
 
-.macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0
+.macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0, bugs=0
 	.type	\name\()_processor_functions, #object
 	.align 2
 ENTRY(\name\()_processor_functions)
 	.word	\dabort
 	.word	\pabort
 	.word	cpu_\name\()_proc_init
+	.word	\bugs
 	.word	cpu_\name\()_proc_fin
 	.word	cpu_\name\()_reset
 	.word	cpu_\name\()_do_idle
-- 
2.21.0.rc0.269.g1a574e7a288b

