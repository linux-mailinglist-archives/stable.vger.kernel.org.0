Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1341C3D1113
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhGUNkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 09:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbhGUNkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 09:40:01 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C27C061575;
        Wed, 21 Jul 2021 07:20:38 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id CCB49936;
        Wed, 21 Jul 2021 16:20:24 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Eric Biederman <ebiederm@xmission.com>
Cc:     kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joerg Roedel <joro@8bytes.org>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 02/12] x86/kexec/64: Forbid kexec when running as an SEV-ES guest
Date:   Wed, 21 Jul 2021 16:20:05 +0200
Message-Id: <20210721142015.1401-3-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721142015.1401-1-joro@8bytes.org>
References: <20210721142015.1401-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

For now, kexec is not supported when running as an SEV-ES guest. Doing
so requires additional hypervisor support and special code to hand
over the CPUs to the new kernel in a safe way.

Until this is implemented, do not support kexec in SEV-ES guests.

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/machine_kexec_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 131f30fdcfbd..a8e16a411b40 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -591,3 +591,11 @@ void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
 	 */
 	set_memory_encrypted((unsigned long)vaddr, pages);
 }
+
+/*
+ * Kexec is not supported in SEV-ES guests yet
+ */
+bool arch_kexec_supported(void)
+{
+	return !sev_es_active();
+}
-- 
2.31.1

