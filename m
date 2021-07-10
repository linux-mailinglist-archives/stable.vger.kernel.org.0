Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA253C3113
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhGJCkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235784AbhGJCjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CE14613ED;
        Sat, 10 Jul 2021 02:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884547;
        bh=nrRvggJviXFfdy9LsU0DWs5Wxc2DOv6ikzovAtFzfGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5Nk2G1ZiS5w7mk7l7QJOy/U2EgxriHj8GzVLJjbMj0UIcWTcWGyZtekqjayGj+XO
         IAUsvvN3kGOjThF3NmKmFqTwlZ+1vXzi79FcQNA0htkHh/VdbldQsejZCVwO3lXnH2
         5yLT8RgJMZqjuoBijHkrsJQrVcF+kzUfGHkgL4ohgh85bm2uipUzlrC5wNk/6VSM6A
         b7xhsJvx2XUN2eBWWxofFgmzRhvo6uWb78zOdZuFgkaUP2seVy3AMnHh3cp/b0ZOZI
         wGEfuXDIc9rRArkIQjQwXNKXmCiQYBmSl3P0Su1W3hyqA9DxWn2aMtVCaGx9WG1/Sc
         GHWkm8rFgULOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Shirisha Ganta <shirisha.ganta1@ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 21/33] selftests/powerpc: Fix "no_handler" EBB selftest
Date:   Fri,  9 Jul 2021 22:35:03 -0400
Message-Id: <20210710023516.3172075-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 45677c9aebe926192e59475b35a1ff35ff2d4217 ]

The "no_handler_test" in ebb selftests attempts to read the PMU
registers twice via helper function "dump_ebb_state". First dump is
just before closing of event and the second invocation is done after
closing of the event. The original intention of second
dump_ebb_state was to dump the state of registers at the end of
the test when the counters are frozen. But this will be achieved
with the first call itself since sample period is set to low value
and PMU will be frozen by then. Hence patch removes the
dump which was done before closing of the event.

Reported-by: Shirisha Ganta <shirisha.ganta1@ibm.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com <mailto:rnsastry@linux.ibm.com>>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1621950703-1532-2-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c b/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
index 8341d7778d5e..87630d44fb4c 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
@@ -50,8 +50,6 @@ static int no_handler_test(void)
 
 	event_close(&event);
 
-	dump_ebb_state();
-
 	/* The real test is that we never took an EBB at 0x0 */
 
 	return 0;
-- 
2.30.2

