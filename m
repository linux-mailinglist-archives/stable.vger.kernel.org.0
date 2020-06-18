Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06D51FDF80
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732859AbgFRBk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732436AbgFRBaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:30:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6568522249;
        Thu, 18 Jun 2020 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443801;
        bh=zc5Pcx9v24n3UXJ4a8J2O/2UsMOZOwQWmlgwTrqiHvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCFlAkU7bIZhlK7lw8p59cdcg4ooUF3AKVsafSfPvIK2trMKIDuZncDfKB74wzHal
         GBHpEb41WBOoe62/XucDHKHUKcpdHsZvEKMxSBxFd/Gw0I1vM0n1iGfehu3Qxx8xaG
         xKIziRTdLHYp+wU62y3KKWyd30NiFDSXGwezvpn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ram Pai <linuxram@us.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        Shuah Khan <shuah@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 78/80] selftests/vm/pkeys: fix alloc_random_pkey() to make it really random
Date:   Wed, 17 Jun 2020 21:28:17 -0400
Message-Id: <20200618012819.609778-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

[ Upstream commit 6e373263ce07eeaa6410843179535fbdf561fc31 ]

alloc_random_pkey() was allocating the same pkey every time.  Not all
pkeys were geting tested.  This fixes it.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Link: http://lkml.kernel.org/r/0162f55816d4e783a0d6e49e554d0ab9a3c9a23b.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/protection_keys.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/protection_keys.c b/tools/testing/selftests/x86/protection_keys.c
index 874972ccfc95..5338e668b5e6 100644
--- a/tools/testing/selftests/x86/protection_keys.c
+++ b/tools/testing/selftests/x86/protection_keys.c
@@ -23,6 +23,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <linux/futex.h>
+#include <time.h>
 #include <sys/time.h>
 #include <sys/syscall.h>
 #include <string.h>
@@ -608,10 +609,10 @@ int alloc_random_pkey(void)
 	int nr_alloced = 0;
 	int random_index;
 	memset(alloced_pkeys, 0, sizeof(alloced_pkeys));
+	srand((unsigned int)time(NULL));
 
 	/* allocate every possible key and make a note of which ones we got */
 	max_nr_pkey_allocs = NR_PKEYS;
-	max_nr_pkey_allocs = 1;
 	for (i = 0; i < max_nr_pkey_allocs; i++) {
 		int new_pkey = alloc_pkey();
 		if (new_pkey < 0)
-- 
2.25.1

