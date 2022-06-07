Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA254229B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiFHBy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390383AbiFHBuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:50:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4F11973DA;
        Tue,  7 Jun 2022 12:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0389CE24B7;
        Tue,  7 Jun 2022 19:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7331C385A5;
        Tue,  7 Jun 2022 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629602;
        bh=OZOS/pHplCASWNPmT8U8e9P9qYz6jNCQYk6G30jMRTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cl1pK9eSMuqrJ9/hHtniglVrs+VhLlYKsMZcy0QJVHiWDy1OBbVRNMEdYjse0CWoa
         gmFdN1e8V9V47y5PKgIra01+YYfKmCkYRaU7PGq4jtDHj8NFr/yUX69ffQ7uslch79
         mroeGuyIXioPgk+/7Srm5lSOA1tsooMfUBhVXBz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.18 749/879] tracing: Have event format check not flag %p* on __get_dynamic_array()
Date:   Tue,  7 Jun 2022 19:04:27 +0200
Message-Id: <20220607165024.602410761@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 499f12168aebd6da8fa32c9b7d6203ca9b5eb88d upstream.

The print fmt check against trace events to make sure that the format does
not use pointers that may be freed from the time of the trace to the time
the event is read, gives a false positive on %pISpc when reading data that
was saved in __get_dynamic_array() when it is perfectly fine to do so, as
the data being read is on the ring buffer.

Link: https://lore.kernel.org/all/20220407144524.2a592ed6@canb.auug.org.au/

Cc: stable@vger.kernel.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -392,12 +392,6 @@ static void test_event_printk(struct tra
 			if (!(dereference_flags & (1ULL << arg)))
 				goto next_arg;
 
-			/* Check for __get_sockaddr */;
-			if (str_has_prefix(fmt + i, "__get_sockaddr(")) {
-				dereference_flags &= ~(1ULL << arg);
-				goto next_arg;
-			}
-
 			/* Find the REC-> in the argument */
 			c = strchr(fmt + i, ',');
 			r = strstr(fmt + i, "REC->");
@@ -413,7 +407,14 @@ static void test_event_printk(struct tra
 				a = strchr(fmt + i, '&');
 				if ((a && (a < r)) || test_field(r, call))
 					dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_dynamic_array(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_sockaddr(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
 			}
+
 		next_arg:
 			i--;
 			arg++;


