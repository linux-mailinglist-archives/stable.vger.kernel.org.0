Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0430853CF6C
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345375AbiFCRyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347275AbiFCRwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2504713E9C;
        Fri,  3 Jun 2022 10:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B687D60F3B;
        Fri,  3 Jun 2022 17:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF593C385B8;
        Fri,  3 Jun 2022 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278716;
        bh=tfgjU31NPL+z9713wFziaUtlFoPM/QCEwzK8ujtven8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV01uIL7yYahrUm1ov4hLIijDLv7R3wkQioVpB1uBQpXeUrN/pMicQQN5+rhELHHb
         YVBxtUFaGASQb/k3wNBGF7/VWrU1qewwrGXWBxbg+q40OePh7AplRaf78Jwts3RVwl
         3+hbfckBOXTgtITSFYbMAq0FUs0P0yAFXHKM4r1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.15 40/66] Bluetooth: hci_qca: Use del_timer_sync() before freeing
Date:   Fri,  3 Jun 2022 19:43:20 +0200
Message-Id: <20220603173821.830759872@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 72ef98445aca568a81c2da050532500a8345ad3a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -696,9 +696,9 @@ static int qca_close(struct hci_uart *hu
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


