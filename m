Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6106D548825
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbiFMKUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243170AbiFMKTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A89DF84;
        Mon, 13 Jun 2022 03:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84C7608C3;
        Mon, 13 Jun 2022 10:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5738C34114;
        Mon, 13 Jun 2022 10:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115410;
        bh=rZrO5jJVf/CDcbdcByQJGPBo7QorKqK1PDw7kMbQaEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZJ6h4iqOYJ+4uvwaKqwaSyTfzqviP7m46Bz7aBMnelUSNsJXXZxHhbanPFLioK1S
         B7FvW6ERObFzc5yvmP5uzELCO0frIccktv3muOvmcggzupKxUmIYvk7IJ7HMSEm8Uc
         HDoLkJ2DvrwTQ7kFgv9S4U9/hCWGMVp+LOAzl6G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 062/167] rxrpc: Dont try to resend the request if were receiving the reply
Date:   Mon, 13 Jun 2022 12:08:56 +0200
Message-Id: <20220613094855.430700012@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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
index 97a17ada4431..4aae0904ae1b 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -403,7 +403,8 @@ void rxrpc_process_call(struct work_struct *work)
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



