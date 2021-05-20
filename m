Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4F38A9B2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhETLFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239330AbhETLDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436BC6192A;
        Thu, 20 May 2021 10:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505064;
        bh=kb1ynkQ5/wcwO1Ud1Tlj2ve5xOmgIWuw9bwjfwVthkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUAV1430UoHQht8j7mGoQegAGt2LtOZIf9RGJdQYCNawF90oo+MwsWefocg4ewZU/
         5I82gP4QKQwpIeuTBiP/42XyEYn+6gwYF5L06pmS0NiLAhJgWYqoAl9HcE36Rd7tT2
         Wm5/tYZ35NpmkTDrWkn7LQ9dvFBIxc24y5QQQEzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 206/240] powerpc/64s: Fix crashes when toggling entry flush barrier
Date:   Thu, 20 May 2021 11:23:18 +0200
Message-Id: <20210520092115.569397610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit aec86b052df6541cc97c5fca44e5934cbea4963b upstream.

The entry flush mitigation can be enabled/disabled at runtime via a
debugfs file (entry_flush), which causes the kernel to patch itself to
enable/disable the relevant mitigations.

However depending on which mitigation we're using, it may not be safe to
do that patching while other CPUs are active. For example the following
crash:

  sleeper[15639]: segfault (11) at c000000000004c20 nip c000000000004c20 lr c000000000004c20

Shows that we returned to userspace with a corrupted LR that points into
the kernel, due to executing the partially patched call to the fallback
entry flush (ie. we missed the LR restore).

Fix it by doing the patching under stop machine. The CPUs that aren't
doing the patching will be spinning in the core of the stop machine
logic. That is currently sufficient for our purposes, because none of
the patching we do is to that code or anywhere in the vicinity.

Fixes: f79643787e0a ("powerpc/64s: flush L1D on kernel entry")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210506044959.1298123-2-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/feature-fixups.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/stop_machine.h>
 #include <asm/cputable.h>
 #include <asm/code-patching.h>
 #include <asm/page.h>
@@ -282,8 +283,9 @@ void do_uaccess_flush_fixups(enum l1d_fl
 						: "unknown");
 }
 
-void do_entry_flush_fixups(enum l1d_flush_type types)
+static int __do_entry_flush_fixups(void *data)
 {
+	enum l1d_flush_type types = *(enum l1d_flush_type *)data;
 	unsigned int instrs[3], *dest;
 	long *start, *end;
 	int i;
@@ -334,6 +336,19 @@ void do_entry_flush_fixups(enum l1d_flus
 							: "ori type" :
 		(types &  L1D_FLUSH_MTTRIG)     ? "mttrig type"
 						: "unknown");
+
+	return 0;
+}
+
+void do_entry_flush_fixups(enum l1d_flush_type types)
+{
+	/*
+	 * The call to the fallback flush can not be safely patched in/out while
+	 * other CPUs are executing it. So call __do_entry_flush_fixups() on one
+	 * CPU while all other CPUs spin in the stop machine core with interrupts
+	 * hard disabled.
+	 */
+	stop_machine(__do_entry_flush_fixups, &types, NULL);
 }
 
 void do_rfi_flush_fixups(enum l1d_flush_type types)


