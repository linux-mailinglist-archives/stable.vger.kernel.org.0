Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E2631BD05
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhBOPib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhBOPhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE7C64ED5;
        Mon, 15 Feb 2021 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403134;
        bh=B2+njAu7HXxy173oh3IuliD7A7sOtkSwyFofMx7hxM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkbGEKjP5B/BczNR4gsq26dGD2JLUN/Dps+42aqH5ykNcUsWqBYOZoFywvbwYkJ3+
         6MraiyRbU0wlg9cqJ4CV6s4KyES5+YvCaC8YuGeHS3f8RBw6GIsFRQHkf5OL5tGnEO
         dtaKB3Egy57OFAVbCX1ElCzWSdqiyYa6jJT1zd04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 007/104] tracing: Check length before giving out the filter buffer
Date:   Mon, 15 Feb 2021 16:26:20 +0100
Message-Id: <20210215152719.706148336@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
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
@@ -2745,7 +2745,7 @@ trace_event_buffer_lock_reserve(struct t
 	    (entry = this_cpu_read(trace_buffered_event))) {
 		/* Try to use the per cpu buffer first */
 		val = this_cpu_inc_return(trace_buffered_event_cnt);
-		if (val == 1) {
+		if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
 			trace_event_setup(entry, type, flags, pc);
 			entry->array[0] = len;
 			return entry;


