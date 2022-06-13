Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CE548C70
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355868AbiFMLrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357465AbiFMLqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:46:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8BA25DD;
        Mon, 13 Jun 2022 03:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7E36B80E59;
        Mon, 13 Jun 2022 10:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB4AC34114;
        Mon, 13 Jun 2022 10:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117538;
        bh=B3CqHOh+r9Ah6UrcI7btJ319nsIqtZeEw+NhcbAMHUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6WTcSC9hNHsp+o7FFO9AyYV+s9zMARAUNSq5lfasuEgxHDzRkOAsOVher/TV65J9
         Jz8Uh5Jp0iBIE2R8XJjg5Uj6JuMWYe/KnhQD5P0jWvFax56z5B7Cim5q2EyPDdKZwR
         YMMKjSCDun3hMGv1avWeAuCxfR3W6TaIJJZHjWhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 387/411] Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"
Date:   Mon, 13 Jun 2022 12:11:00 +0200
Message-Id: <20220613094940.276049065@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit 9c90c9b3e50e16d03c7f87d63e9db373974781e0 ]

This reverts commit 4dc2a5a8f6754492180741facf2a8787f2c415d7.

A non-zero return value from pfkey_broadcast() does not necessarily mean
an error occurred as this function returns -ESRCH when no registered
listener received the message. In particular, a call with
BROADCAST_PROMISC_ONLY flag and null one_sk argument can never return
zero so that this commit in fact prevents processing any PF_KEY message.
One visible effect is that racoon daemon fails to find encryption
algorithms like aes and refuses to start.

Excluding -ESRCH return value would fix this but it's not obvious that
we really want to bail out here and most other callers of
pfkey_broadcast() also ignore the return value. Also, as pointed out by
Steffen Klassert, PF_KEY is kind of deprecated and newer userspace code
should use netlink instead so that we should only disturb the code for
really important fixes.

v2: add a comment explaining why is the return value ignored

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index dd064d5eff6e..32fe99cd01fc 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2830,10 +2830,12 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
-	if (err)
-		return err;
+	/* Non-zero return value of pfkey_broadcast() does not always signal
+	 * an error and even on an actual error we may still want to process
+	 * the message so rather ignore the return value.
+	 */
+	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
-- 
2.35.1



