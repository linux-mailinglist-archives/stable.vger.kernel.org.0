Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45363145610
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAVNUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbgAVNUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:08 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F7A2467E;
        Wed, 22 Jan 2020 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699207;
        bh=mI98QF2qNyJiueNKtM5Bbxqg45I7JeOH0vikwTQ5XLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXO1uHaYEzxIKpd7DjDmorHXZdLOwWmCOKJyXMXwM+6nVFpo4pARrLkJOOBQJHlwB
         A7P3NrSwfU/tnUCH4ZLXbO4xb+olkrqxMroBt3kF5ic6iNYnAaYRmXq4rpJK4Pc2WP
         rcXj4ut8N/SJfFfubyA/YM8T1ph4pCu5LDKHxsvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Mark Rutland <mark.rutland@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 5.4 037/222] perf: Correctly handle failed perf_get_aux_event()
Date:   Wed, 22 Jan 2020 10:27:03 +0100
Message-Id: <20200122092836.175504422@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit da9ec3d3dd0f1240a48920be063448a2242dbd90 upstream.

Vince reports a worrying issue:

| so I was tracking down some odd behavior in the perf_fuzzer which turns
| out to be because perf_even_open() sometimes returns 0 (indicating a file
| descriptor of 0) even though as far as I can tell stdin is still open.

... and further the cause:

| error is triggered if aux_sample_size has non-zero value.
|
| seems to be this line in kernel/events/core.c:
|
| if (perf_need_aux_event(event) && !perf_get_aux_event(event, group_leader))
|                goto err_locked;
|
| (note, err is never set)

This seems to be a thinko in commit:

  ab43762ef010967e ("perf: Allow normal events to output AUX data")

... and we should probably return -EINVAL here, as this should only
happen when the new event is mis-configured or does not have a
compatible aux_event group leader.

Fixes: ab43762ef010967e ("perf: Allow normal events to output AUX data")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11182,8 +11182,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	if (event->attr.aux_output && !perf_get_aux_event(event, group_leader))
+	if (event->attr.aux_output && !perf_get_aux_event(event, group_leader)) {
+		err = -EINVAL;
 		goto err_locked;
+	}
 
 	/*
 	 * Must be under the same ctx::mutex as perf_install_in_context(),


