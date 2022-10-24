Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058C060AD18
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiJXORp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiJXOQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:16:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDC9CAE4A;
        Mon, 24 Oct 2022 05:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F2561290;
        Mon, 24 Oct 2022 12:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9718BC433D6;
        Mon, 24 Oct 2022 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616154;
        bh=7X3IdLQdh7zjat+57mnHYiuJREYSPETHVpUBq0JY8S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zridC8fbJGKAQQ8hhXi4pJfVmrSn3LIbBjk29wVGNXUcIANgaSrSdg52GYzo3cOX2
         fwvAF5k0lDghk9VDS4PTmf6V9ujrkCHSKLVzAgaagPUpa4EkUTlXUEjlTqctctCDml
         j9ecRgpzlToHTFQpMXhXl5fNlptqVVCKuLJeN1Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/530] Revert "net/ieee802154: reject zero-sized raw_sendmsg()"
Date:   Mon, 24 Oct 2022 13:34:25 +0200
Message-Id: <20221024113108.580018779@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index f160cfc3e8f0..fd5862f9e26a 100644
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



