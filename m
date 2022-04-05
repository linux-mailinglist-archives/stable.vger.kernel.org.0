Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB334F31A7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbiDEI4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241184AbiDEIcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B504917061;
        Tue,  5 Apr 2022 01:29:10 -0700 (PDT)
Date:   Tue, 05 Apr 2022 08:29:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649147349;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yt0rYyrwZxg63pG0971ROdocgPh4CTPB8CHSHPagIyA=;
        b=p6iXMl/rfQ/Y7vvlKS1VEXu5kSfghGKVsqKGvbZ7SWsX+xNbCMpYpgZwwjJo0RiruMxy9/
        Ih+UWOQ7YSjStiobddeOCMz9ptG1O9q9n5JpO/TplYdlZwORj/TC9gQXSPlko0Tnua529j
        DK40lhSnIz0MkVxcodS1eRJyBSWxlfy5YKqqRCqC/p2DMnPC6I5WRg9wF7MLY6Vl4zwnMm
        xE5e6uBFHxlzaySZrCKe46Q+kQQq+2ZKvr4th0WvLHJvga2UrqAtl2W/RlFZ0F8Cls7e7F
        jkAtO1jId0KsGYXAqOR/N3+ro8Miq2BFS1qhgT2PvZYtQ2bbyEADQ2gFg8Ya+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649147349;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yt0rYyrwZxg63pG0971ROdocgPh4CTPB8CHSHPagIyA=;
        b=6FeYv2OHDQblpguOMp8R9bMIFDZRgJYQRIHrzJM8UMLF2/SCDGcUcaSdbNobM2UoTz0JiU
        +oha2wS0j1IXC8AQ==
From:   "tip-bot2 for Namhyung Kim" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/core: Inherit event_caps
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220328200112.457740-1-namhyung@kernel.org>
References: <20220328200112.457740-1-namhyung@kernel.org>
MIME-Version: 1.0
Message-ID: <164914734824.389.11482584782909269521.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     e3265a4386428d3d157d9565bb520aabff8b4bf0
Gitweb:        https://git.kernel.org/tip/e3265a4386428d3d157d9565bb520aabff8b4bf0
Author:        Namhyung Kim <namhyung@kernel.org>
AuthorDate:    Mon, 28 Mar 2022 13:01:12 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 05 Apr 2022 09:59:44 +02:00

perf/core: Inherit event_caps

It was reported that some perf event setup can make fork failed on
ARM64.  It was the case of a group of mixed hw and sw events and it
failed in perf_event_init_task() due to armpmu_event_init().

The ARM PMU code checks if all the events in a group belong to the
same PMU except for software events.  But it didn't set the event_caps
of inherited events and no longer identify them as software events.
Therefore the test failed in a child process.

A simple reproducer is:

  $ perf stat -e '{cycles,cs,instructions}' perf bench sched messaging
  # Running 'sched/messaging' benchmark:
  perf: fork(): Invalid argument

The perf stat was fine but the perf bench failed in fork().  Let's
inherit the event caps from the parent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20220328200112.457740-1-namhyung@kernel.org
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cfde994..3980efc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11635,6 +11635,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (parent_event)
+		event->event_caps = parent_event->event_caps;
+
 	if (event->attr.sigtrap)
 		atomic_set(&event->event_limit, 1);
 
