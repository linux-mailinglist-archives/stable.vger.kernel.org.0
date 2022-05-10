Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D2A521729
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbiEJNXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243074AbiEJNWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:22:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C7B52E73;
        Tue, 10 May 2022 06:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB73CB81CE7;
        Tue, 10 May 2022 13:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCDBC385C6;
        Tue, 10 May 2022 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188608;
        bh=2SQP/iK9dFo1azXQPmUtMwnMxA2HAIdd4EY0EdaBOnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA8dnf9xHnREbTcvJOrBbKeLj/NsO96SZ9l8lExRdgjVF+UHSJ1dyoub2g+z+QQty
         epo7M/nqDCL9obu9s0rMdDCH4Ty5GH5HcATHUHyViwbSNaVirdSl57lTLjF7OFpHk+
         IGusFEY/ix3lAH8zkwoL92+TDtEyBEa4ctWHQ/os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Andreas Larsson <andreas@gaisler.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 62/78] can: grcan: grcan_close(): fix deadlock
Date:   Tue, 10 May 2022 15:07:48 +0200
Message-Id: <20220510130734.367303060@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 47f070a63e735bcc8d481de31be1b5a1aa62b31c upstream.

There are deadlocks caused by del_timer_sync(&priv->hang_timer) and
del_timer_sync(&priv->rr_timer) in grcan_close(), one of the deadlocks
are shown below:

   (Thread 1)              |      (Thread 2)
                           | grcan_reset_timer()
grcan_close()              |  mod_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | grcan_initiate_running_reset()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold priv->lock in position (1) of thread 1 and use
del_timer_sync() to wait timer to stop, but timer handler also need
priv->lock in position (2) of thread 2. As a result, grcan_close()
will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain the
needed lock.

Link: https://lore.kernel.org/all/20220425042400.66517-1-duoming@zju.edu.cn
Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/grcan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1117,8 +1117,10 @@ static int grcan_close(struct net_device
 
 	priv->closing = true;
 	if (priv->need_txbug_workaround) {
+		spin_unlock_irqrestore(&priv->lock, flags);
 		del_timer_sync(&priv->hang_timer);
 		del_timer_sync(&priv->rr_timer);
+		spin_lock_irqsave(&priv->lock, flags);
 	}
 	netif_stop_queue(dev);
 	grcan_stop_hardware(dev);


