Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D7933BA9C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhCOOJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbhCOOEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1E0564EEB;
        Mon, 15 Mar 2021 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817059;
        bh=zg/ODY4xgrUUljpz1wfqqqExAwX4/xT6tnck+U0eMes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQLq+ZV4ACQjwY3fUoP9/I6rAFt9mxpNGJcN0FNeS/sx197qRlYIPZuqoAN5YfsOv
         IzrSWArYTamRFHjfqQgUjWZQMSjgJVAejVGRLx/UjdRKWIIhth/y2ctImsaTp0ac5s
         f5JktvRgUwuhVaP7f8ukEscvWXvp0eWyRJyYPuOQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 280/306] powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()
Date:   Mon, 15 Mar 2021 14:55:43 +0100
Message-Id: <20210315135517.139145957@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit cea15316ceee2d4a51dfdecd79e08a438135416c upstream.

'lis r2,N' is 'addis r2,0,N' and the instruction encoding in the macro
LIS_R2 is incorrect (it currently maps to 'addis r0,r2,N'). Fix the
same.

Fixes: c71b7eff426f ("powerpc: Add ABIv2 support to ppc_function_entry")
Cc: stable@vger.kernel.org # v3.16+
Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210304020411.16796-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/code-patching.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -73,7 +73,7 @@ void __patch_exception(int exc, unsigned
 #endif
 
 #define OP_RT_RA_MASK	0xffff0000UL
-#define LIS_R2		0x3c020000UL
+#define LIS_R2		0x3c400000UL
 #define ADDIS_R2_R12	0x3c4c0000UL
 #define ADDI_R2_R2	0x38420000UL
 


