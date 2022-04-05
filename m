Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24FC4F2BBA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbiDEKiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbiDEJeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5AC1E3E7;
        Tue,  5 Apr 2022 02:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1907FB81C85;
        Tue,  5 Apr 2022 09:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF3DC385A0;
        Tue,  5 Apr 2022 09:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150615;
        bh=RXKZzxAW6JC7G9kT+Rz0Ir7xpiPlO2yZfblmHPBNzVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ichW1k7JGV6J9BPBh3+Vjn3TTA1LImibx7+Y2aw9uJp1RHLnvyJ9wP/QXGIFW7pXF
         uLZG7WC/voE69QgiLs6EAawAmfQo5r6okNqRbbnlzFHPiQon6AAzKTvmm/4NyMJOrR
         XyqyFfNf694e0ynFhJQhWIPxvehcMEu8l+WLeqxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 117/913] tracing: Have trace event string test handle zero length strings
Date:   Tue,  5 Apr 2022 09:19:39 +0200
Message-Id: <20220405070343.333975706@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit eca344a7362e0f34f179298fd8366bcd556eede1 upstream.

If a trace event has in its TP_printk():

 "%*.s", len, len ? __get_str(string) : NULL

It is perfectly valid if len is zero and passing in the NULL.
Unfortunately, the runtime string check at time of reading the trace sees
the NULL and flags it as a bad string and produces a WARN_ON().

Handle this case by passing into the test function if the format has an
asterisk (star) and if so, if the length is zero, then mark it as safe.

Link: https://lore.kernel.org/all/YjsWzuw5FbWPrdqq@bfoster/

Cc: stable@vger.kernel.org
Reported-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Fixes: 9a6944fee68e2 ("tracing: Add a verifier to check string pointers for trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3678,12 +3678,17 @@ static char *trace_iter_expand_format(st
 }
 
 /* Returns true if the string is safe to dereference from an event */
-static bool trace_safe_str(struct trace_iterator *iter, const char *str)
+static bool trace_safe_str(struct trace_iterator *iter, const char *str,
+			   bool star, int len)
 {
 	unsigned long addr = (unsigned long)str;
 	struct trace_event *trace_event;
 	struct trace_event_call *event;
 
+	/* Ignore strings with no length */
+	if (star && !len)
+		return true;
+
 	/* OK if part of the event data */
 	if ((addr >= (unsigned long)iter->ent) &&
 	    (addr < (unsigned long)iter->ent + iter->ent_size))
@@ -3869,7 +3874,7 @@ void trace_check_vprintf(struct trace_it
 		 * instead. See samples/trace_events/trace-events-sample.h
 		 * for reference.
 		 */
-		if (WARN_ONCE(!trace_safe_str(iter, str),
+		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
 			      "fmt: '%s' current_buffer: '%s'",
 			      fmt, show_buffer(&iter->seq))) {
 			int ret;


