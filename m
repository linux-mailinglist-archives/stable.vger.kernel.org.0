Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4936755DBBF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiF0L1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiF0L0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87E6959F;
        Mon, 27 Jun 2022 04:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A1FD61460;
        Mon, 27 Jun 2022 11:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334DAC341CE;
        Mon, 27 Jun 2022 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329160;
        bh=mnlmFhlBhAnytYcq6cbd2riKVfryEK43KZQadNNdEQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Awf4EMKAB0JhmDhm3zDGEEZZKei1RixWQdWBAhf19b6pHwRqNfhLJYDiAYoGJis9d
         pjbAmwN1YBkwoiXsd1p4EwER5kuMtxkiHBlnSTAywMim+g4rSj1tHpg37DERdNQiuz
         1vjyW1ZMtwSfD1OwUHGmjxookMAkKCphcSKauH3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+29c3c12f3214b85ad081@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/102] net/tls: fix tls_sk_proto_close executed repeatedly
Date:   Mon, 27 Jun 2022 13:20:54 +0200
Message-Id: <20220627111934.749726236@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 69135c572d1f84261a6de2a1268513a7e71753e2 ]

After setting the sock ktls, update ctx->sk_proto to sock->sk_prot by
tls_update(), so now ctx->sk_proto->close is tls_sk_proto_close(). When
close the sock, tls_sk_proto_close() is called for sock->sk_prot->close
is tls_sk_proto_close(). But ctx->sk_proto->close() will be executed later
in tls_sk_proto_close(). Thus tls_sk_proto_close() executed repeatedly
occurred. That will trigger the following bug.

=================================================================
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:tls_sk_proto_close+0xd8/0xaf0 net/tls/tls_main.c:306
Call Trace:
 <TASK>
 tls_sk_proto_close+0x356/0xaf0 net/tls/tls_main.c:329
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365

Updating a proto which is same with sock->sk_prot is incorrect. Add proto
and sock->sk_prot equality check at the head of tls_update() to fix it.

Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
Reported-by: syzbot+29c3c12f3214b85ad081@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 58d22d6b86ae..9492528f5852 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -787,6 +787,9 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
+	if (sk->sk_prot == p)
+		return;
+
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
-- 
2.35.1



