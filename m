Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F946432C8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiLET3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiLET3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:29:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC6E27FD3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB03661312
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC39C433D6;
        Mon,  5 Dec 2022 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268345;
        bh=3HOKe+n12DoekL2M18ICWUFn4x7R34TS3xfuo0y6Ons=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJecxm9/CqDtkUUE4try/zj03LElzC5J2Q6q3m01lLB5zAQBWxOZ9k+/HvQEbvJ8p
         tJyx8YzDMQHhKqNy++QAIGhI8etxmIO21MseauQCuDXDBSYOvTAIunvW2xfv4Zkwy2
         AuUwO4Ot+FQGmqABKflDzgtqXUxbkIO0fcsYMKJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biao Jiang <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/124] mptcp: dont orphan ssk in mptcp_close()
Date:   Mon,  5 Dec 2022 20:09:26 +0100
Message-Id: <20221205190810.124510274@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit fe94800184f22d4778628f1321dce5acb7513d84 ]

All of the subflows of a msk will be orphaned in mptcp_close(), which
means the subflows are in DEAD state. After then, DATA_FIN will be sent,
and the other side will response with a DATA_ACK for this DATA_FIN.

However, if the other side still has pending data, the data that received
on these subflows will not be passed to the msk, as they are DEAD and
subflow_data_ready() will not be called in tcp_data_ready(). Therefore,
these data can't be acked, and they will be retransmitted again and again,
until timeout.

Fix this by setting ssk->sk_socket and ssk->sk_wq to 'NULL', instead of
orphaning the subflows in __mptcp_close(), as Paolo suggested.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Reviewed-by: Biao Jiang <benbjiang@tencent.com>
Reviewed-by: Mengen Sun <mengensun@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b568f55998f3..42d5e0a7952a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2297,12 +2297,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		goto out;
 	}
 
-	/* if we are invoked by the msk cleanup code, the subflow is
-	 * already orphaned
-	 */
-	if (ssk->sk_socket)
-		sock_orphan(ssk);
-
+	sock_orphan(ssk);
 	subflow->disposable = 1;
 
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
@@ -2833,7 +2828,11 @@ bool __mptcp_close(struct sock *sk, long timeout)
 		if (ssk == msk->first)
 			subflow->fail_tout = 0;
 
-		sock_orphan(ssk);
+		/* detach from the parent socket, but allow data_ready to
+		 * push incoming data into the mptcp stack, to properly ack it
+		 */
+		ssk->sk_socket = NULL;
+		ssk->sk_wq = NULL;
 		unlock_sock_fast(ssk, slow);
 	}
 	sock_orphan(sk);
-- 
2.35.1



