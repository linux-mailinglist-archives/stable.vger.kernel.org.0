Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2ED6215D1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiKHOPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiKHOPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878C55F851
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23887615C0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1591AC433D6;
        Tue,  8 Nov 2022 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916942;
        bh=EZKAt9H+mjJFr0LaOA2SIl2Jhj2CoB8ycuzkpn1tskU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn41AAnvN+BTVxkVKMvJ9e5UZo17WywmEk//CFVDPkKPVn+7ZDnAG6UURWiLjn6jJ
         1VhgLe36C8zfyVMF6MVDdQy2d6/CHf7HKujxJunHrJlh/foLpuJJNYD6ndwUW/R1cQ
         voDr7B7NJHlm6GJQbyoHgks259ZazaDXUqfveEiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.0 153/197] net/ulp: remove SOCK_SUPPORT_ZC from tls sockets
Date:   Tue,  8 Nov 2022 14:39:51 +0100
Message-Id: <20221108133401.916072735@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit e276d62dcfdee6582486e8b8344dd869518e14be upstream.

Remove SOCK_SUPPORT_ZC when we're setting ulp as it might not support
msghdr::ubuf_info, e.g. like TLS replacing ->sk_prot with a new set of
handlers.

Cc: <stable@vger.kernel.org> # 6.0
Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: e993ffe3da4bc ("net: flag sockets supporting msghdr originated zerocopy")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ulp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 7c27aa629af1..9ae50b1bd844 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -136,6 +136,9 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (icsk->icsk_ulp_ops)
 		goto out_err;
 
+	if (sk->sk_socket)
+		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;
-- 
2.38.1



