Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F54D85A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfFTSGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbfFTSGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:06:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72897215EA;
        Thu, 20 Jun 2019 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054004;
        bh=F11Hz1nTzzRwdTkLbRI4MhxUkydlb6D1ZSIkF2x/kfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvnzYeSzcPNJsv9szxF1Qgy6OKHQnz9tmE6DbNwQKnIbjC1FOIfRR5Prtj9a+zX9x
         Rrldcvhf3CXX7DxWFMic3Xgq9RrFwK9hkiwfQYU25t8OdXbdFWVvlxo3mmuf7bJcKQ
         bAspS0c/4VYTQOcHVih4yYrJarrz6oXZD0bWwIro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yabin Cui <yabinc@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, acme@kernel.org,
        mark.rutland@arm.com, namhyung@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 102/117] perf/ring_buffer: Add ordering to rb->nest increment
Date:   Thu, 20 Jun 2019 19:57:16 +0200
Message-Id: <20190620174357.883255703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3f9fbe9bd86c534eba2faf5d840fd44c6049f50e ]

Similar to how decrementing rb->next too early can cause data_head to
(temporarily) be observed to go backward, so too can this happen when
we increment too late.

This barrier() ensures the rb->head load happens after the increment,
both the one in the 'goto again' path, as the one from
perf_output_get_handle() -- albeit very unlikely to matter for the
latter.

Suggested-by: Yabin Cui <yabinc@google.com>
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
Cc: mark.rutland@arm.com
Cc: namhyung@kernel.org
Fixes: ef60777c9abd ("perf: Optimize the perf_output() path by removing IRQ-disables")
Link: http://lkml.kernel.org/r/20190517115418.309516009@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 524744a38d61..8e8b903b7613 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -49,6 +49,15 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	unsigned long head;
 
 again:
+	/*
+	 * In order to avoid publishing a head value that goes backwards,
+	 * we must ensure the load of @rb->head happens after we've
+	 * incremented @rb->nest.
+	 *
+	 * Otherwise we can observe a @rb->head value before one published
+	 * by an IRQ/NMI happening between the load and the increment.
+	 */
+	barrier();
 	head = local_read(&rb->head);
 
 	/*
-- 
2.20.1



