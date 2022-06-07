Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC22540C12
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351270AbiFGSdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352073AbiFGSao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:30:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040F4144FE7;
        Tue,  7 Jun 2022 10:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77365617A6;
        Tue,  7 Jun 2022 17:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DB4C385A5;
        Tue,  7 Jun 2022 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624551;
        bh=1uQfHZyEVzAhNvhs2p8gXdX2bJGCq69ZMlYZfgFCGHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6cEBBod7Rjr9PRcKc508Zwmgm/OSNUyhZpZyIqfFyTAtBBy1LCTNRY8dgSFgH6y9
         QNlUx9TD3jx5PyCPn+Memu7r6mEdaM1sOF7auaHY4XgcQmPbLGWYvHyuvE1VPWOlE3
         M/170FN5okNoaEg90EJty2ook3tA1gl1HUubqgNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/667] rxrpc: Fix listen() setting the bar too high for the prealloc rings
Date:   Tue,  7 Jun 2022 19:00:33 +0200
Message-Id: <20220607164945.788045718@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 88e22159750b0d55793302eeed8ee603f5c1a95c ]

AF_RXRPC's listen() handler lets you set the backlog up to 32 (if you bump
up the sysctl), but whilst the preallocation circular buffers have 32 slots
in them, one of them has to be a dead slot because we're using CIRC_CNT().

This means that listen(rxrpc_sock, 32) will cause an oops when the socket
is closed because rxrpc_service_prealloc_one() allocated one too many calls
and rxrpc_discard_prealloc() won't then be able to get rid of them because
it'll think the ring is empty.  rxrpc_release_calls_on_socket() then tries
to abort them, but oopses because call->peer isn't yet set.

Fix this by setting the maximum backlog to RXRPC_BACKLOG_MAX - 1 to match
the ring capacity.

 BUG: kernel NULL pointer dereference, address: 0000000000000086
 ...
 RIP: 0010:rxrpc_send_abort_packet+0x73/0x240 [rxrpc]
 Call Trace:
  <TASK>
  ? __wake_up_common_lock+0x7a/0x90
  ? rxrpc_notify_socket+0x8e/0x140 [rxrpc]
  ? rxrpc_abort_call+0x4c/0x60 [rxrpc]
  rxrpc_release_calls_on_socket+0x107/0x1a0 [rxrpc]
  rxrpc_release+0xc9/0x1c0 [rxrpc]
  __sock_release+0x37/0xa0
  sock_close+0x11/0x20
  __fput+0x89/0x240
  task_work_run+0x59/0x90
  do_exit+0x319/0xaa0

Fixes: 00e907127e6f ("rxrpc: Preallocate peers, conns and calls for incoming service requests")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: https://lists.infradead.org/pipermail/linux-afs/2022-March/005079.html
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 540351d6a5f4..555e0910786b 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -12,7 +12,7 @@
 
 static struct ctl_table_header *rxrpc_sysctl_reg_table;
 static const unsigned int four = 4;
-static const unsigned int thirtytwo = 32;
+static const unsigned int max_backlog = RXRPC_BACKLOG_MAX - 1;
 static const unsigned int n_65535 = 65535;
 static const unsigned int n_max_acks = RXRPC_RXTX_BUFF_SIZE - 1;
 static const unsigned long one_jiffy = 1;
@@ -89,7 +89,7 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *)&four,
-		.extra2		= (void *)&thirtytwo,
+		.extra2		= (void *)&max_backlog,
 	},
 	{
 		.procname	= "rx_window_size",
-- 
2.35.1



