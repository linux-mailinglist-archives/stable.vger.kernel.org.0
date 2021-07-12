Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0B03C55DD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350022AbhGLIMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354015AbhGLIDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4F36191E;
        Mon, 12 Jul 2021 07:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076748;
        bh=ESszSOxaOd3Rx8/NyECZ4eFeISMx95sBA1oNVh5cRAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWgoM3ViI01YDe8YoA18stjkA8NBA9oWEC8055Qr3VK0HPAWhqq6DhDVYbbxXwEck
         UKFLOd5M4QTceVUtus/tcRZz9DsvnUWRzXuNtlMHcuAHiwg3VMjHdAGEQdCWBoo7dL
         IlpFuu7r3V1mV/99iX2oVuAOUMeNjKiT9bfelz3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH 5.13 776/800] selftests/vm/pkeys: handle negative sys_pkey_alloc() return code
Date:   Mon, 12 Jul 2021 08:13:19 +0200
Message-Id: <20210712061049.427728367@linuxfoundation.org>
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

[ Upstream commit bf68294a2ec39ed7fec6a5b45d52034e6983157a ]

The alloc_pkey() sefltest function wraps the sys_pkey_alloc() system call.
On success, it updates its "shadow" register value because
sys_pkey_alloc() updates the real register.

But, the success check is wrong.  pkey_alloc() considers any non-zero
return code to indicate success where the pkey register will be modified.
This fails to take negative return codes into account.

Consider only a positive return value as a successful call.

Link: https://lkml.kernel.org/r/20210611164157.87AB4246@viggo.jf.intel.com
Fixes: 5f23f6d082a9 ("x86/pkeys: Add self-tests")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
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
 tools/testing/selftests/vm/protection_keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/protection_keys.c b/tools/testing/selftests/vm/protection_keys.c
index 9ee0ae5d3e06..356d62fca27f 100644
--- a/tools/testing/selftests/vm/protection_keys.c
+++ b/tools/testing/selftests/vm/protection_keys.c
@@ -510,7 +510,7 @@ int alloc_pkey(void)
 			" shadow: 0x%016llx\n",
 			__func__, __LINE__, ret, __read_pkey_reg(),
 			shadow_pkey_reg);
-	if (ret) {
+	if (ret > 0) {
 		/* clear both the bits: */
 		shadow_pkey_reg = set_pkey_bits(shadow_pkey_reg, ret,
 						~PKEY_MASK);
-- 
2.30.2



