Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9221B51A97A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345314AbiEDRLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356918AbiEDRJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C376547381;
        Wed,  4 May 2022 09:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7118BB82795;
        Wed,  4 May 2022 16:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D12C385A5;
        Wed,  4 May 2022 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683382;
        bh=ubcQyke9vPFH9s6nU+Un2l/Q2Wf/PRFTnF/wUNLwwzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kl0snVSGz7jgGwKPfld7VSbDkcyyet/R3OIaORyILvA9AqOYo1Fq+V+9yhphWnsKE
         CQ7ErSGW5D8K9MSCq7qbJaSXEW++PuiMcNqNJDhNpSFwMlwYC3700SWV50YmAiZQw0
         J2t1fwn7mIyEXRam5+90h64ggtgk7fV0Me5bHfkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 067/225] xsk: Fix l2fwd for copy mode + busy poll combo
Date:   Wed,  4 May 2022 18:45:05 +0200
Message-Id: <20220504153117.092670935@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 8de8b71b787f38983d414d2dba169a3bfefa668a ]

While checking AF_XDP copy mode combined with busy poll, strange
results were observed. rxdrop and txonly scenarios worked fine, but
l2fwd broke immediately.

After a deeper look, it turned out that for l2fwd, Tx side was exiting
early due to xsk_no_wakeup() returning true and in the end
xsk_generic_xmit() was never called. Note that AF_XDP Tx in copy mode
is syscall steered, so the current behavior is broken.

Txonly scenario only worked due to the fact that
sk_mark_napi_id_once_xdp() was never called - since Rx side is not in
the picture for this case and mentioned function is called in
xsk_rcv_check(), sk::sk_napi_id was never set, which in turn meant that
xsk_no_wakeup() was returning false (see the sk->sk_napi_id >=
MIN_NAPI_ID check in there).

To fix this, prefer busy poll in xsk_sendmsg() only when zero copy is
enabled on a given AF_XDP socket. By doing so, busy poll in copy mode
would not exit early on Tx side and eventually xsk_generic_xmit() will
be called.

Fixes: a0731952d9cd ("xsk: Add busy-poll support for {recv,send}msg()")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220406155804.434493-1-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ac343cd8ff3f..39a82bfb5caa 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -640,7 +640,7 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	if (sk_can_busy_loop(sk))
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
 
-	if (xsk_no_wakeup(sk))
+	if (xs->zc && xsk_no_wakeup(sk))
 		return 0;
 
 	pool = xs->pool;
-- 
2.35.1



