Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0964549026
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348603AbiFMK76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350001AbiFMK6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:58:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C02CE1F;
        Mon, 13 Jun 2022 03:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19E9260B8B;
        Mon, 13 Jun 2022 10:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CE2C34114;
        Mon, 13 Jun 2022 10:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116342;
        bh=xnuZ9XK+CKLdG2vQFls8v7LSP74HMjNzXx226U2PVTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynWbq9Y4Sp7Hcj6+gx4k3xCBEv/dqey+zuP9u/+MOA8d/hK1uC6bbt9ZDOD7Cq9E2
         uA2ssgt1llsK+JRVm89U4PYEwo70/SY0Q2JrAbkViQexar6SuaKkgyNP5sQAAtx/T8
         lqZa8SzNu1EXlvIJB9oATeuTVW+opy5+rIws84Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/411] rxrpc: Return an error to sendmsg if call failed
Date:   Mon, 13 Jun 2022 12:05:33 +0200
Message-Id: <20220613094930.315433583@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 4ba68c5192554876bd8c3afd904e3064d2915341 ]

If at the end of rxrpc sendmsg() or rxrpc_kernel_send_data() the call that
was being given data was aborted remotely or otherwise failed, return an
error rather than returning the amount of data buffered for transmission.

The call (presumably) did not complete, so there's not much point
continuing with it.  AF_RXRPC considers it "complete" and so will be
unwilling to do anything else with it - and won't send a notification for
it, deeming the return from sendmsg sufficient.

Not returning an error causes afs to incorrectly handle a StoreData
operation that gets interrupted by a change of address due to NAT
reconfiguration.

This doesn't normally affect most operations since their request parameters
tend to fit into a single UDP packet and afs_make_call() returns before the
server responds; StoreData is different as it involves transmission of a
lot of data.

This can be triggered on a client by doing something like:

	dd if=/dev/zero of=/afs/example.com/foo bs=1M count=512

at one prompt, and then changing the network address at another prompt,
e.g.:

	ifconfig enp6s0 inet 192.168.6.2 && route add 192.168.6.1 dev enp6s0

Tracing packets on an Auristor fileserver looks something like:

192.168.6.1 -> 192.168.6.3  RX 107 ACK Idle  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.3 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(64538) (64538)
192.168.6.3 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(64538) (64538)
192.168.6.1 -> 192.168.6.3  RX 107 ACK Idle  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
<ARP exchange for 192.168.6.2>
192.168.6.2 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(0) (0)
192.168.6.2 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(0) (0)
192.168.6.1 -> 192.168.6.2  RX 107 ACK Exceeds Window  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.1 -> 192.168.6.2  RX 74 ABORT  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.1 -> 192.168.6.2  RX 74 ABORT  Seq: 29321  Call: 4  Source Port: 7000  Destination Port: 7001

The Auristor fileserver logs code -453 (RXGEN_SS_UNMARSHAL), but the abort
code received by kafs is -5 (RX_PROTOCOL_ERROR) as the rx layer sees the
condition and generates an abort first and the unmarshal error is a
consequence of that at the application layer.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2021-December/004810.html # v1
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1a340eb0abf7..22f020099214 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -463,6 +463,12 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 success:
 	ret = copied;
+	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
+		read_lock_bh(&call->state_lock);
+		if (call->error < 0)
+			ret = call->error;
+		read_unlock_bh(&call->state_lock);
+	}
 out:
 	call->tx_pending = skb;
 	_leave(" = %d", ret);
-- 
2.35.1



