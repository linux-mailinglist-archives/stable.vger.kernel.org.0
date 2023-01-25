Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F4667B6BB
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbjAYQUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 11:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbjAYQUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 11:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1958F16AD7;
        Wed, 25 Jan 2023 08:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F2BE61216;
        Wed, 25 Jan 2023 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A35FC433EF;
        Wed, 25 Jan 2023 16:20:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pKiVN-004Mpy-3D;
        Wed, 25 Jan 2023 11:20:10 -0500
Message-ID: <20230125162009.813204292@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 25 Jan 2023 11:18:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Florent Revest <revest@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [for-linus][PATCH 01/11] ftrace: Export ftrace_free_filter() to modules
References: <20230125161824.332648375@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Setting filters on an ftrace ops results in some memory being allocated
for the filter hashes, which must be freed before the ops can be freed.
This can be done by removing every individual element of the hash by
calling ftrace_set_filter_ip() or ftrace_set_filter_ips() with `remove`
set, but this is somewhat error prone as it's easy to forget to remove
an element.

Make it easier to clean this up by exporting ftrace_free_filter(), which
can be used to clean up all of the filter hashes after an ftrace_ops has
been unregistered.

Using this, fix the ftrace-direct* samples to free hashes prior to being
unloaded. All other code either removes individual filters explicitly or
is built-in and already calls ftrace_free_filter().

Link: https://lkml.kernel.org/r/20230103124912.2948963-3-mark.rutland@arm.com

Cc: stable@vger.kernel.org
Cc: Florent Revest <revest@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: e1067a07cfbc ("ftrace/samples: Add module to test multi direct modify interface")
Fixes: 5fae941b9a6f ("ftrace/samples: Add multi direct interface test module")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                       | 23 ++++++++++++++++++++-
 samples/ftrace/ftrace-direct-multi-modify.c |  1 +
 samples/ftrace/ftrace-direct-multi.c        |  1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 442438b93fe9..750aa3f08b25 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1248,12 +1248,17 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
 	call_rcu(&hash->rcu, __free_ftrace_hash_rcu);
 }
 
+/**
+ * ftrace_free_filter - remove all filters for an ftrace_ops
+ * @ops - the ops to remove the filters from
+ */
 void ftrace_free_filter(struct ftrace_ops *ops)
 {
 	ftrace_ops_init(ops);
 	free_ftrace_hash(ops->func_hash->filter_hash);
 	free_ftrace_hash(ops->func_hash->notrace_hash);
 }
+EXPORT_SYMBOL_GPL(ftrace_free_filter);
 
 static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
 {
@@ -5839,6 +5844,10 @@ EXPORT_SYMBOL_GPL(modify_ftrace_direct_multi);
  *
  * Filters denote which functions should be enabled when tracing is enabled
  * If @ip is NULL, it fails to update filter.
+ *
+ * This can allocate memory which must be freed before @ops can be freed,
+ * either by removing each filtered addr or by using
+ * ftrace_free_filter(@ops).
  */
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset)
@@ -5858,7 +5867,11 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
  *
  * Filters denote which functions should be enabled when tracing is enabled
  * If @ips array or any ip specified within is NULL , it fails to update filter.
- */
+ *
+ * This can allocate memory which must be freed before @ops can be freed,
+ * either by removing each filtered addr or by using
+ * ftrace_free_filter(@ops).
+*/
 int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
 			  unsigned int cnt, int remove, int reset)
 {
@@ -5900,6 +5913,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
  *
  * Filters denote which functions should be enabled when tracing is enabled.
  * If @buf is NULL and reset is set, all functions will be enabled for tracing.
+ *
+ * This can allocate memory which must be freed before @ops can be freed,
+ * either by removing each filtered addr or by using
+ * ftrace_free_filter(@ops).
  */
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
@@ -5919,6 +5936,10 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
  * Notrace Filters denote which functions should not be enabled when tracing
  * is enabled. If @buf is NULL and reset is set, all functions will be enabled
  * for tracing.
+ *
+ * This can allocate memory which must be freed before @ops can be freed,
+ * either by removing each filtered addr or by using
+ * ftrace_free_filter(@ops).
  */
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
diff --git a/samples/ftrace/ftrace-direct-multi-modify.c b/samples/ftrace/ftrace-direct-multi-modify.c
index d52370cad0b6..a825dbd2c9cf 100644
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -152,6 +152,7 @@ static void __exit ftrace_direct_multi_exit(void)
 {
 	kthread_stop(simple_tsk);
 	unregister_ftrace_direct_multi(&direct, my_tramp);
+	ftrace_free_filter(&direct);
 }
 
 module_init(ftrace_direct_multi_init);
diff --git a/samples/ftrace/ftrace-direct-multi.c b/samples/ftrace/ftrace-direct-multi.c
index ec1088922517..d955a2650605 100644
--- a/samples/ftrace/ftrace-direct-multi.c
+++ b/samples/ftrace/ftrace-direct-multi.c
@@ -79,6 +79,7 @@ static int __init ftrace_direct_multi_init(void)
 static void __exit ftrace_direct_multi_exit(void)
 {
 	unregister_ftrace_direct_multi(&direct, (unsigned long) my_tramp);
+	ftrace_free_filter(&direct);
 }
 
 module_init(ftrace_direct_multi_init);
-- 
2.39.0
