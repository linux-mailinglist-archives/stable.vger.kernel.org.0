Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2F7608AC4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiJVJGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiJVJEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A891B7B0;
        Sat, 22 Oct 2022 01:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEAF760B9A;
        Sat, 22 Oct 2022 08:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AA5C433D7;
        Sat, 22 Oct 2022 08:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426060;
        bh=cevrSgJp5/K+gljJsjmLJh8wwK0TipvFRgrsfKwaDf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPpJ7uzJ2RkAWj6iMiy3s/mFIilAvBVFXLjS1hUzrw/9mg89n6S+O8PNZquHnzHFk
         pAWhbKBeNSNPKpvfE1yHgaytNPwnCYXE+/WPOOOkLsglWJN6RWAl/9tx9urUNH/LHt
         PpApmNtx/vWnS2SvJuCWrBTO3++gPDyOJeIkMZGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 705/717] Revert "net/ieee802154: reject zero-sized raw_sendmsg()"
Date:   Sat, 22 Oct 2022 09:29:44 +0200
Message-Id: <20221022072529.625640698@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index cbd0e2ac4ffe..7889e1ef7fad 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -251,9 +251,6 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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



