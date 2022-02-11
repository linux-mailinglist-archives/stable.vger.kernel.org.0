Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB04B2DE6
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 20:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiBKTmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 14:42:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiBKTmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 14:42:00 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10888CF2;
        Fri, 11 Feb 2022 11:41:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m7so9036793pjk.0;
        Fri, 11 Feb 2022 11:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+cjV6VQYX+d59JLPpChlUzZYjREnzQzFbJcMJN9aOq4=;
        b=SSiYc7pCMqUBPqd8ADwJl4ymjozJTgjDO3Ol7hc1Yi90208kSsLNId7A4kMJClbMsl
         Cs9uTGFs+O1ltrgsT5ajpeNjXLW7lYUDlr/SHsGky7aXF0En73TJRCJVORx7EhZTSIoM
         93sQnoGk4dql/VjZojdQSDW1zlIGeFCeR1umTv/2sG5Hz3dDF0oZrqN/pOugpAlZSzpl
         iuKrkY4bQwGgsXHbieuVdTTNQ1rAGlyZav1eSXjiCruqoHn02GiCuUpRsLx/q2pEOv3y
         XkdOsaLzAx/xlKIj1d6IBBmBKrBBVWGlfAlmi8JV/c5SLn6a/QEhRt0da/fYKN+x7xEW
         kIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=+cjV6VQYX+d59JLPpChlUzZYjREnzQzFbJcMJN9aOq4=;
        b=Yl6d4EdWg3FZw1YssSg9/8FsBTd0Q0pM4FJOmfDSwFsI6yt51dLJp4PJ8zvByBrom5
         jo8igyna0i8P2w9pF9PU3FmtjtIqOu2IU20CBgT7xWDy0xs/Um/i7Cmbp/iZbkTdjvt7
         l+AsrhJ4rGKhE5hToDJkgJw25m4fsOxGV5zdV9El/QN3/JR5xB7tt/VGy4XemPfLruos
         HK4dvkBAEX95tP9xrZ9VdHRqR69XF6S1ZMl75R97nmai4DNV4dWKzK2oQNlLUDPJTx/2
         p2ymgx7eKadKIh5VfW5PHZqrRFqzoYeXIXF5zqHVSfcEsla3x/q5rAqgr6zq7TPaXAt1
         IyQQ==
X-Gm-Message-State: AOAM5309snDBhXqNfZGY4vdmQ/anNpDahykrbLWf+dyBVOyBUj/51Prx
        RBDbIKJa31yjv0oo8/jMNP1ckFQ6KEU=
X-Google-Smtp-Source: ABdhPJxgSwDkHruWnmDEgpLzerUwPS2Hff9cpSKJXXZBe791FYvUinFnpa3EOUTZemcnhl0EczvqNQ==
X-Received: by 2002:a17:90a:b947:: with SMTP id f7mr1959333pjw.184.1644608517350;
        Fri, 11 Feb 2022 11:41:57 -0800 (PST)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:c6f0:60f1:ae6e:dd81:b215])
        by smtp.gmail.com with ESMTPSA id l8sm29861919pfc.187.2022.02.11.11.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 11:41:56 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] perf/core: Inherit event_caps
Date:   Fri, 11 Feb 2022 11:41:54 -0800
Message-Id: <20220211194154.667364-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It was reported that some perf event setup can make fork failed on
ARM64.  It was the case of a group of mixed hw and sw events.  The ARM
PMU code checks if all the events in a group belong to the same PMU
except for software events.  But it didn't set the event_caps of
inherited events and no longer identify them as software events.
Therefore the test failed in a child process.

A simple reproducer is:

  $ perf stat -e '{cycles,cs,instructions}' perf bench sched messaging
  # Running 'sched/messaging' benchmark:
  perf: fork(): Invalid argument

The perf stat was fine but the perf bench failed in fork().  Let's
inherit the event caps from the parent.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fc18664f49b0..e28f63ae625b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11560,6 +11560,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (parent_event)
+		event->event_caps = parent_event->event_caps;
+
 	if (event->attr.sigtrap)
 		atomic_set(&event->event_limit, 1);
 
-- 
2.35.1.265.g69c8d7142f-goog

