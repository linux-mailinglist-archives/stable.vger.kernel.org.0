Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CC1F7E82
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfKKSje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbfKKSjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:39:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CF521925;
        Mon, 11 Nov 2019 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497571;
        bh=iRSg4wD3BHuGV4aMK0iULp9PHyr2skPxAlyGY1lKHn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12ebJzthUmCKo/8rQkSRKnyFBVSlcx9+4mIBLVfROxD4PR001HUqFSaHURIE4IgNu
         oYNdb+4ggAvNK9UtG8SuyR3OWr5kY1Y7JojUqkcS4b24D3e1h12STo5r2jzBRPw9LR
         tnQ8ySN4N0NCWZQp3345eWtjTYXgPsb3phMhEIFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dou Liyang <douly.fnst@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        andy.shevchenko@gmail.com, bhe@redhat.com, ebiederm@xmission.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/105] x86/apic: Drop logical_smp_processor_id() inline
Date:   Mon, 11 Nov 2019 19:29:11 +0100
Message-Id: <20191111181449.332092047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dou Liyang <douly.fnst@cn.fujitsu.com>

[ Upstream commit 8f1561680f42a5491b371b513f1ab8197f31fd62 ]

The logical_smp_processor_id() inline which is only called in
setup_local_APIC() on x86_32 systems has no real value.

Drop it and directly use GET_APIC_LOGICAL_ID() at the call site and use a
more suitable variable name for readability

Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: andy.shevchenko@gmail.com
Cc: bhe@redhat.com
Cc: ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20180301055930.2396-4-douly.fnst@cn.fujitsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/smp.h  | 10 ----------
 arch/x86/kernel/apic/apic.c | 10 +++++-----
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index fe2ee61880a86..a14730ca9d1e2 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -175,16 +175,6 @@ static inline int wbinvd_on_all_cpus(void)
 extern unsigned disabled_cpus;
 
 #ifdef CONFIG_X86_LOCAL_APIC
-
-#ifndef CONFIG_X86_64
-static inline int logical_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
-}
-
-#endif
-
 extern int hard_smp_processor_id(void);
 
 #else /* CONFIG_X86_LOCAL_APIC */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 98fecdbec6402..97d1290d1f0d8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1423,7 +1423,7 @@ void setup_local_APIC(void)
 	int cpu = smp_processor_id();
 	unsigned int value;
 #ifdef CONFIG_X86_32
-	int i;
+	int logical_apicid, ldr_apicid;
 #endif
 
 
@@ -1470,11 +1470,11 @@ void setup_local_APIC(void)
 	 * initialized during get_smp_config(), make sure it matches the
 	 * actual value.
 	 */
-	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
+	logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+	WARN_ON(logical_apicid != BAD_APICID && logical_apicid != ldr_apicid);
 	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
-		logical_smp_processor_id();
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
 #endif
 
 	/*
-- 
2.20.1



