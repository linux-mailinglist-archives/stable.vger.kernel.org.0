Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074E63C55D8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348963AbhGLIMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354016AbhGLIDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017BB61629;
        Mon, 12 Jul 2021 07:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076750;
        bh=92RQ7ovfVPIika+3PGDd5//JInAuNVNk4o1IcirZSxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ldx0wYJyr3suk9LgPNYb55jnNIwYSe+5X4hGG7MsI0wt2PfhXiO9tuZwruNN/v/c1
         NzqwI7u5r5SpzkpIWoD7tIyihllT1NHLW6V74ySuF9QcenN39PQTEXkiAl4ul+24+U
         TZZaGOXYwuhlYnqSwFaljBKg1JJbtioyR1Mv3u0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 777/800] selftests/vm/pkeys: refill shadow register after implicit kernel write
Date:   Mon, 12 Jul 2021 08:13:20 +0200
Message-Id: <20210712061049.537663138@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 6039ca254979694c5362dfebadd105e286c397bb ]

The pkey test code keeps a "shadow" of the pkey register around.  This
ensures that any bugs which might write to the register can be caught more
quickly.

Generally, userspace has a good idea when the kernel is going to write to
the register.  For instance, alloc_pkey() is passed a permission mask.
The caller of alloc_pkey() can update the shadow based on the return value
and the mask.

But, the kernel can also modify the pkey register in a more sneaky way.
For mprotect(PROT_EXEC) mappings, the kernel will allocate a pkey and
write the pkey register to create an execute-only mapping.  The kernel
never tells userspace what key it uses for this.

This can cause the test to fail with messages like:

	protection_keys_64.2: pkey-helpers.h:132: _read_pkey_reg: Assertion `pkey_reg == shadow_pkey_reg' failed.

because the shadow was not updated with the new kernel-set value.

Forcibly update the shadow value immediately after an mprotect().

Link: https://lkml.kernel.org/r/20210611164200.EF76AB73@viggo.jf.intel.com
Fixes: 6af17cf89e99 ("x86/pkeys/selftests: Add PROT_EXEC test")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/protection_keys.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/vm/protection_keys.c b/tools/testing/selftests/vm/protection_keys.c
index 356d62fca27f..87eecd5ba577 100644
--- a/tools/testing/selftests/vm/protection_keys.c
+++ b/tools/testing/selftests/vm/protection_keys.c
@@ -1448,6 +1448,13 @@ void test_implicit_mprotect_exec_only_memory(int *ptr, u16 pkey)
 	ret = mprotect(p1, PAGE_SIZE, PROT_EXEC);
 	pkey_assert(!ret);
 
+	/*
+	 * Reset the shadow, assuming that the above mprotect()
+	 * correctly changed PKRU, but to an unknown value since
+	 * the actual alllocated pkey is unknown.
+	 */
+	shadow_pkey_reg = __read_pkey_reg();
+
 	dprintf2("pkey_reg: %016llx\n", read_pkey_reg());
 
 	/* Make sure this is an *instruction* fault */
-- 
2.30.2



