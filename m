Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929CD31BC7A
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhBOP3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhBOP3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:29:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367A964E2B;
        Mon, 15 Feb 2021 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402901;
        bh=6yuLQfKCxjTdRHYxMmL79Y3/tAINkncO7tbnWmd029M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFuWb53uuROrdr/NamtnAKNRfceIpXJeOSzK65D8tTnFMC5TihnnIovCD0hcjSULn
         cA6bOelbRD5kSKswhJqkB6o5x0jGS/cYX7CUmhlCzLjSc+xKUWXks6CBxpz7ahLKe+
         TDQPuAAtDCQZ57CcQX5rfByU88qR1q4fTy/QSnvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 04/60] tracing: Check length before giving out the filter buffer
Date:   Mon, 15 Feb 2021 16:26:52 +0100
Message-Id: <20210215152715.533974775@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit b220c049d5196dd94d992dd2dc8cba1a5e6123bf upstream.

When filters are used by trace events, a page is allocated on each CPU and
used to copy the trace event fields to this page before writing to the ring
buffer. The reason to use the filter and not write directly into the ring
buffer is because a filter may discard the event and there's more overhead
on discarding from the ring buffer than the extra copy.

The problem here is that there is no check against the size being allocated
when using this page. If an event asks for more than a page size while being
filtered, it will get only a page, leading to the caller writing more that
what was allocated.

Check the length of the request, and if it is more than PAGE_SIZE minus the
header default back to allocating from the ring buffer directly. The ring
buffer may reject the event if its too big anyway, but it wont overflow.

Link: https://lore.kernel.org/ath10k/1612839593-2308-1-git-send-email-wgong@codeaurora.org/

Cc: stable@vger.kernel.org
Fixes: 0fc1b09ff1ff4 ("tracing: Use temp buffer when filtering events")
Reported-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2498,7 +2498,7 @@ trace_event_buffer_lock_reserve(struct r
 	    (entry = this_cpu_read(trace_buffered_event))) {
 		/* Try to use the per cpu buffer first */
 		val = this_cpu_inc_return(trace_buffered_event_cnt);
-		if (val == 1) {
+		if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
 			trace_event_setup(entry, type, flags, pc);
 			entry->array[0] = len;
 			return entry;


