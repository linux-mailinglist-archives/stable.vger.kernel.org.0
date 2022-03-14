Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A5F4D8151
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbiCNLmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbiCNLln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:41:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B8249C83;
        Mon, 14 Mar 2022 04:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7332611D4;
        Mon, 14 Mar 2022 11:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D361C340E9;
        Mon, 14 Mar 2022 11:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257948;
        bh=T6jigpNq982/j1TJfmd+kEQNRNF3TWIqUBan2G1ihXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dB45wU/8CGGRHBYffB1Is4SpjY7ARpSzaHkewp0xwtXx1F6uH0xrpsHaH+sNHyL6U
         PuDEghmIG0rka9paTLtVWd6T3Dx0OJv/vvgIUAOCIuR1QiezEQiE00gC0uR8a9smZ2
         wI4HZ2qlK5qmDPgpMcM25hXI7ialjcggDHZMvpvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Osterried <thomas@osterried.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/30] ax25: Fix NULL pointer dereference in ax25_kill_by_device
Date:   Mon, 14 Mar 2022 12:34:24 +0100
Message-Id: <20220314112731.968884655@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 71171ac8eb34ce7fe6b3267dce27c313ab3cb3ac ]

When two ax25 devices attempted to establish connection, the requester use ax25_create(),
ax25_bind() and ax25_connect() to initiate connection. The receiver use ax25_rcv() to
accept connection and use ax25_create_cb() in ax25_rcv() to create ax25_cb, but the
ax25_cb->sk is NULL. When the receiver is detaching, a NULL pointer dereference bug
caused by sock_hold(sk) in ax25_kill_by_device() will happen. The corresponding
fail log is shown below:

===============================================================
BUG: KASAN: null-ptr-deref in ax25_device_event+0xfd/0x290
Call Trace:
...
ax25_device_event+0xfd/0x290
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x174/0x220
unregister_netdevice_many+0x1f7/0xa60
unregister_netdevice_queue+0x12f/0x170
unregister_netdev+0x13/0x20
mkiss_close+0xcd/0x140
tty_ldisc_release+0xc0/0x220
tty_release_struct+0x17/0xa0
tty_release+0x62d/0x670
...

This patch add condition check in ax25_kill_by_device(). If s->sk is
NULL, it will goto if branch to kill device.

Fixes: 4e0f718daf97 ("ax25: improve the incomplete fix to avoid UAF and NPD bugs")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index a2bf5e4e9fbe..3170b43b9f89 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -90,6 +90,13 @@ static void ax25_kill_by_device(struct net_device *dev)
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
 			sk = s->sk;
+			if (!sk) {
+				spin_unlock_bh(&ax25_list_lock);
+				s->ax25_dev = NULL;
+				ax25_disconnect(s, ENETUNREACH);
+				spin_lock_bh(&ax25_list_lock);
+				goto again;
+			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
-- 
2.34.1



