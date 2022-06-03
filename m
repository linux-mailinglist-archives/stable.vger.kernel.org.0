Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF13B53CCDE
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 18:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbiFCQBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 12:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiFCQBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 12:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61AC2CDDA
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 09:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51C87618F4
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA2DC385A9;
        Fri,  3 Jun 2022 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654272082;
        bh=+ujJY77KuUyNc/14AWk+ktYUOQcOceKdpTkjoFpehDw=;
        h=Subject:To:Cc:From:Date:From;
        b=d8drXYGP9r6bK3RuvW6anNV61AM8ZpOA6t0mx3k5gsfwO10ISUMvRpyfcz7sDeLH7
         mYJKNxiQGaIz+A41Y7Q3dAtH3ZFtq5JUAArCgbL90LM211Jb01gyojf3IeVgpTL9Zt
         NYqdyDdagZhsHffIN6ieu7OgyKGdrJyYgbujExvU=
Subject: FAILED: patch "[PATCH] Bluetooth: hci_qca: Use del_timer_sync() before freeing" failed to apply to 5.4-stable tree
To:     rostedt@goodmis.org, eric.dumazet@gmail.com, marcel@holtmann.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 18:01:19 +0200
Message-ID: <165427207915916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 72ef98445aca568a81c2da050532500a8345ad3a Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 5 Apr 2022 10:02:00 -0400
Subject: [PATCH] Bluetooth: hci_qca: Use del_timer_sync() before freeing

While looking at a crash report on a timer list being corrupted, which
usually happens when a timer is freed while still active. This is
commonly triggered by code calling del_timer() instead of
del_timer_sync() just before freeing.

One possible culprit is the hci_qca driver, which does exactly that.

Eric mentioned that wake_retrans_timer could be rearmed via the work
queue, so also move the destruction of the work queue before
del_timer_sync().

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 0ff252c1976da ("Bluetooth: hciuart: Add support QCA chipset for UART")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f6e91fb432a3..eab34e24d944 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -696,9 +696,9 @@ static int qca_close(struct hci_uart *hu)
 	skb_queue_purge(&qca->tx_wait_q);
 	skb_queue_purge(&qca->txq);
 	skb_queue_purge(&qca->rx_memdump_q);
-	del_timer(&qca->tx_idle_timer);
-	del_timer(&qca->wake_retrans_timer);
 	destroy_workqueue(qca->workqueue);
+	del_timer_sync(&qca->tx_idle_timer);
+	del_timer_sync(&qca->wake_retrans_timer);
 	qca->hu = NULL;
 
 	kfree_skb(qca->rx_skb);

