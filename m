Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50608681087
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbjA3OEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbjA3OEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16F083E0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE1C4B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1394C433D2;
        Mon, 30 Jan 2023 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087445;
        bh=KY68kq5j3nL8GNE6421Zc0EHMp1kw3Zoxn4yoxUAfqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qv6RMRP8jTykgovgMo4DdETOzjagsGzyG4xUmQMTDMnUb4x/V9Uce3rMg+8tBSGfp
         37YwRo70kbm3Sty8OSJzgn5whDVBPt03+7Y95U7GmncHyw5VXQv8xBJRVBbsEKBTAX
         u32BokUZYwoFxTh2i1LF5uoTEYFONvgLarBTsD38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florent Revest <revest@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.1 211/313] ftrace: Export ftrace_free_filter() to modules
Date:   Mon, 30 Jan 2023 14:50:46 +0100
Message-Id: <20230130134346.527186860@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 8be9fbd5345da52f4a74f7f81d55ff9fa0a2958e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c                       |   23 ++++++++++++++++++++++-
 samples/ftrace/ftrace-direct-multi-modify.c |    1 +
 samples/ftrace/ftrace-direct-multi.c        |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1248,12 +1248,17 @@ static void free_ftrace_hash_rcu(struct
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
@@ -5828,6 +5833,10 @@ EXPORT_SYMBOL_GPL(modify_ftrace_direct_m
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
@@ -5847,7 +5856,11 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
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
@@ -5889,6 +5902,10 @@ ftrace_set_regex(struct ftrace_ops *ops,
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
@@ -5908,6 +5925,10 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
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
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -149,6 +149,7 @@ static void __exit ftrace_direct_multi_e
 {
 	kthread_stop(simple_tsk);
 	unregister_ftrace_direct_multi(&direct, my_tramp);
+	ftrace_free_filter(&direct);
 }
 
 module_init(ftrace_direct_multi_init);
--- a/samples/ftrace/ftrace-direct-multi.c
+++ b/samples/ftrace/ftrace-direct-multi.c
@@ -77,6 +77,7 @@ static int __init ftrace_direct_multi_in
 static void __exit ftrace_direct_multi_exit(void)
 {
 	unregister_ftrace_direct_multi(&direct, (unsigned long) my_tramp);
+	ftrace_free_filter(&direct);
 }
 
 module_init(ftrace_direct_multi_init);


