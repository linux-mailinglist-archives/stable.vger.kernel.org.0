Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A7314B92E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbgA1O2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732471AbgA1O22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD08D207FD;
        Tue, 28 Jan 2020 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221708;
        bh=QcOGFUpY3hWY8zDwR2VWP52YZ7ia1a6l2UUSsYDmnYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHLqLt8UEP0237WfwXoRgxwvo0NeeLpSYauBRkbnCZU0zdcXM68UwufLoDBtfIfIH
         3Dfsgzz/lE9cKvps8xSTTAug520ymhaUgDMfelyiXNPEVrzpukR4CkhIbFC2Q79AOT
         gCRs2DE7cEuOklaOsEiQFaZzZg9TFmV197fujPa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 42/92] tracing: xen: Ordered comparison of function pointers
Date:   Tue, 28 Jan 2020 15:08:10 +0100
Message-Id: <20200128135814.453420288@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

commit d0695e2351102affd8efae83989056bc4b275917 upstream.

Just as commit 0566e40ce7 ("tracing: initcall: Ordered comparison of
function pointers"), this patch fixes another remaining one in xen.h
found by clang-9.

In file included from arch/x86/xen/trace.c:21:
In file included from ./include/trace/events/xen.h:475:
In file included from ./include/trace/define_trace.h:102:
In file included from ./include/trace/trace_events.h:473:
./include/trace/events/xen.h:69:7: warning: ordered comparison of function \
pointers ('xen_mc_callback_fn_t' (aka 'void (*)(void *)') and 'xen_mc_callback_fn_t') [-Wordered-compare-function-pointers]
                    __field(xen_mc_callback_fn_t, fn)
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:421:29: note: expanded from macro '__field'
                                ^
./include/trace/trace_events.h:407:6: note: expanded from macro '__field_ext'
                                 is_signed_type(type), filter_type);    \
                                 ^
./include/linux/trace_events.h:554:44: note: expanded from macro 'is_signed_type'
                                              ^

Fixes: c796f213a6934 ("xen/trace: add multicall tracing")
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/xen.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -66,7 +66,11 @@ TRACE_EVENT(xen_mc_callback,
 	    TP_PROTO(xen_mc_callback_fn_t fn, void *data),
 	    TP_ARGS(fn, data),
 	    TP_STRUCT__entry(
-		    __field(xen_mc_callback_fn_t, fn)
+		    /*
+		     * Use field_struct to avoid is_signed_type()
+		     * comparison of a function pointer.
+		     */
+		    __field_struct(xen_mc_callback_fn_t, fn)
 		    __field(void *, data)
 		    ),
 	    TP_fast_assign(


