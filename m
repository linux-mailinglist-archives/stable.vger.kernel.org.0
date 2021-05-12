Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677AA37B728
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 09:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhELH4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 03:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhELH4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 03:56:20 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A32CC06174A;
        Wed, 12 May 2021 00:55:12 -0700 (PDT)
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id A32B141D;
        Wed, 12 May 2021 09:55:09 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
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
Subject: [PATCH 4/6] Revert "x86/sev-es: Handle string port IO to kernel memory properly"
Date:   Wed, 12 May 2021 09:54:43 +0200
Message-Id: <20210512075445.18935-5-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512075445.18935-1-joro@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This reverts commit 7024f60d655272bd2ca1d3a4c9e0a63319b1eea1.

The commit reverted here introduces a short-cut into the #VC handlers
memory access code which only works reliably in task context. But the
kernels #VC handler can be invoked from any context, making the
access_ok() call trigger a warning with CONFIG_DEBUG_ATOMIC_SLEEP
enabled.

Also the memcpy() used in the reverted patch is wrong, as it has no
page-fault handling. Access to kernel memory can also fault due to
kernel bugs, and those should not be reported as faults from the #VC
handler but as bugs of their real call-site, which is correctly later
done from vc_forward_exception().

Fixes: 7024f60d6552 ("x86/sev-es: Handle string port IO to kernel memory properly")
Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 110b39345b40..f4f319004713 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -333,12 +333,6 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
 	u16 d2;
 	u8  d1;
 
-	/* If instruction ran in kernel mode and the I/O buffer is in kernel space */
-	if (!user_mode(ctxt->regs) && !access_ok(target, size)) {
-		memcpy(dst, buf, size);
-		return ES_OK;
-	}
-
 	switch (size) {
 	case 1:
 		memcpy(&d1, buf, 1);
@@ -388,12 +382,6 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 	u16 d2;
 	u8  d1;
 
-	/* If instruction ran in kernel mode and the I/O buffer is in kernel space */
-	if (!user_mode(ctxt->regs) && !access_ok(s, size)) {
-		memcpy(buf, src, size);
-		return ES_OK;
-	}
-
 	switch (size) {
 	case 1:
 		if (__get_user(d1, s))
-- 
2.31.1

