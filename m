Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D533B5B8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhCONzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231354AbhCONyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1F064EEA;
        Mon, 15 Mar 2021 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816479;
        bh=xi+IWdAEVfdsSlnVGf+tWazNbjmApXBzlPJtqO/svgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPj8IPHoz0jod3+MF9rSLCjdhfhoqHnHHkt6rHx8CH1RvXz19EgZf7Phh7/TAfoBH
         O11Uqj77JGeCkMa/j6Ce5Z+IMoFB0TOJsBj3LU87k6b4bX5cosVzv7PdFY7VhHcVVL
         nZt4FMdzBlEkIH09Fp8aftgSOawzDQ6Se7/ObKc0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 68/75] powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()
Date:   Mon, 15 Mar 2021 14:52:22 +0100
Message-Id: <20210315135210.479340945@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
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
@@ -45,7 +45,7 @@ void __patch_exception(int exc, unsigned
 #endif
 
 #define OP_RT_RA_MASK	0xffff0000UL
-#define LIS_R2		0x3c020000UL
+#define LIS_R2		0x3c400000UL
 #define ADDIS_R2_R12	0x3c4c0000UL
 #define ADDI_R2_R2	0x38420000UL
 


