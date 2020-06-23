Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B58A206578
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388140AbgFWUEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388145AbgFWUED (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2539720EDD;
        Tue, 23 Jun 2020 20:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942642;
        bh=Ydou3JAf9zArP0VfSPlqKoiKSwL2uJ7zPPbMfdmwPWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erNRN+LOXFBiY23OszhxoIX+yysYld/YhbkT3jLBHs4jrjG6Klejj006k0kYWtWi7
         aqUjw7zyEwcANeQnpf4ylMEYV6PgzOFbePpqSDwRvtsw33CaBEol2Dx1/Mv9lSWTRm
         MuguO4tvSJyZS8DL9ClPuRGmhyXsqYZc7Tz+7aV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 079/477] powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple hv-24x7 events run
Date:   Tue, 23 Jun 2020 21:51:16 +0200
Message-Id: <20200623195411.345982604@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit b4ac18eead28611ff470d0f47a35c4e0ac080d9c ]

Commit 2b206ee6b0df ("powerpc/perf/hv-24x7: Display change in counter
values")' added to print _change_ in the counter value rather then raw
value for 24x7 counters. Incase of transactions, the event count
is set to 0 at the beginning of the transaction. It also sets
the event's prev_count to the raw value at the time of initialization.
Because of setting event count to 0, we are seeing some weird behaviour,
whenever we run multiple 24x7 events at a time.

For example:

command#: ./perf stat -e "{hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/,
			   hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/}"
	  		   -C 0 -I 1000 sleep 100

     1.000121704                120 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     1.000121704                  5 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     2.000357733                  8 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     2.000357733                 10 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     3.000495215 18,446,744,073,709,551,616 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     3.000495215 18,446,744,073,709,551,616 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     4.000641884                 56 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     4.000641884 18,446,744,073,709,551,616 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     5.000791887 18,446,744,073,709,551,616 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/

Getting these large values in case we do -I.

As we are setting event_count to 0, for interval case, overall event_count is not
coming in incremental order. As we may can get new delta lesser then previous count.
Because of which when we print intervals, we are getting negative value which create
these large values.

This patch removes part where we set event_count to 0 in function
'h_24x7_event_read'. There won't be much impact as we do set event->hw.prev_count
to the raw value at the time of initialization to print change value.

With this patch
In power9 platform

command#: ./perf stat -e "{hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/,
		           hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/}"
			   -C 0 -I 1000 sleep 100

     1.000117685                 93 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     1.000117685                  1 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     2.000349331                 98 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     2.000349331                  2 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     3.000495900                131 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     3.000495900                  4 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     4.000645920                204 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/
     4.000645920                 61 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=1/
     4.284169997                 22 hv_24x7/PM_MCS01_128B_RD_DISP_PORT01,chip=0/

Suggested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Tested-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200525104308.9814-2-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-24x7.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 573e0b309c0ca..48e8f4b17b91b 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -1400,16 +1400,6 @@ static void h_24x7_event_read(struct perf_event *event)
 			h24x7hw = &get_cpu_var(hv_24x7_hw);
 			h24x7hw->events[i] = event;
 			put_cpu_var(h24x7hw);
-			/*
-			 * Clear the event count so we can compute the _change_
-			 * in the 24x7 raw counter value at the end of the txn.
-			 *
-			 * Note that we could alternatively read the 24x7 value
-			 * now and save its value in event->hw.prev_count. But
-			 * that would require issuing a hcall, which would then
-			 * defeat the purpose of using the txn interface.
-			 */
-			local64_set(&event->count, 0);
 		}
 
 		put_cpu_var(hv_24x7_reqb);
-- 
2.25.1



