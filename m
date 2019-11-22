Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59CC1078FD
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVTyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbfKVTtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C3C20726;
        Fri, 22 Nov 2019 19:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452153;
        bh=zwqM+wS2Wryn1l8lu7xVA8FqBKoSghxz/FEIeQeJyFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u95+oyOWgbSqfe7EAksSSYfkWY1q82kesVP/oDye4SDkOvpjSPD9FWHI3mMILeovo
         zPrCthWJYr9yBQgIvbDFZY8VwAcorpHrr74h3OMEUUkcNG4a7GiaGYj6WjvRaaRqp2
         JvpqiTj6UsO1PnWRpV5v4NdZBvviMWVuZRBYr91s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 11/25] perf/core: Consistently fail fork on allocation failures
Date:   Fri, 22 Nov 2019 14:48:44 -0500
Message-Id: <20191122194859.24508-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit 697d877849d4b34ab58d7078d6930bad0ef6fc66 ]

Commit:

  313ccb9615948 ("perf: Allocate context task_ctx_data for child event")

makes the inherit path skip over the current event in case of task_ctx_data
allocation failure. This, however, is inconsistent with allocation failures
in perf_event_alloc(), which would abort the fork.

Correct this by returning an error code on task_ctx_data allocation
failure and failing the fork in that case.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lkml.kernel.org/r/20191105075702.60319-1-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 625ba462e5bbd..460d5fd3ec4e4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11377,7 +11377,7 @@ inherit_event(struct perf_event *parent_event,
 						   GFP_KERNEL);
 		if (!child_ctx->task_ctx_data) {
 			free_event(child_event);
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 		}
 	}
 
-- 
2.20.1

