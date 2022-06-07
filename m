Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C652C5414BA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359044AbiFGUTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358762AbiFGUSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:18:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D82A1D01C4;
        Tue,  7 Jun 2022 11:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A8DB8237C;
        Tue,  7 Jun 2022 18:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0518CC385A2;
        Tue,  7 Jun 2022 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626604;
        bh=d5f3waSstqFwsHwR92Wq26SEDDhS6+RyUHdRiynwipA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf5S8fGDc2mBWr4XISC1v51PAl8tpctrR+AouFDme+35hkzZoUswR+Qs5ZQ+Pre2X
         nu/FH7OEt/BgLYLvaO52CrSs3+0xBqo6voSaFk7fBy89NMzRXZ/d8riKkCp3fSP7KD
         syvjykj/rlf2RIFe09Ye/XXKDFLantnOr0CBKqTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 439/772] rxrpc: Dont try to resend the request if were receiving the reply
Date:   Tue,  7 Jun 2022 19:00:31 +0200
Message-Id: <20220607165001.935676662@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit 114af61f88fbe34d641b13922d098ffec4c1be1b ]

rxrpc has a timer to trigger resending of unacked data packets in a call.
This is not cancelled when a client call switches to the receive phase on
the basis that most calls don't last long enough for it to ever expire.
However, if it *does* expire after we've started to receive the reply, we
shouldn't then go into trying to retransmit or pinging the server to find
out if an ack got lost.

Fix this by skipping the resend code if we're into receiving the reply to a
client call.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index e426f6831aab..f8ecad2b730e 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -406,7 +406,8 @@ void rxrpc_process_call(struct work_struct *work)
 		goto recheck_state;
 	}
 
-	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events)) {
+	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events) &&
+	    call->state != RXRPC_CALL_CLIENT_RECV_REPLY) {
 		rxrpc_resend(call, now);
 		goto recheck_state;
 	}
-- 
2.35.1



