Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDE450554F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbiDRNLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbiDRNFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:05:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38F829CBF;
        Mon, 18 Apr 2022 05:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E28F60FB6;
        Mon, 18 Apr 2022 12:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFE7C385A7;
        Mon, 18 Apr 2022 12:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285993;
        bh=olGAV6P3/bdfp4ZsB1dE9ZnWfbk+IEVsCX5kp+ufGzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzOUlG60u7Ot0u6pnAKe8f1OnMLMpdIC/QUfzX2t3XngKdTiH8x8sTcCpBy6otHBu
         0ryFqfYU9IJm8z15FZpqcoRdlu3i4yEb5NX2bnC2ta5tfwokmUPRj7W1rkC/HtYaak
         w+7t2WdEV/4wyaAK+owjU6J4XHDRp9YxGKZE04p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/32] sctp: Initialize daddr on peeled off socket
Date:   Mon, 18 Apr 2022 14:13:47 +0200
Message-Id: <20220418121127.343178003@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
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

From: Petr Malat <oss@malat.biz>

[ Upstream commit 8467dda0c26583547731e7f3ea73fc3856bae3bf ]

Function sctp_do_peeloff() wrongly initializes daddr of the original
socket instead of the peeled off socket, which makes getpeername()
return zeroes instead of the primary address. Initialize the new socket
instead.

Fixes: d570ee490fb1 ("[SCTP]: Correctly set daddr for IPv6 sockets during peeloff")
Signed-off-by: Petr Malat <oss@malat.biz>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/20220409063611.673193-1-oss@malat.biz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d429d5922804..8901bb7afa2b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5333,7 +5333,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	 * Set the daddr and initialize id to something more random and also
 	 * copy over any ip options.
 	 */
-	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
+	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sock->sk);
 	sp->pf->copy_ip_options(sk, sock->sk);
 
 	/* Populate the fields of the newsk from the oldsk and migrate the
-- 
2.35.1



