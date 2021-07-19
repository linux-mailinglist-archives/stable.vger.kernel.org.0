Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA383CE686
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349077AbhGSQH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347921AbhGSQFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 12:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B5961107;
        Mon, 19 Jul 2021 16:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626713106;
        bh=jwxkV8jZGl94FlM/nlAXZjfg9eIq3wI2w8TCMXtD7B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekEebnjmLj78LW7/x5uuqqxy/MmRiB1PW29Puwk+GAQGFYr/tL+cdo6WRreQ+Q3nI
         BYqU8wjK8sfODPwO2VCG1/cL4WInlSSoV/xiS936orrREaoEqOi0t76B4SeQJUWx9+
         8hFRn27N5uVNEcywW30n281wpI6OYKgclg0W80n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirisha Ganta <shirisha.ganta1@ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 110/351] selftests/powerpc: Fix "no_handler" EBB selftest
Date:   Mon, 19 Jul 2021 16:50:56 +0200
Message-Id: <20210719144948.128066923@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fc5bf4870d8e..01e827c31169 100644
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



