Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6AE4ABA7F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383794AbiBGLXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240051AbiBGLN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:13:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7616DC043181;
        Mon,  7 Feb 2022 03:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06752611AA;
        Mon,  7 Feb 2022 11:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE1C004E1;
        Mon,  7 Feb 2022 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232434;
        bh=6Zh7jCNt9Cw8yt9T1v996Y2BQCPeVng+cR4IQ7nstWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aTTt4vaFeK73WruS9Q1fLVKVOcMFqCw2Nw7xCk8OEVaWsBvfCYj3v7Tqfm3KWHAG
         fxIky29XWMzqq8ghsQMyv4K2dcFMUTiwdgi9RFvBDY5+threSfA/gRGc+3bpc2xb9u
         YFatrxXApxys141rMNXTvyyxhYdMOrAGmp1KY8OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.14 46/69] audit: improve audit queue handling when "audit=1" on cmdline
Date:   Mon,  7 Feb 2022 12:06:08 +0100
Message-Id: <20220207103757.140200063@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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

From: Paul Moore <paul@paul-moore.com>

commit f26d04331360d42dbd6b58448bd98e4edbfbe1c5 upstream.

When an admin enables audit at early boot via the "audit=1" kernel
command line the audit queue behavior is slightly different; the
audit subsystem goes to greater lengths to avoid dropping records,
which unfortunately can result in problems when the audit daemon is
forcibly stopped for an extended period of time.

This patch makes a number of changes designed to improve the audit
queuing behavior so that leaving the audit daemon in a stopped state
for an extended period does not cause a significant impact to the
system.

- kauditd_send_queue() is now limited to looping through the
  passed queue only once per call.  This not only prevents the
  function from looping indefinitely when records are returned
  to the current queue, it also allows any recovery handling in
  kauditd_thread() to take place when kauditd_send_queue()
  returns.

- Transient netlink send errors seen as -EAGAIN now cause the
  record to be returned to the retry queue instead of going to
  the hold queue.  The intention of the hold queue is to store,
  perhaps for an extended period of time, the events which led
  up to the audit daemon going offline.  The retry queue remains
  a temporary queue intended to protect against transient issues
  between the kernel and the audit daemon.

- The retry queue is now limited by the audit_backlog_limit
  setting, the same as the other queues.  This allows admins
  to bound the size of all of the audit queues on the system.

- kauditd_rehold_skb() now returns records to the end of the
  hold queue to ensure ordering is preserved in the face of
  recent changes to kauditd_send_queue().

Cc: stable@vger.kernel.org
Fixes: 5b52330bbfe63 ("audit: fix auditd/kernel connection state tracking")
Fixes: f4b3ee3c85551 ("audit: improve robustness of the audit queue handling")
Reported-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Tested-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   62 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 19 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -509,20 +509,22 @@ static void kauditd_printk_skb(struct sk
 /**
  * kauditd_rehold_skb - Handle a audit record send failure in the hold queue
  * @skb: audit record
+ * @error: error code (unused)
  *
  * Description:
  * This should only be used by the kauditd_thread when it fails to flush the
  * hold queue.
  */
-static void kauditd_rehold_skb(struct sk_buff *skb)
+static void kauditd_rehold_skb(struct sk_buff *skb, __always_unused int error)
 {
-	/* put the record back in the queue at the same place */
-	skb_queue_head(&audit_hold_queue, skb);
+	/* put the record back in the queue */
+	skb_queue_tail(&audit_hold_queue, skb);
 }
 
 /**
  * kauditd_hold_skb - Queue an audit record, waiting for auditd
  * @skb: audit record
+ * @error: error code
  *
  * Description:
  * Queue the audit record, waiting for an instance of auditd.  When this
@@ -532,19 +534,31 @@ static void kauditd_rehold_skb(struct sk
  * and queue it, if we have room.  If we want to hold on to the record, but we
  * don't have room, record a record lost message.
  */
-static void kauditd_hold_skb(struct sk_buff *skb)
+static void kauditd_hold_skb(struct sk_buff *skb, int error)
 {
 	/* at this point it is uncertain if we will ever send this to auditd so
 	 * try to send the message via printk before we go any further */
 	kauditd_printk_skb(skb);
 
 	/* can we just silently drop the message? */
-	if (!audit_default) {
-		kfree_skb(skb);
-		return;
+	if (!audit_default)
+		goto drop;
+
+	/* the hold queue is only for when the daemon goes away completely,
+	 * not -EAGAIN failures; if we are in a -EAGAIN state requeue the
+	 * record on the retry queue unless it's full, in which case drop it
+	 */
+	if (error == -EAGAIN) {
+		if (!audit_backlog_limit ||
+		    skb_queue_len(&audit_retry_queue) < audit_backlog_limit) {
+			skb_queue_tail(&audit_retry_queue, skb);
+			return;
+		}
+		audit_log_lost("kauditd retry queue overflow");
+		goto drop;
 	}
 
-	/* if we have room, queue the message */
+	/* if we have room in the hold queue, queue the message */
 	if (!audit_backlog_limit ||
 	    skb_queue_len(&audit_hold_queue) < audit_backlog_limit) {
 		skb_queue_tail(&audit_hold_queue, skb);
@@ -553,24 +567,32 @@ static void kauditd_hold_skb(struct sk_b
 
 	/* we have no other options - drop the message */
 	audit_log_lost("kauditd hold queue overflow");
+drop:
 	kfree_skb(skb);
 }
 
 /**
  * kauditd_retry_skb - Queue an audit record, attempt to send again to auditd
  * @skb: audit record
+ * @error: error code (unused)
  *
  * Description:
  * Not as serious as kauditd_hold_skb() as we still have a connected auditd,
  * but for some reason we are having problems sending it audit records so
  * queue the given record and attempt to resend.
  */
-static void kauditd_retry_skb(struct sk_buff *skb)
+static void kauditd_retry_skb(struct sk_buff *skb, __always_unused int error)
 {
-	/* NOTE: because records should only live in the retry queue for a
-	 * short period of time, before either being sent or moved to the hold
-	 * queue, we don't currently enforce a limit on this queue */
-	skb_queue_tail(&audit_retry_queue, skb);
+	if (!audit_backlog_limit ||
+	    skb_queue_len(&audit_retry_queue) < audit_backlog_limit) {
+		skb_queue_tail(&audit_retry_queue, skb);
+		return;
+	}
+
+	/* we have to drop the record, send it via printk as a last effort */
+	kauditd_printk_skb(skb);
+	audit_log_lost("kauditd retry queue overflow");
+	kfree_skb(skb);
 }
 
 /**
@@ -608,7 +630,7 @@ static void auditd_reset(const struct au
 	/* flush the retry queue to the hold queue, but don't touch the main
 	 * queue since we need to process that normally for multicast */
 	while ((skb = skb_dequeue(&audit_retry_queue)))
-		kauditd_hold_skb(skb);
+		kauditd_hold_skb(skb, -ECONNREFUSED);
 }
 
 /**
@@ -682,16 +704,18 @@ static int kauditd_send_queue(struct soc
 			      struct sk_buff_head *queue,
 			      unsigned int retry_limit,
 			      void (*skb_hook)(struct sk_buff *skb),
-			      void (*err_hook)(struct sk_buff *skb))
+			      void (*err_hook)(struct sk_buff *skb, int error))
 {
 	int rc = 0;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
+	struct sk_buff *skb_tail;
 	unsigned int failed = 0;
 
 	/* NOTE: kauditd_thread takes care of all our locking, we just use
 	 *       the netlink info passed to us (e.g. sk and portid) */
 
-	while ((skb = skb_dequeue(queue))) {
+	skb_tail = skb_peek_tail(queue);
+	while ((skb != skb_tail) && (skb = skb_dequeue(queue))) {
 		/* call the skb_hook for each skb we touch */
 		if (skb_hook)
 			(*skb_hook)(skb);
@@ -699,7 +723,7 @@ static int kauditd_send_queue(struct soc
 		/* can we send to anyone via unicast? */
 		if (!sk) {
 			if (err_hook)
-				(*err_hook)(skb);
+				(*err_hook)(skb, -ECONNREFUSED);
 			continue;
 		}
 
@@ -713,7 +737,7 @@ retry:
 			    rc == -ECONNREFUSED || rc == -EPERM) {
 				sk = NULL;
 				if (err_hook)
-					(*err_hook)(skb);
+					(*err_hook)(skb, rc);
 				if (rc == -EAGAIN)
 					rc = 0;
 				/* continue to drain the queue */


