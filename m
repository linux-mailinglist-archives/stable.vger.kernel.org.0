Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5026B4683
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjCJOnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjCJOnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:43:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E043D00A0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:43:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5D3C61964
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DB2C4339E;
        Fri, 10 Mar 2023 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459405;
        bh=LHqLFl+/fOZFWWQJ3KlO5ul5w3jaKnYXlkH7sYD4U3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brNMGuX40U1J8BEPCU3ThiLlIjymUqJkBDUuNc+tq9hch1VDEf/2zu5Eifc18e8AN
         VpRocZgjExvdmjO+J9QCfi2a2w5XvSU/wBse46ZnikzivrhUx05wwypTg5bKfujOkt
         PrrQ0ZJtmuvlyqtcwjyRtQF5U8Cq5IOq3RfJhVrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 349/357] net: tls: avoid hanging tasks on the tx_lock
Date:   Fri, 10 Mar 2023 14:40:38 +0100
Message-Id: <20230310133750.073720437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
@@ -945,7 +945,9 @@ int tls_sw_sendmsg(struct sock *sk, stru
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1279,7 +1281,9 @@ int tls_sw_sendpage(struct sock *sk, str
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2263,11 +2267,19 @@ static void tx_work_handler(struct work_
 
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
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)


