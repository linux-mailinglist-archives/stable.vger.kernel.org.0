Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93050F47C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345151AbiDZIiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345167AbiDZIgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249E38879A;
        Tue, 26 Apr 2022 01:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6D02617E7;
        Tue, 26 Apr 2022 08:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B529AC385AC;
        Tue, 26 Apr 2022 08:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961744;
        bh=xekvh54C44ahrLQv498FL4hhn2bRb7cr2r2BeQabwWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXIrbZUk/QhlbwpMdch2ZENXmCTzbZRF7thT34bZPT1coocoPR9lXwms6qxaDeKmY
         HHOkK6GlmPojLg+aHow2hff97t4y9lPAMFIzT2E80fzM2syN0cfIWlbczvDrlqM9Ng
         uCbqXFosxdeutcEPXt02j9puOFv8syjnxlLQK1dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/62] rxrpc: Restore removed timer deletion
Date:   Tue, 26 Apr 2022 10:20:56 +0200
Message-Id: <20220426081737.692804682@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit ee3b0826b4764f6c13ad6db67495c5a1c38e9025 ]

A recent patch[1] from Eric Dumazet flipped the order in which the
keepalive timer and the keepalive worker were cancelled in order to fix a
syzbot reported issue[2].  Unfortunately, this enables the mirror image bug
whereby the timer races with rxrpc_exit_net(), restarting the worker after
it has been cancelled:

	CPU 1		CPU 2
	===============	=====================
			if (rxnet->live)
			<INTERRUPT>
	rxnet->live = false;
 	cancel_work_sync(&rxnet->peer_keepalive_work);
			rxrpc_queue_work(&rxnet->peer_keepalive_work);
	del_timer_sync(&rxnet->peer_keepalive_timer);

Fix this by restoring the removed del_timer_sync() so that we try to remove
the timer twice.  If the timer runs again, it should see ->live == false
and not restart the worker.

Fixes: 1946014ca3b1 ("rxrpc: fix a race in rxrpc_exit_net()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20220404183439.3537837-1-eric.dumazet@gmail.com/ [1]
Link: https://syzkaller.appspot.com/bug?extid=724378c4bb58f703b09a [2]
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/net_ns.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 9a76b74af37b..91a503871116 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -116,7 +116,9 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 
 	rxnet->live = false;
+	del_timer_sync(&rxnet->peer_keepalive_timer);
 	cancel_work_sync(&rxnet->peer_keepalive_work);
+	/* Remove the timer again as the worker may have restarted it. */
 	del_timer_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
-- 
2.35.1



