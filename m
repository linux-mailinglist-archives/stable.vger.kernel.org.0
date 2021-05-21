Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FCF38C1E0
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 10:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhEUIdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 04:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhEUIdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 04:33:43 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0730C061574
        for <stable@vger.kernel.org>; Fri, 21 May 2021 01:32:20 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id s123-20020a3777810000b02902e9adec2313so15565593qkc.4
        for <stable@vger.kernel.org>; Fri, 21 May 2021 01:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eNYE7zpSOCj7plZZAyS+5aDrL5u+MfadoSDP0vm8/WQ=;
        b=XraWczXc5cxxOBDBtVGGfGFtPPc7wcCkrF3GfJOY2jod0PMBW5S0idtcykIynrztOj
         /8GPrUQbzqot1wTmeVWAetIzkEZC1/S5Vu+rB42C87I91OCbcj4/QLTjHI/aPfJDdCTP
         EKWcZBs9XSVgYlFXMB5dMLRsOVyVLy1EghdzRqGbvvRj7PdWjT2UdYdOPZixtq183drw
         ZFueMNvZ81RSFOJAehdyIKbW1168dtTXlz3Sfc+dU3I7Xj+0sk4N9kJkIhPwY56OJTjE
         0sotraP2uChwuL7Oo1h5ZZT6BV+qihPMQ9SFXO73vCLDONZnkh/H0+3yWIa8J4paZ8pA
         5BCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eNYE7zpSOCj7plZZAyS+5aDrL5u+MfadoSDP0vm8/WQ=;
        b=R4gwBAjNANaRw7uY6rBubOuRNjXFzgQG0QZLczf9glWnXe69pLBFvIjP7whzVii/Pm
         E5bk5T417tpuOeB06Qzsk7JweQYCp7pdNyfhFCfeqH6vyLHAz6y/l9tx9ZcIT4ofIJCw
         j+wNkx00Qs80iBFsD1SgtVZ1Uzg3ypumE17kD8cKGE6dyhdU3gTNeV6le6SauvN2rfNn
         H6VtP/K0X919JPaTK2+U6ejJ8cvStcnnt860cvm35LweeTm31Dj3aiD6lYEfDNZFVfJv
         OczTBKNE7xeNGOex5zpw5B+ECnqGSkBLcGQoH3IwnOweThfIL5euhwLTWWeOdKLHfppX
         XGXw==
X-Gm-Message-State: AOAM531s4U8UI6dt+NnrQSKSWjK5XpitMiaNyiQVLSbBVcAGJxRO1fbE
        70QLl3t/NcR6M57q1MEj15uSRRE2Mw==
X-Google-Smtp-Source: ABdhPJxOtHW/s436pbUSNtX/1MJ9ezmdnT2dciQSffLNozLx/dfNTPZEQC900wdnfyRocBsiRRPvt7cIHg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:a932:cdd6:7230:17ba])
 (user=elver job=sendgmr) by 2002:a0c:dc07:: with SMTP id s7mr11433864qvk.26.1621585939685;
 Fri, 21 May 2021 01:32:19 -0700 (PDT)
Date:   Fri, 21 May 2021 10:32:09 +0200
Message-Id: <20210521083209.3740269-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH] kfence: use TASK_IDLE when awaiting allocation
From:   Marco Elver <elver@google.com>
To:     elver@google.com, akpm@linux-foundation.org
Cc:     glider@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, Mel Gorman <mgorman@suse.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
allocation counts towards load. However, for KFENCE, this does not make
any sense, since there is no busy work we're awaiting.

Instead, use TASK_IDLE via wait_event_idle() to not count towards load.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1185565
Fixes: 407f1d8c1b5f ("kfence: await for allocation using wait_event")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org> # v5.12+
---
 mm/kfence/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index e18fbbd5d9b4..4d21ac44d5d3 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -627,10 +627,10 @@ static void toggle_allocation_gate(struct work_struct *work)
 		 * During low activity with no allocations we might wait a
 		 * while; let's avoid the hung task warning.
 		 */
-		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
-				   sysctl_hung_task_timeout_secs * HZ / 2);
+		wait_event_idle_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+					sysctl_hung_task_timeout_secs * HZ / 2);
 	} else {
-		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+		wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
 	}
 
 	/* Disable static key and reset timer. */
-- 
2.31.1.818.g46aad6cb9e-goog

