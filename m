Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793C53C4C01
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbhGLHBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242241AbhGLG74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EE56102A;
        Mon, 12 Jul 2021 06:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073027;
        bh=BeB+0SJu7eQWjDDNzQut1WWX6Ive+aysT5ziMqnmH+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWATJ8Ej1awGf10Dt5XBLWijK7GtdDEBhCjJp2YAr3l4/ozMyGDfF81LwDL7dxNyc
         QJnX32OyMUioRUYZ4LAEp2dDFFiaiNSxLe+z4d/QBmtddO2MZvd37XYGmp1aCxmBRW
         U0qe73uLYW+SVs9BU3FIRofOHmiGPqFz5WZMPV98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.12 102/700] tracing/histograms: Fix parsing of "sym-offset" modifier
Date:   Mon, 12 Jul 2021 08:03:05 +0200
Message-Id: <20210712060939.233766621@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 26c563731056c3ee66f91106c3078a8c36bb7a9e upstream.

With the addition of simple mathematical operations (plus and minus), the
parsing of the "sym-offset" modifier broke, as it took the '-' part of the
"sym-offset" as a minus, and tried to break it up into a mathematical
operation of "field.sym - offset", in which case it failed to parse
(unless the event had a field called "offset").

Both .sym and .sym-offset modifiers should not be entered into
mathematical calculations anyway. If ".sym-offset" is found in the
modifier, then simply make it not an operation that can be calculated on.

Link: https://lkml.kernel.org/r/20210707110821.188ae255@oasis.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1539,6 +1539,13 @@ static int contains_operator(char *str)
 
 	switch (*op) {
 	case '-':
+		/*
+		 * Unfortunately, the modifier ".sym-offset"
+		 * can confuse things.
+		 */
+		if (op - str >= 4 && !strncmp(op - 4, ".sym-offset", 11))
+			return FIELD_OP_NONE;
+
 		if (*str == '-')
 			field_op = FIELD_OP_UNARY_MINUS;
 		else


