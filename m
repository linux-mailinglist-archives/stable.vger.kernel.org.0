Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42134EA115
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 22:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344342AbiC1UDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 16:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344360AbiC1UD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 16:03:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710A8606E6;
        Mon, 28 Mar 2022 13:01:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f3so12524922pfe.2;
        Mon, 28 Mar 2022 13:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sQyhxEzUWIyxRjjg8L7Lh+/O9puSstM9ZBT2nODvDM8=;
        b=Pj5bCkeJuECKqhaYv7MLPiKsoFTr2mY8M6T2r4tIX8kMs9VI4OTPPqnQS8ItAC/X+v
         JS2cAyc6ot4bkmrBYGdTEOE3hvAPdCBmljIv+WjN58exJOU7S/vItRDX8SzuW26Gcc8r
         H/WazkEvf0+Yda4WqITlq1dwUpiYlc5vZX9wIA2Iaz6xHPZed5GfkdGr/w7DX4HoJx56
         zyQdGvsY8mKXB7OHa98jV4liUnfU4gjVRioIPAOWj0ho9ePqwrKzRfHUoIunYEhQ1zr1
         ro6rL0lJZSuzv83v1IByOpHa/KGVFbCAeExF68cWgzs+6y56W3sd/YVGycHuFXpNwQeT
         Pz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=sQyhxEzUWIyxRjjg8L7Lh+/O9puSstM9ZBT2nODvDM8=;
        b=4yGutv4ouzruCH6xp0m7zP3IrO7jaxzwJPQ77OAL6wUCiaZzQxY5KhbF4HMenJgFTn
         j0MPqlo2nFITq16LT8aEbdTurDhmv5PWc7r9wFFeiE7THfry6be3nSsCU5yQxSiQsO3S
         ID2gR9zkW3ryCx5VXv+mEDg0q/B0tWMzaJ6814RMlzegmN5DOPk8O1W0ndrbPcQ/j52R
         FJdrm9Hd3pBjKaCjdxu8prRUGMBeaYTy+0Qg/oO3LgUdjqEvpro7ne3cf7Mjiq7AsUQ7
         RKqoy8QgLXDt24cNZikKGoqY7Ttfhle0wi0xt4taxRkPre6jhchvqkRUvVDGGLBZBqRz
         8niA==
X-Gm-Message-State: AOAM531hmjQo5cZWukQGv3sb7DkkBB8D3gxvDO0LFi8ANCRnz2Iw6J0q
        tnVaergTzJg1kJdOX0kuB7g=
X-Google-Smtp-Source: ABdhPJyl6oAzJo8o+XdN7d4vMQZwBOh7huIYno8GPmdM+kaVhV9cocYe3/sLHhj9Rb+W9FsrJ+UBVw==
X-Received: by 2002:a63:2b4f:0:b0:398:49ba:a268 with SMTP id r76-20020a632b4f000000b0039849baa268mr5431697pgr.546.1648497674845;
        Mon, 28 Mar 2022 13:01:14 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:3540:a644:d4e5:cd1:b3b9])
        by smtp.gmail.com with ESMTPSA id mq6-20020a17090b380600b001c6357f146csm334428pjb.12.2022.03.28.13.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:01:14 -0700 (PDT)
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
        Marco Elver <elver@google.com>, stable@vger.kernel.org
Subject: [PATCH RESEND] perf/core: Inherit event_caps
Date:   Mon, 28 Mar 2022 13:01:12 -0700
Message-Id: <20220328200112.457740-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
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

Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index afbf388a5176..5baf7f981f23 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11622,6 +11622,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (parent_event)
+		event->event_caps = parent_event->event_caps;
+
 	if (event->attr.sigtrap)
 		atomic_set(&event->event_limit, 1);
 
-- 
2.35.1.1021.g381101b075-goog

