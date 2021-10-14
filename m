Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACD042DC80
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhJNO7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232520AbhJNO6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 355A7611C8;
        Thu, 14 Oct 2021 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223398;
        bh=GCt2C3RDvSbqWnxistKcpoIX6m1JQokV/m2AZecj7q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YiogPrEUFRoOpNe1eNd54fBcUC9s/Yu40H8SLSkKSb2R6EeiVkUQnNmwP33sTVXP
         8eXo6lz/zkNdsveteDxV451wSBMdtEALnUUsV8ouil9LpQzEBATJ0NJBH0iF828R3R
         r3x2HUrEEO8JDw04nCbME8fiiDRDtL6j6Rml5CAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 25/25] perf/x86: Reset destroy callback on event init failure
Date:   Thu, 14 Oct 2021 16:53:56 +0200
Message-Id: <20211014145208.383562223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

[ Upstream commit 02d029a41dc986e2d5a77ecca45803857b346829 ]

perf_init_event tries multiple init callbacks and does not reset the
event state between tries. When x86_pmu_event_init runs, it
unconditionally sets the destroy callback to hw_perf_event_destroy. On
the next init attempt after x86_pmu_event_init, in perf_try_init_event,
if the pmu's capabilities includes PERF_PMU_CAP_NO_EXCLUDE, the destroy
callback will be run. However, if the next init didn't set the destroy
callback, hw_perf_event_destroy will be run (since the callback wasn't
reset).

Looking at other pmu init functions, the common pattern is to only set
the destroy callback on a successful init. Resetting the callback on
failure tries to replicate that pattern.

This was discovered after commit f11dd0d80555 ("perf/x86/amd/ibs: Extend
PERF_PMU_CAP_NO_EXCLUDE to IBS Op") when the second (and only second)
run of the perf tool after a reboot results in 0 samples being
generated. The extra run of hw_perf_event_destroy results in
active_events having an extra decrement on each perf run. The second run
has active_events == 0 and every subsequent run has active_events < 0.
When active_events == 0, the NMI handler will early-out and not record
any samples.

Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210929170405.1.I078b98ee7727f9ae9d6df8262bad7e325e40faf0@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index c26cca506f64..c20df6a3540c 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2075,6 +2075,7 @@ static int x86_pmu_event_init(struct perf_event *event)
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
+		event->destroy = NULL;
 	}
 
 	if (ACCESS_ONCE(x86_pmu.attr_rdpmc))
-- 
2.33.0



