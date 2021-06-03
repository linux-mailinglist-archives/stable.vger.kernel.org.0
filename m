Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B8039A21E
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFCNYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 09:24:46 -0400
Received: from 8bytes.org ([81.169.241.247]:41978 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhFCNYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 09:24:46 -0400
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 87631391;
        Thu,  3 Jun 2021 15:22:59 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Eric Biederman <ebiederm@xmission.com>, x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
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
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v2 2/2] x86/kexec/64: Forbid kexec when running as an SEV-ES guest
Date:   Thu,  3 Jun 2021 15:22:33 +0200
Message-Id: <20210603132233.10004-3-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603132233.10004-1-joro@8bytes.org>
References: <20210603132233.10004-1-joro@8bytes.org>
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
index c078b0d3ab0e..f902cc9cc634 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -620,3 +620,11 @@ void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
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

