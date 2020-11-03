Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC9F2A584E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgKCUs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731673AbgKCUsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF9D520719;
        Tue,  3 Nov 2020 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436535;
        bh=ahjbn9H70hPUckCaDcElCvVnZe3GnTqMRqR5U/J3N8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBcNyaTtUVGIQGV0RbKxP9qEmIjNrIalwr+NET8NMgDi6k/NNBrq3unC+4jGEZKxN
         b//WZZtCpoeZ/n6hGsjeb9Vtfgc3w6e4Xx//Z6YBH+4VKozj0RgVPvzokh3MBhaGuS
         JiHYZeT9jpLw9DDgvQsP+ql3804jngXwDtyn1mDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 291/391] powerpc/mce: Avoid nmi_enter/exit in real mode on pseries hash
Date:   Tue,  3 Nov 2020 21:35:42 +0100
Message-Id: <20201103203406.705455782@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

commit 8d0e2101274358d9b6b1f27232b40253ca48bab5 upstream.

Use of nmi_enter/exit in real mode handler causes the kernel to panic
and reboot on injecting SLB mutihit on pseries machine running in hash
MMU mode, because these calls try to accesses memory outside RMO
region in real mode handler where translation is disabled.

Add check to not to use these calls on pseries machine running in hash
MMU mode.

Fixes: 116ac378bb3f ("powerpc/64s: machine check interrupt update NMI accounting")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201009064005.19777-2-ganeshgr@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/mce.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -591,12 +591,11 @@ EXPORT_SYMBOL_GPL(machine_check_print_ev
 long notrace machine_check_early(struct pt_regs *regs)
 {
 	long handled = 0;
-	bool nested = in_nmi();
 	u8 ftrace_enabled = this_cpu_get_ftrace_enabled();
 
 	this_cpu_set_ftrace_enabled(0);
-
-	if (!nested)
+	/* Do not use nmi_enter/exit for pseries hpte guest */
+	if (radix_enabled() || !firmware_has_feature(FW_FEATURE_LPAR))
 		nmi_enter();
 
 	hv_nmi_check_nonrecoverable(regs);
@@ -607,7 +606,7 @@ long notrace machine_check_early(struct
 	if (ppc_md.machine_check_early)
 		handled = ppc_md.machine_check_early(regs);
 
-	if (!nested)
+	if (radix_enabled() || !firmware_has_feature(FW_FEATURE_LPAR))
 		nmi_exit();
 
 	this_cpu_set_ftrace_enabled(ftrace_enabled);


