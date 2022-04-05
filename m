Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0E4F25A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiDEHuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiDEHrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8628E18348;
        Tue,  5 Apr 2022 00:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB703616C4;
        Tue,  5 Apr 2022 07:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1829C34110;
        Tue,  5 Apr 2022 07:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144637;
        bh=Vzkuek3OGudFGGEQmXnCuyUEkLDe9dutJWVZUZbctRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN6XLtaoKoIX5H8zgkENG5dD9EpMjuAirJVrm1kgcfKPvRtc+wlfIt4f2SDjjABXB
         OXDaQXtY/OdM+260gA7mtftMcJ9/lIYhNkCHcFdVLp4C7H5IJGqHin29XnxL2ARaat
         RUhtXbA69jycG2Avp7S/CWTWSfGIwcsrHAyMVmZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.17 0116/1126] tracing: Have trace event string test handle zero length strings
Date:   Tue,  5 Apr 2022 09:14:23 +0200
Message-Id: <20220405070410.976791998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -3663,12 +3663,17 @@ static char *trace_iter_expand_format(st
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
@@ -3854,7 +3859,7 @@ void trace_check_vprintf(struct trace_it
 		 * instead. See samples/trace_events/trace-events-sample.h
 		 * for reference.
 		 */
-		if (WARN_ONCE(!trace_safe_str(iter, str),
+		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
 			      "fmt: '%s' current_buffer: '%s'",
 			      fmt, show_buffer(&iter->seq))) {
 			int ret;


