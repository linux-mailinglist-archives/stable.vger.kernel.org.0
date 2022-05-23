Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57824531C98
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbiEWRxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243874AbiEWRvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:51:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140C762122;
        Mon, 23 May 2022 10:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BC05611DF;
        Mon, 23 May 2022 17:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7F5C36AE3;
        Mon, 23 May 2022 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326951;
        bh=ReFu1Mc6+Zt9GNQWgQvuhxkurL2O6QAqaRyiafUG/h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8yHrZpDzldwFJtO4+LBx5SJOQlg+nSNg+6z4ypPKAM03TkhNPO4oEQM1Tji1K432
         8kqCJ5HNWIn0VzTYPfO4SXu6ojiQclVFmeoCAXt1wFPQV7r2t38tXt3Tpb7uJgWppB
         Xsx4pPhU9eIm0AkQAz/P6wNh3oYT/1CL0MdEVsgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 110/158] net: af_key: add check for pfkey_broadcast in function pfkey_process
Date:   Mon, 23 May 2022 19:04:27 +0200
Message-Id: <20220523165849.276567989@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 4dc2a5a8f6754492180741facf2a8787f2c415d7 ]

If skb_clone() returns null pointer, pfkey_broadcast() will
return error.
Therefore, it should be better to check the return value of
pfkey_broadcast() and return error if fails.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index fd51db3be91c..92e9d75dba2f 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2826,8 +2826,10 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	if (err)
+		return err;
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
-- 
2.35.1



