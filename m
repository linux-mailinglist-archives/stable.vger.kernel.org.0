Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C221F39A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfEOMPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbfEOLDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8CB20881;
        Wed, 15 May 2019 11:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918181;
        bh=TX/+w/fCmI6K5MJy9g2ncMwELVZrNAqlvCXxLeMYokE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ahaf5cDIm/wZ06xWe8O72VBhTolTarTFCjKcWQHCE38IYGi22WeYL1ABSwIK5oXwp
         iNCpcjC+maZKi1s/2KdRBcvdimICIz0EBd3Td9zhKJIJkjuNxAHCL7L7N1BEpSHMXW
         iYLcacGIrcDWP0GWLkk9lcbYDIrjp83j+bB9TTbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 037/266] powerpc/64s: Add barrier_nospec
Date:   Wed, 15 May 2019 12:52:24 +0200
Message-Id: <20190515090723.764238607@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

commit a6b3964ad71a61bb7c61d80a60bea7d42187b2eb upstream.

A no-op form of ori (or immediate of 0 into r31 and the result stored
in r31) has been re-tasked as a speculation barrier. The instruction
only acts as a barrier on newer machines with appropriate firmware
support. On older CPUs it remains a harmless no-op.

Implement barrier_nospec using this instruction.

mpe: The semantics of the instruction are believed to be that it
prevents execution of subsequent instructions until preceding branches
have been fully resolved and are no longer executing speculatively.
There is no further documentation available at this time.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/barrier.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -92,4 +92,19 @@ do {									\
 #define smp_mb__after_atomic()      smp_mb()
 #define smp_mb__before_spinlock()   smp_mb()
 
+#ifdef CONFIG_PPC_BOOK3S_64
+/*
+ * Prevent execution of subsequent instructions until preceding branches have
+ * been fully resolved and are no longer executing speculatively.
+ */
+#define barrier_nospec_asm ori 31,31,0
+
+// This also acts as a compiler barrier due to the memory clobber.
+#define barrier_nospec() asm (stringify_in_c(barrier_nospec_asm) ::: "memory")
+
+#else /* !CONFIG_PPC_BOOK3S_64 */
+#define barrier_nospec_asm
+#define barrier_nospec()
+#endif
+
 #endif /* _ASM_POWERPC_BARRIER_H */


