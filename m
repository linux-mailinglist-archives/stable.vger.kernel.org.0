Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EE8201088
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393632AbgFSPbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393797AbgFSPbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4963620757;
        Fri, 19 Jun 2020 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580671;
        bh=fesb+m6/8ZgvadMLW5u59Am+eMgAkVHAPFHdsmUzjg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGXkW/n3uL0b18uwA7Mh9LSkxZ4ehOFBiwtZthPWXhqjvzE1apX/v7v5eul0SRJoW
         wKfJsWmYW4BIeNwDFPdav+kgSOFZmljbggHg/zqb42d9gS33b1hEGhiV8k1FuSgaxr
         GNZ6vD1zsO8yMmA/JlKNUHomuAf/Wyl8kkx9c9tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 338/376] powerpc/32s: Fix another build failure with CONFIG_PPC_KUAP_DEBUG
Date:   Fri, 19 Jun 2020 16:34:16 +0200
Message-Id: <20200619141726.333670293@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 74016701fe5f873ae23bf02835407227138d874d upstream.

'thread' doesn't exist in kuap_check() macro.

Use 'current' instead.

Fixes: a68c31fc01ef ("powerpc/32s: Implement Kernel Userspace Access Protection")
Cc: stable@vger.kernel.org
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b459e1600b969047a74e34251a84a3d6fdf1f312.1590858925.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/book3s/32/kup.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_POWERPC_BOOK3S_32_KUP_H
 #define _ASM_POWERPC_BOOK3S_32_KUP_H
 
+#include <asm/bug.h>
 #include <asm/book3s/32/mmu-hash.h>
 
 #ifdef __ASSEMBLY__
@@ -75,7 +76,7 @@
 
 .macro kuap_check	current, gpr
 #ifdef CONFIG_PPC_KUAP_DEBUG
-	lwz	\gpr, KUAP(thread)
+	lwz	\gpr, THREAD + KUAP(\current)
 999:	twnei	\gpr, 0
 	EMIT_BUG_ENTRY 999b, __FILE__, __LINE__, (BUGFLAG_WARNING | BUGFLAG_ONCE)
 #endif


