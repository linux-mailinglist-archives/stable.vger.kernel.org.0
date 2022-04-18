Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813955051FF
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbiDRMkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiDRMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005AEC0A;
        Mon, 18 Apr 2022 05:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C656B80ED6;
        Mon, 18 Apr 2022 12:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CB2C385A1;
        Mon, 18 Apr 2022 12:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285058;
        bh=rA8OICJvC+vLZzHg5hHD8kepodIPft98BGpeRXaRoeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtKrfw/E215Fi5aoCZjS+8isdkkov2ShXsyA1IBY93vBzDKLNXw9D/LZbqqrAVTfS
         iFPWz6iP8jAq9jWWGjp/DKsL+t6Xf82kZugyDL57mPi9qYoAYiRhx+5BDKsKSzf9Dj
         SIXW5G6xhB1ljH0Fs72auhLBCpbr614h+Qcihj/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/189] sctp: Initialize daddr on peeled off socket
Date:   Mon, 18 Apr 2022 14:11:46 +0200
Message-Id: <20220418121202.948615989@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index 6b3c32264cbc..5f6e6a6e91b3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5641,7 +5641,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	 * Set the daddr and initialize id to something more random and also
 	 * copy over any ip options.
 	 */
-	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
+	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sock->sk);
 	sp->pf->copy_ip_options(sk, sock->sk);
 
 	/* Populate the fields of the newsk from the oldsk and migrate the
-- 
2.35.1



