Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE76B6B4374
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjCJOOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjCJOO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE2D22108
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E7861959
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999DAC4339C;
        Fri, 10 Mar 2023 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457550;
        bh=7++CaNJPou4HECccnvXg20nu6jpxpsYURDpEWgDM21k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voVsr2QxitbTTg7OJ5vzqF4+otOt6BYjf0rLltAIw0RjSJzVtkBAGq+YtTMCjxSDj
         OVQY22IbG3h9tBK41arFE5NzOJo0Nv2D2uikjPAWTLpcDWwgAeH4CaJG9vO9HB1Tnq
         g9raTOjghFFqHFChzR5oOlW3Hjl+PII1yBc5MK24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 176/200] net: tls: avoid hanging tasks on the tx_lock
Date:   Fri, 10 Mar 2023 14:39:43 +0100
Message-Id: <20230310133722.510394675@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit f3221361dc85d4de22586ce8441ec2c67b454f5d upstream.

syzbot sent a hung task report and Eric explains that adversarial
receiver may keep RWIN at 0 for a long time, so we are not guaranteed
to make forward progress. Thread which took tx_lock and went to sleep
may not release tx_lock for hours. Use interruptible sleep where
possible and reschedule the work if it can't take the lock.

Testing: existing selftest passes

Reported-by: syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com
Fixes: 79ffe6087e91 ("net/tls: add a TX lock")
Link: https://lore.kernel.org/all/000000000000e412e905f5b46201@google.com/
Cc: stable@vger.kernel.org # wait 4 weeks
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230301002857.2101894-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -941,7 +941,9 @@ int tls_sw_sendmsg(struct sock *sk, stru
 			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1275,7 +1277,9 @@ int tls_sw_sendpage(struct sock *sk, str
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2416,11 +2420,19 @@ static void tx_work_handler(struct work_
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
-	mutex_lock(&tls_ctx->tx_lock);
-	lock_sock(sk);
-	tls_tx_records(sk, -1);
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
+
+	if (mutex_trylock(&tls_ctx->tx_lock)) {
+		lock_sock(sk);
+		tls_tx_records(sk, -1);
+		release_sock(sk);
+		mutex_unlock(&tls_ctx->tx_lock);
+	} else if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		/* Someone is holding the tx_lock, they will likely run Tx
+		 * and cancel the work on their way out of the lock section.
+		 * Schedule a long delay just in case.
+		 */
+		schedule_delayed_work(&ctx->tx_work.work, msecs_to_jiffies(10));
+	}
 }
 
 static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)


