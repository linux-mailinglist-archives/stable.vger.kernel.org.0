Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE0F60B72C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiJXTVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiJXTUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:20:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE861D1E0B;
        Mon, 24 Oct 2022 10:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9567CE147A;
        Mon, 24 Oct 2022 12:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051E2C433D6;
        Mon, 24 Oct 2022 12:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614775;
        bh=XFRkCfAJHCaYT5OdRdGtKdxR0dcdcuxZLYpauLQ+i6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/hUwflNtgDfCXyIjC0pihUr7oc1ZCT7AdObhJLXimqh6weVjp36gn4l3WRFK3K0b
         4jM6OJ//Xc5cZwvYfV2/OFZ5O/IbXBUzaYhmdfIu6MTqOXJe2wbVptb3y8JslfIgq0
         yUVrrPL1LRxV9rT1UtN2+8OP6v8qtc0iP1cP1CBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/390] Revert "net/ieee802154: reject zero-sized raw_sendmsg()"
Date:   Mon, 24 Oct 2022 13:32:59 +0200
Message-Id: <20221024113039.246515196@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 2eb2756f6c9e9621e022d78321ce40a62c4520b5 ]

This reverts commit 3a4d061c699bd3eedc80dc97a4b2a2e1af83c6f5.

There is a v2 which does return zero if zero length is given.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20221005014750.3685555-1-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/socket.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index d4c162d63634..7edec210780a 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -252,9 +252,6 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
-	if (!size)
-		return -EINVAL;
-
 	lock_sock(sk);
 	if (!sk->sk_bound_dev_if)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
-- 
2.35.1



