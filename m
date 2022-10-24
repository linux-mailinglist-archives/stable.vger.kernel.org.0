Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7541760A45E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiJXMKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiJXMJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:09:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE5D7E30D;
        Mon, 24 Oct 2022 04:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8592B81150;
        Mon, 24 Oct 2022 11:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35131C433C1;
        Mon, 24 Oct 2022 11:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611689;
        bh=4inlYOFl1eXSTajS6aRDIXXw7r7t8VLR/Qy2sCG58w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1P4yMeCqtHXGaXwVO6HIPn3Sf+Sx/IPDN5bF9wI37FC8tcvh2ZP6Y9Ts8b93AolIX
         KPJnkcbU8oadLAttMdLvIMFZ6uwXwWVhgagCoGA50rpL2bvuO5J00dvBXtLARKCpqT
         1+2IOXtXOqGALYCzssEn5Y8tg3YUD3/TecdZ6GWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 073/159] mISDN: fix use-after-free bugs in l1oip timer handlers
Date:   Mon, 24 Oct 2022 13:30:27 +0200
Message-Id: <20221024112952.118608404@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 2568a7e0832ee30b0a351016d03062ab4e0e0a3f ]

The l1oip_cleanup() traverses the l1oip_ilist and calls
release_card() to cleanup module and stack. However,
release_card() calls del_timer() to delete the timers
such as keep_tl and timeout_tl. If the timer handler is
running, the del_timer() will not stop it and result in
UAF bugs. One of the processes is shown below:

    (cleanup routine)          |        (timer handler)
release_card()                 | l1oip_timeout()
 ...                           |
 del_timer()                   | ...
 ...                           |
 kfree(hc) //FREE              |
                               | hc->timeout_on = 0 //USE

Fix by calling del_timer_sync() in release_card(), which
makes sure the timer handlers have finished before the
resources, such as l1oip and so on, have been deallocated.

What's more, the hc->workq and hc->socket_thread can kick
those timers right back in. We add a bool flag to show
if card is released. Then, check this flag in hc->workq
and hc->socket_thread.

Fixes: 3712b42d4b1b ("Add layer1 over IP support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/l1oip.h      |  1 +
 drivers/isdn/mISDN/l1oip_core.c | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip.h b/drivers/isdn/mISDN/l1oip.h
index 661c060ada49..67d1a4762d56 100644
--- a/drivers/isdn/mISDN/l1oip.h
+++ b/drivers/isdn/mISDN/l1oip.h
@@ -58,6 +58,7 @@ struct l1oip {
 	int			bundle;		/* bundle channels in one frm */
 	int			codec;		/* codec to use for transmis. */
 	int			limit;		/* limit number of bchannels */
+	bool			shutdown;	/* if card is released */
 
 	/* timer */
 	struct timer_list	keep_tl;
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 67c21876c35f..b77ae00a95a3 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -287,7 +287,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	p = frame;
 
 	/* restart timer */
-	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ))
+	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ) && !hc->shutdown)
 		mod_timer(&hc->keep_tl, jiffies + L1OIP_KEEPALIVE * HZ);
 	else
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
@@ -619,7 +619,9 @@ l1oip_socket_parse(struct l1oip *hc, struct sockaddr_in *sin, u8 *buf, int len)
 		goto multiframe;
 
 	/* restart timer */
-	if (time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) || !hc->timeout_on) {
+	if ((time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) ||
+	     !hc->timeout_on) &&
+	    !hc->shutdown) {
 		hc->timeout_on = 1;
 		mod_timer(&hc->timeout_tl, jiffies + L1OIP_TIMEOUT * HZ);
 	} else /* only adjust timer */
@@ -1246,11 +1248,10 @@ release_card(struct l1oip *hc)
 {
 	int	ch;
 
-	if (timer_pending(&hc->keep_tl))
-		del_timer(&hc->keep_tl);
+	hc->shutdown = true;
 
-	if (timer_pending(&hc->timeout_tl))
-		del_timer(&hc->timeout_tl);
+	del_timer_sync(&hc->keep_tl);
+	del_timer_sync(&hc->timeout_tl);
 
 	cancel_work_sync(&hc->workq);
 
-- 
2.35.1



