Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D595798E8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiGSL4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbiGSL4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:56:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19E2422F4;
        Tue, 19 Jul 2022 04:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31E7DB81A8F;
        Tue, 19 Jul 2022 11:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858F2C385A2;
        Tue, 19 Jul 2022 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231759;
        bh=X1HuKRt0LWoedxoY1R+Lv8GBU7vpc+yZbocg1ZBZ8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8BpoxU52JzIUQ3QZJo/DLaqv58NBVkggG8IuwyzOugzvBpGFWyIOSYaCQirLEbZr
         0Y+XbkJ+b2TZe8MdoQwRsera/RDC/vP6mRUBMblidMVKicOyz18W6XbjUvEFzBs+8C
         dFo47308N7dZHrQ00d29tRvf6FPnXjagixWiTEww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/28] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Tue, 19 Jul 2022 13:53:55 +0200
Message-Id: <20220719114457.866181299@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 00aff3590fc0a73bddd3b743863c14e76fd35c0c ]

Free sk in case tipc_sk_insert() fails.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 9f39276e5d4e..1b3516368057 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -341,6 +341,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock->state = state;
 	sock_init_data(sock, sk);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
-- 
2.35.1



