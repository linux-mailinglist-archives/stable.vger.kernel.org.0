Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA176D497D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbjDCOiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbjDCOiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE7D527A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35E22B81CCC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6CAC433D2;
        Mon,  3 Apr 2023 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532698;
        bh=UHbuWw0AceNl7b2uWdASijiiZ1iITVI+A+FJZ6kk99Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Vqy7uko2E6wD7uWk+upWGEFa2qj9vyMh65vqO5G1TQ09OiTBgzvi64JS/zufWGJ3
         lAvn9dCn67nkcMKLVeaj59XUhVe9vbaPetR+Wh+kZqzEJYJUFIlowiNYRp2Y5BlMOR
         xZhaRDF5S+HNNc2JlfQgaOiaoqp5XmfhMiKYrtvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Siddharth Rajendra Kawar <sikawar@microsoft.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/181] SUNRPC: fix shutdown of NFS TCP client socket
Date:   Mon,  3 Apr 2023 16:08:36 +0200
Message-Id: <20230403140417.774451358@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Kawar <Siddharth.Kawar@microsoft.com>

[ Upstream commit 943d045a6d796175e5d08f9973953b1d2c07d797 ]

NFS server Duplicate Request Cache (DRC) algorithms rely on NFS clients
reconnecting using the same local TCP port. Unique NFS operations are
identified by the per-TCP connection set of XIDs. This prevents file
corruption when non-idempotent NFS operations are retried.

Currently, NFS client TCP connections are using different local TCP ports
when reconnecting to NFS servers.

After an NFS server initiates shutdown of the TCP connection, the NFS
client's TCP socket is set to NULL after the socket state has reached
TCP_LAST_ACK(9). When reconnecting, the new socket attempts to reuse
the same local port but fails with EADDRNOTAVAIL (99). This forces the
socket to use a different local TCP port to reconnect to the remote NFS
server.

State Transition and Events:
TCP_CLOSE_WAIT(8)
TCP_LAST_ACK(9)
connect(fail EADDRNOTAVAIL(99))
TCP_CLOSE(7)
bind on new port
connect success

dmesg excerpts showing reconnect switching from TCP local port of 926 to
763 after commit 7c81e6a9d75b:
[13354.947854] NFS call  mkdir testW
...
[13405.654781] RPC:       xs_tcp_state_change client 00000000037d0f03...
[13405.654813] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1
[13405.654826] RPC:       xs_data_ready...
[13405.654892] RPC:       xs_tcp_state_change client 00000000037d0f03...
[13405.654895] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
[13405.654899] RPC:       xs_tcp_state_change client 00000000037d0f03...
[13405.654900] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
[13405.654950] RPC:       xs_connect scheduled xprt 00000000037d0f03
[13405.654975] RPC:       xs_bind 0.0.0.0:926: ok (0)
[13405.654980] RPC:       worker connecting xprt 00000000037d0f03 via tcp
			  to 10.101.6.228 (port 2049)
[13405.654991] RPC:       00000000037d0f03 connect status 99 connected 0
			  sock state 7
[13405.655001] RPC:       xs_tcp_state_change client 00000000037d0f03...
[13405.655002] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
[13405.655024] RPC:       xs_connect scheduled xprt 00000000037d0f03
[13405.655038] RPC:       xs_bind 0.0.0.0:763: ok (0)
[13405.655041] RPC:       worker connecting xprt 00000000037d0f03 via tcp
			  to 10.101.6.228 (port 2049)
[13405.655065] RPC:       00000000037d0f03 connect status 115 connected 0
			  sock state 2

State Transition and Events with patch applied:
TCP_CLOSE_WAIT(8)
TCP_LAST_ACK(9)
TCP_CLOSE(7)
connect(reuse of port succeeds)

dmesg excerpts showing reconnect on same TCP local port of 936 with patch
applied:
[  257.139935] NFS: mkdir(0:59/560857152), testQ
[  257.139937] NFS call  mkdir testQ
...
[  307.822702] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1
[  307.822714] RPC:       xs_data_ready...
[  307.822817] RPC:       xs_tcp_state_change client 00000000ce702f14...
[  307.822821] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
[  307.822825] RPC:       xs_tcp_state_change client 00000000ce702f14...
[  307.822826] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
[  307.823606] RPC:       xs_tcp_state_change client 00000000ce702f14...
[  307.823609] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
[  307.823629] RPC:       xs_tcp_state_change client 00000000ce702f14...
[  307.823632] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
[  307.823676] RPC:       xs_connect scheduled xprt 00000000ce702f14
[  307.823704] RPC:       xs_bind 0.0.0.0:936: ok (0)
[  307.823709] RPC:       worker connecting xprt 00000000ce702f14 via tcp
			  to 10.101.1.30 (port 2049)
[  307.823748] RPC:       00000000ce702f14 connect status 115 connected 0
			  sock state 2
...
[  314.916193] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
[  314.916251] RPC:       xs_connect scheduled xprt 00000000ce702f14
[  314.916282] RPC:       xs_bind 0.0.0.0:936: ok (0)
[  314.916292] RPC:       worker connecting xprt 00000000ce702f14 via tcp
			  to 10.101.1.30 (port 2049)
[  314.916342] RPC:       00000000ce702f14 connect status 115 connected 0
			  sock state 2

Fixes: 7c81e6a9d75b ("SUNRPC: Tweak TCP socket shutdown in the RPC client")
Signed-off-by: Siddharth Rajendra Kawar <sikawar@microsoft.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b3ab6d9d752ea..05aa32696e7c2 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2153,6 +2153,7 @@ static void xs_tcp_shutdown(struct rpc_xprt *xprt)
 	switch (skst) {
 	case TCP_FIN_WAIT1:
 	case TCP_FIN_WAIT2:
+	case TCP_LAST_ACK:
 		break;
 	case TCP_ESTABLISHED:
 	case TCP_CLOSE_WAIT:
-- 
2.39.2



