Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C63C50D0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245586AbhGLHfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345472AbhGLH3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41F1A61166;
        Mon, 12 Jul 2021 07:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074809;
        bh=ESszSOxaOd3Rx8/NyECZ4eFeISMx95sBA1oNVh5cRAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBIhf5Od4YEH2YajHufqTPfTQhXniHCVvdSHEDrq9qUxBg6Zflz7deIPyKKpKppmm
         nHbyJ8oLFDErwkfNDz0S0Fy4OW0lUf1y88y+dwUCTMCKD3y4d0vhFjyDFZsbeJHH8v
         Qaav7J4F76kaYK36SKZNnrh+lrqElu4sHu9FUJ2g=
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
Subject: [PATCH 5.12 676/700] selftests/vm/pkeys: handle negative sys_pkey_alloc() return code
Date:   Mon, 12 Jul 2021 08:12:39 +0200
Message-Id: <20210712061047.809507124@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



