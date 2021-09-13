Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02A74097FA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbhIMP5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:57:37 -0400
Received: from 8bytes.org ([81.169.241.247]:56796 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231407AbhIMP5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 11:57:35 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id B6F512A6;
        Mon, 13 Sep 2021 17:56:16 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
Subject: [PATCH v2 01/12] kexec: Allow architecture code to opt-out at runtime
Date:   Mon, 13 Sep 2021 17:55:52 +0200
Message-Id: <20210913155603.28383-2-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913155603.28383-1-joro@8bytes.org>
References: <20210913155603.28383-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Allow a runtime opt-out of kexec support for architecture code in case
the kernel is running in an environment where kexec is not properly
supported yet.

This will be used on x86 when the kernel is running as an SEV-ES
guest. SEV-ES guests need special handling for kexec to hand over all
CPUs to the new kernel. This requires special hypervisor support and
handling code in the guest which is not yet implemented.

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 include/linux/kexec.h |  1 +
 kernel/kexec.c        | 14 ++++++++++++++
 kernel/kexec_file.c   |  9 +++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0c994ae37729..85c30dcd0bdc 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -201,6 +201,7 @@ int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 				 unsigned long buf_len);
 #endif
 int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
+bool arch_kexec_supported(void);
 
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index b5e40f069768..275cda429380 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -190,11 +190,25 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
  * that to happen you need to do that yourself.
  */
 
+bool __weak arch_kexec_supported(void)
+{
+	return true;
+}
+
 static inline int kexec_load_check(unsigned long nr_segments,
 				   unsigned long flags)
 {
 	int result;
 
+	/*
+	 * The architecture may support kexec in general, but the kernel could
+	 * run in an environment where it is not (yet) possible to execute a new
+	 * kernel. Allow the architecture code to opt-out of kexec support when
+	 * it is running in such an environment.
+	 */
+	if (!arch_kexec_supported())
+		return -ENOSYS;
+
 	/* We only trust the superuser with rebooting the system. */
 	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 33400ff051a8..96d08a512e9c 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -358,6 +358,15 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	int ret = 0, i;
 	struct kimage **dest_image, *image;
 
+	/*
+	 * The architecture may support kexec in general, but the kernel could
+	 * run in an environment where it is not (yet) possible to execute a new
+	 * kernel. Allow the architecture code to opt-out of kexec support when
+	 * it is running in such an environment.
+	 */
+	if (!arch_kexec_supported())
+		return -ENOSYS;
+
 	/* We only trust the superuser with rebooting the system. */
 	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
-- 
2.33.0

