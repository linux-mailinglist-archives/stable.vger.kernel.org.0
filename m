Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2D50DF94
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbiDYMBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbiDYMBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:01:01 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE313B2B6
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1650887842;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=w/CzUiggY69ybKlJQExIUa1O78smxvVEI306N0hJisg=;
    b=J0JK/qorh9TIQw373rJBHUpKatfUb+BuoVBYRYKuGplzazh6bPC02jWCByQcCBe2Df
    A6k2BShmbJoYBaNhaYrf1e1AWDOpcKMOoGvHipSivN6fNzjFRbanX+C+83JMSJ7r6wly
    f5cGoyFw6t/rwV8J9AWdFl555U7+vVG31pcGKP2l5JpZuI6VvX9+0wbVZDpRfNKsNbqC
    G9u4/YoZCsO9dYBvh8hNMk2+3ZMI4goA3laEohLRnrD6J/xnRUWpL+2BE2PsRyEJhoHW
    93ymBxLwSypwa1x2PrhhQlnQkp89+kG3/JHEZPTfCQgQWUtLqTDmx4Y+gyKue5zcgBYj
    E8Ag==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9JCKNKiWJaRDy1ex1"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y3PBvLErL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 25 Apr 2022 13:57:21 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     stable@vger.kernel.org, sashal@kernel.org, mkl@pengutronix.de,
        gregkh@linuxfoundation.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Subject: [PATCH stable 5.10.y] can: isotp: stop timeout monitoring when no first frame was sent
Date:   Mon, 25 Apr 2022 13:57:01 +0200
Message-Id: <20220425115701.2197-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d73497081710c876c3c61444445512989e102152 ]

The first attempt to fix a the 'impossible' WARN_ON_ONCE(1) in
isotp_tx_timer_handler() focussed on the identical CAN IDs created by
the syzbot reproducer and lead to upstream fix/commit 3ea566422cbd
("can: isotp: sanitize CAN ID checks in isotp_bind()"). But this did
not catch the root cause of the wrong tx.state in the tx_timer handler.

In the isotp 'first frame' case a timeout monitoring needs to be started
before the 'first frame' is send. But when this sending failed the timeout
monitoring for this specific frame has to be disabled too.

Otherwise the tx_timer is fired with the 'warn me' tx.state of ISOTP_IDLE.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220405175112.2682-1-socketcan@hartkopp.net
Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9a4a9c5a9f24..c515bbd46c67 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -862,10 +862,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
 	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
 	int wait_tx_done = (so->opt.flags & CAN_ISOTP_WAIT_TX_DONE) ? 1 : 0;
+	s64 hrtimer_sec = 0;
 	int off;
 	int err;
 
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
@@ -960,11 +961,13 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* send first frame and wait for FC */
 
 		isotp_create_fframe(cf, so, ae);
 
 		/* start timeout for FC */
-		hrtimer_start(&so->txtimer, ktime_set(1, 0), HRTIMER_MODE_REL_SOFT);
+		hrtimer_sec = 1;
+		hrtimer_start(&so->txtimer, ktime_set(hrtimer_sec, 0),
+			      HRTIMER_MODE_REL_SOFT);
 	}
 
 	/* send the first or only CAN frame */
 	cf->flags = so->ll.tx_flags;
 
@@ -973,10 +976,15 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
 			       __func__, err);
+
+		/* no transmission -> no timeout monitoring */
+		if (hrtimer_sec)
+			hrtimer_cancel(&so->txtimer);
+
 		goto err_out_drop;
 	}
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
-- 
2.30.2

