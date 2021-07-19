Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148A73CDB58
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbhGSOmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344118AbhGSOj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD59460241;
        Mon, 19 Jul 2021 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708037;
        bh=/NkhAXhQ2HHWRaiUh3uIDaEq56gCIBgjcXmfbG1PUhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5jWnEdK6vYJ3kgIbhGHV4exYAbyUKr8hxRiIBBveimjHmcCPOqe+JUHWOg8pY2G0
         6Pj80/6kKkeTriMAENeJGMQeqTKLNk81PQh8U/IettcsfGaMiq1RrzGRvX2S6R11iS
         bvScXEms9Pvgur03uli6ikcn+rOjYByqqGWawYEg=
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
Subject: [PATCH 4.14 157/315] selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random
Date:   Mon, 19 Jul 2021 16:50:46 +0200
Message-Id: <20210719144948.050652848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit f36ef407628835a7d7fb3d235b1f1aac7022d9a3 ]

Patch series "selftests/vm/pkeys: Bug fixes and a new test".

There has been a lot of activity on the x86 front around the XSAVE
architecture which is used to context-switch processor state (among other
things).  In addition, AMD has recently joined the protection keys club by
adding processor support for PKU.

The AMD implementation helped uncover a kernel bug around the PKRU "init
state", which actually applied to Intel's implementation but was just
harder to hit.  This series adds a test which is expected to help find
this class of bug both on AMD and Intel.  All the work around pkeys on x86
also uncovered a few bugs in the selftest.

This patch (of 4):

The "random" pkey allocation code currently does the good old:

	srand((unsigned int)time(NULL));

*But*, it unfortunately does this on every random pkey allocation.

There may be thousands of these a second.  time() has a one second
resolution.  So, each time alloc_random_pkey() is called, the PRNG is
*RESET* to time().  This is nasty.  Normally, if you do:

	srand(<ANYTHING>);
	foo = rand();
	bar = rand();

You'll be quite guaranteed that 'foo' and 'bar' are different.  But, if
you do:

	srand(1);
	foo = rand();
	srand(1);
	bar = rand();

You are quite guaranteed that 'foo' and 'bar' are the *SAME*.  The recent
"fix" effectively forced the test case to use the same "random" pkey for
the whole test, unless the test run crossed a second boundary.

Only run srand() once at program startup.

This explains some very odd and persistent test failures I've been seeing.

Link: https://lkml.kernel.org/r/20210611164153.91B76FB8@viggo.jf.intel.com
Link: https://lkml.kernel.org/r/20210611164155.192D00FF@viggo.jf.intel.com
Fixes: 6e373263ce07 ("selftests/vm/pkeys: fix alloc_random_pkey() to make it really random")
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
 tools/testing/selftests/x86/protection_keys.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/protection_keys.c b/tools/testing/selftests/x86/protection_keys.c
index b8778960da10..27661302a698 100644
--- a/tools/testing/selftests/x86/protection_keys.c
+++ b/tools/testing/selftests/x86/protection_keys.c
@@ -613,7 +613,6 @@ int alloc_random_pkey(void)
 	int nr_alloced = 0;
 	int random_index;
 	memset(alloced_pkeys, 0, sizeof(alloced_pkeys));
-	srand((unsigned int)time(NULL));
 
 	/* allocate every possible key and make a note of which ones we got */
 	max_nr_pkey_allocs = NR_PKEYS;
@@ -1479,6 +1478,8 @@ int main(void)
 {
 	int nr_iterations = 22;
 
+	srand((unsigned int)time(NULL));
+
 	setup_handlers();
 
 	printf("has pku: %d\n", cpu_has_pku());
-- 
2.30.2



