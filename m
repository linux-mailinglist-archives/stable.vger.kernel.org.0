Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591A842B12B
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhJMA5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236254AbhJMA46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 433E560FDA;
        Wed, 13 Oct 2021 00:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086496;
        bh=rhCEe1YAL5L+0Vhv2XSfVCZXHV0jEo7p42ZhTme8rzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nacIF5CJW/Pbz0pqNMB+pqUzuXPi75sfwqYy7d7uMMph+VXFQdSFUGV4elxUiLzOH
         suIcFT5xKKR8ukI/2FwtxiuOllro0L9RqtNyfFxLy0e9f7PJh5JFsArcMmfY32SJzi
         tErlqd0WxJCV+lHAJ1YYg1zmuGWTwc8/W0J1i4K39gUXj/+Pc5nNQ2Vz4YZL2PHxCD
         k1jhyaqIRjzGs0klBS3jFT1I9xuI1naGy5wIMW+PQU3MMNDk+TvFXVYCBnMCkuZBx2
         q61zu1fJRekvgodNsdoR6vnKsB80AigiuCaMl5KmeeGPOEAWl6aU+oUTFRDT+1l+gx
         GySAupZ5GiyWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.14 06/17] xen/x86: prevent PVH type from getting clobbered
Date:   Tue, 12 Oct 2021 20:54:30 -0400
Message-Id: <20211013005441.699846-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 9172b5c4a778da1f855b2e3780b1afabb3cfd523 ]

Like xen_start_flags, xen_domain_type gets set before .bss gets cleared.
Hence this variable also needs to be prevented from getting put in .bss,
which is possible because XEN_NATIVE is an enumerator evaluating to
zero. Any use prior to init_hvm_pv_info() setting the variable again
would lead to wrong decisions; one such case is xenboot_console_setup()
when called as a result of "earlyprintk=xen".

Use __ro_after_init as more applicable than either __section(".data") or
__read_mostly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>

Link: https://lore.kernel.org/r/d301677b-6f22-5ae6-bd36-458e1f323d0b@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c79bd0af2e8c..f252faf5028f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -52,9 +52,6 @@ DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DEFINE_PER_CPU(uint32_t, xen_vcpu_id);
 EXPORT_PER_CPU_SYMBOL(xen_vcpu_id);
 
-enum xen_domain_type xen_domain_type = XEN_NATIVE;
-EXPORT_SYMBOL_GPL(xen_domain_type);
-
 unsigned long *machine_to_phys_mapping = (void *)MACH2PHYS_VIRT_START;
 EXPORT_SYMBOL(machine_to_phys_mapping);
 unsigned long  machine_to_phys_nr;
@@ -69,9 +66,11 @@ __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 
 /*
- * NB: needs to live in .data because it's used by xen_prepare_pvh which runs
- * before clearing the bss.
+ * NB: These need to live in .data or alike because they're used by
+ * xen_prepare_pvh() which runs before clearing the bss.
  */
+enum xen_domain_type __ro_after_init xen_domain_type = XEN_NATIVE;
+EXPORT_SYMBOL_GPL(xen_domain_type);
 uint32_t xen_start_flags __section(".data") = 0;
 EXPORT_SYMBOL(xen_start_flags);
 
-- 
2.33.0

