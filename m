Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09B945C1A1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347914AbhKXNUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346474AbhKXNSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7919F61AEC;
        Wed, 24 Nov 2021 12:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757951;
        bh=HecDkF34Wdtb0CxINO5Ah9QMCghEass5ttd/R0X9H/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtvwLYh4biKf82bQ+/8GEmAAkwPMBTrnRvjKKCUW0IyOW0/ZjKSBzj6qUXY+TU8Hd
         sAHWDy4VkYPVf5hC4hc9bDARSBmB+dvS21KVhZOwQf0wCyv3a99sXn1iu51DHqR+gc
         nAXJR22/h1U5NQnErSNKBF3ThURdk/EOsLkpBtzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paul Russel <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Pierre Gondois <pierre.gondois@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 301/323] perf bench: Fix two memory leaks detected with ASan
Date:   Wed, 24 Nov 2021 12:58:11 +0100
Message-Id: <20211124115729.082611705@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sohaib Mohamed <sohaib.amhmd@gmail.com>

[ Upstream commit 92723ea0f11d92496687db8c9725248e9d1e5e1d ]

ASan reports memory leaks while running:

  $ perf bench sched all

Fixes: e27454cc6352c422 ("perf bench: Add sched-messaging.c: Benchmark for scheduler and IPC mechanisms based on hackbench")
Signed-off-by: Sohaib Mohamed <sohaib.amhmd@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Russel <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Gondois <pierre.gondois@arm.com>
Link: http://lore.kernel.org/lkml/20211110022012.16620-1-sohaib.amhmd@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/sched-messaging.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index f9d7641ae8338..b4e13db991e9e 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -226,6 +226,8 @@ static unsigned int group(pthread_t *pth,
 		snd_ctx->out_fds[i] = fds[1];
 		if (!thread_mode)
 			close(fds[0]);
+
+		free(ctx);
 	}
 
 	/* Now we have all the fds, fork the senders */
@@ -242,6 +244,8 @@ static unsigned int group(pthread_t *pth,
 		for (i = 0; i < num_fds; i++)
 			close(snd_ctx->out_fds[i]);
 
+	free(snd_ctx);
+
 	/* Return number of children to reap */
 	return num_fds * 2;
 }
-- 
2.33.0



