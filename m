Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D8414B9D3
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgA1OVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731238AbgA1OVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:21:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 730952071E;
        Tue, 28 Jan 2020 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221275;
        bh=PkdHkgPs1rwq/MEdmnI6tsx7avovdsP70a/agvoptX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPh6PltPFVr+G1m4o3IkeA3K756LM1b+nRK4hC9+zOjTwTT5a7pBMbwQEqXHR7vhw
         P5m+kaksLEcZjUIXF5EaR/x6vYv7TylgrPtxffKv2hu5WtzbE48ePVLZqNUmOK31x3
         vOv1LI7Zr+Uh6zl6wTWHvw3IxE5Bu02HeUDoC9kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, acme@kernel.org,
        linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mpe@ellerman.id.au, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 160/271] perf/ioctl: Add check for the sample_period value
Date:   Tue, 28 Jan 2020 15:05:09 +0100
Message-Id: <20200128135904.486507028@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 913a90bc5a3a06b1f04c337320e9aeee2328dd77 ]

perf_event_open() limits the sample_period to 63 bits. See:

  0819b2e30ccb ("perf: Limit perf_event_attr::sample_period to 63 bits")

Make ioctl() consistent with it.

Also on PowerPC, negative sample_period could cause a recursive
PMIs leading to a hang (reported when running perf-fuzzer).

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: acme@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: maddy@linux.vnet.ibm.com
Cc: mpe@ellerman.id.au
Fixes: 0819b2e30ccb ("perf: Limit perf_event_attr::sample_period to 63 bits")
Link: https://lkml.kernel.org/r/20190604042953.914-1-ravi.bangoria@linux.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5bbf7537a6121..64ace5e9af2a0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4624,6 +4624,9 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 	if (perf_event_check_period(event, value))
 		return -EINVAL;
 
+	if (!event->attr.freq && (value & (1ULL << 63)))
+		return -EINVAL;
+
 	event_function_call(event, __perf_event_period, &value);
 
 	return 0;
-- 
2.20.1



