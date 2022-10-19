Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B00603F2B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiJSJ2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiJSJ1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB00E52E2;
        Wed, 19 Oct 2022 02:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEEA661843;
        Wed, 19 Oct 2022 09:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D390DC433D6;
        Wed, 19 Oct 2022 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170624;
        bh=C0chszaV7MjF4tzyFjt3te2p553hPsz6RhT2J+josWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1AO3kf9aJcUC3sPuAgNf15KISTUcqHGAXDkQehiQaLziBMmQKzCuRBSLT5c+LGK2
         Hx+Ure/PJD1ClWAUflLgU8DfRMpFyU7pOJaxUIlTtQ6m+0uNcVFtsnioKLzTekSvtB
         nLFUlhmPfSgFld79UBeknBUSu8/wW8FYJgqq7ddU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+83672956c7aa6af698b3@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 708/862] Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
Date:   Wed, 19 Oct 2022 10:33:15 +0200
Message-Id: <20221019083321.252675098@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 2d2cb3066f2c90cd8ca540b36ba7a55e7f2406e0 ]

syzbot is reporting cancel_delayed_work() without INIT_DELAYED_WORK() at
l2cap_chan_del() [1], for CONF_NOT_COMPLETE flag (which meant to prevent
l2cap_chan_del() from calling cancel_delayed_work()) is cleared by timer
which fires before l2cap_chan_del() is called by closing file descriptor
created by socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_L2CAP).

l2cap_bredr_sig_cmd(L2CAP_CONF_REQ) and l2cap_bredr_sig_cmd(L2CAP_CONF_RSP)
are calling l2cap_ertm_init(chan), and they call l2cap_chan_ready() (which
clears CONF_NOT_COMPLETE flag) only when l2cap_ertm_init(chan) succeeded.

l2cap_sock_init() does not call l2cap_ertm_init(chan), and it instead sets
CONF_NOT_COMPLETE flag by calling l2cap_chan_set_defaults(). However, when
connect() is requested, "command 0x0409 tx timeout" happens after 2 seconds
 from connect() request, and CONF_NOT_COMPLETE flag is cleared after 4
seconds from connect() request, for l2cap_conn_start() from
l2cap_info_timeout() callback scheduled by

  schedule_delayed_work(&conn->info_timer, L2CAP_INFO_TIMEOUT);

in l2cap_connect() is calling l2cap_chan_ready().

Fix this problem by initializing delayed works used by L2CAP_MODE_ERTM
mode as soon as l2cap_chan_create() allocates a channel, like I did in
commit be8597239379f0f5 ("Bluetooth: initialize skb_queue_head at
l2cap_chan_create()").

Link: https://syzkaller.appspot.com/bug?extid=83672956c7aa6af698b3 [1]
Reported-by: syzbot <syzbot+83672956c7aa6af698b3@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c9de67daadc..770891f68703 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -61,6 +61,9 @@ static void l2cap_send_disconn_req(struct l2cap_chan *chan, int err);
 
 static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		     struct sk_buff_head *skbs, u8 event);
+static void l2cap_retrans_timeout(struct work_struct *work);
+static void l2cap_monitor_timeout(struct work_struct *work);
+static void l2cap_ack_timeout(struct work_struct *work);
 
 static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
 {
@@ -476,6 +479,9 @@ struct l2cap_chan *l2cap_chan_create(void)
 	write_unlock(&chan_list_lock);
 
 	INIT_DELAYED_WORK(&chan->chan_timer, l2cap_chan_timeout);
+	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
+	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
+	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
 
 	chan->state = BT_OPEN;
 
@@ -3320,10 +3326,6 @@ int l2cap_ertm_init(struct l2cap_chan *chan)
 	chan->rx_state = L2CAP_RX_STATE_RECV;
 	chan->tx_state = L2CAP_TX_STATE_XMIT;
 
-	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
-	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
-	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
-
 	skb_queue_head_init(&chan->srej_q);
 
 	err = l2cap_seq_list_init(&chan->srej_list, chan->tx_win);
-- 
2.35.1



