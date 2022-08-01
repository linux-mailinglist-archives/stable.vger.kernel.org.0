Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FE55868FA
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiHALzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiHALyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF70D3CBE4;
        Mon,  1 Aug 2022 04:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C8AE6125A;
        Mon,  1 Aug 2022 11:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A653C433C1;
        Mon,  1 Aug 2022 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354651;
        bh=0fxKXtD5VUAoJzS3L5pj9ecR5pb2Z9NXHQ3EPGgtdMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mp8MGZ6Lzi8Aki5w052qa9c7d3f6msrK+e9KRY7phXDRCgE3jqSm5dmphxTAkYM/r
         MtRMzemIlctX0xdbWbbsVFei2WINUHwjXwbcgadXBCbVlyXK0TOGVGEv15e9jWWBNK
         Ye8m+mP0oSd9vwLSwU67IVZiE+Wm7/8XKBaWkfSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 09/65] tcp: Fix a data-race around sysctl_tcp_app_win.
Date:   Mon,  1 Aug 2022 13:46:26 +0200
Message-Id: <20220801114134.074850891@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 02ca527ac5581cf56749db9fd03d854e842253dd upstream.

While reading sysctl_tcp_app_win, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -503,7 +503,7 @@ static void tcp_grow_window(struct sock
  */
 static void tcp_init_buffer_space(struct sock *sk)
 {
-	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
+	int tcp_app_win = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_app_win);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 


