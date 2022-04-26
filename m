Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E79D50F67C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiDZIz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347236AbiDZIvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC13158F45;
        Tue, 26 Apr 2022 01:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C46E60C35;
        Tue, 26 Apr 2022 08:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16355C385A0;
        Tue, 26 Apr 2022 08:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962396;
        bh=EOw5hbKDTnYGfUcDibtjJA+xhAnCFPcdHRjqYVUw9Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDHReWnlzL5qY0lyPxdbsRYQFSqZBa/UMQ6ThLlssWlILesVO6I6ZuMqOkfsRSyJJ
         5hZwAvekon9Le0CjUcFIbiHyxd59EYr0ijsMb33c2RLp1mlvfnNAZrWoZyIhK8DRMs
         h6ymvxRifmVbx+kB0VS0A9i60S9usc7ILgIYgk38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/124] can: isotp: stop timeout monitoring when no first frame was sent
Date:   Tue, 26 Apr 2022 10:20:43 +0200
Message-Id: <20220426081748.498664094@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 5bce7c66c121..8c753dcefe7f 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -866,6 +866,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct canfd_frame *cf;
 	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
 	int wait_tx_done = (so->opt.flags & CAN_ISOTP_WAIT_TX_DONE) ? 1 : 0;
+	s64 hrtimer_sec = 0;
 	int off;
 	int err;
 
@@ -964,7 +965,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		isotp_create_fframe(cf, so, ae);
 
 		/* start timeout for FC */
-		hrtimer_start(&so->txtimer, ktime_set(1, 0), HRTIMER_MODE_REL_SOFT);
+		hrtimer_sec = 1;
+		hrtimer_start(&so->txtimer, ktime_set(hrtimer_sec, 0),
+			      HRTIMER_MODE_REL_SOFT);
 	}
 
 	/* send the first or only CAN frame */
@@ -977,6 +980,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
+
+		/* no transmission -> no timeout monitoring */
+		if (hrtimer_sec)
+			hrtimer_cancel(&so->txtimer);
+
 		goto err_out_drop;
 	}
 
-- 
2.35.1



