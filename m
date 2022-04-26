Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B0E50F85E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbiDZJHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347093AbiDZJFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD9F698F;
        Tue, 26 Apr 2022 01:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB789B81A2F;
        Tue, 26 Apr 2022 08:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230A7C385AC;
        Tue, 26 Apr 2022 08:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962642;
        bh=EOw5hbKDTnYGfUcDibtjJA+xhAnCFPcdHRjqYVUw9Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/Gen5IjQcz+VlWjh/mcWrehWwBK/pKIm0O6XQRzdLA1vGsbktkjSCW0MTrpQzuTK
         dkcrXOO7VTNqxOVoI3Hgyh4mOBP1KXYwEz/2dFTSkKVMKFt6SgMpuYrloN0Q+t2rPz
         2GOn6eTa3A20IK26/98YM5XdFV3e08LlFaxYfGaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 040/146] can: isotp: stop timeout monitoring when no first frame was sent
Date:   Tue, 26 Apr 2022 10:20:35 +0200
Message-Id: <20220426081751.196080441@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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



