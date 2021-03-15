Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C3133B5CC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhCONzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhCONyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 098B264F04;
        Mon, 15 Mar 2021 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816492;
        bh=lSNMJ+BgW6p1BGcFGRrZo0sOPdSgjdqEpvetgnJ9qGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wREna++uzJWMqx7aj3ciREvuyg/Ez0wFDMKhRwLl/iGqk9cdzPRlXPbZs8uto83qS
         itYePKtJPq+JPU4b7WB4Np4xbwaC35rU6mtOMhNtIe9D/8Avbo0uHC/+5mVuQzod24
         Zwm5yXaPZ106T8/u+NONK2N6yKSkB5KvB+l6lKQc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 70/78] powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()
Date:   Mon, 15 Mar 2021 14:52:33 +0100
Message-Id: <20210315135214.361168874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
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
@@ -46,7 +46,7 @@ void __patch_exception(int exc, unsigned
 #endif
 
 #define OP_RT_RA_MASK	0xffff0000UL
-#define LIS_R2		0x3c020000UL
+#define LIS_R2		0x3c400000UL
 #define ADDIS_R2_R12	0x3c4c0000UL
 #define ADDI_R2_R2	0x38420000UL
 


