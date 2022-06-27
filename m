Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC7455DA05
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiF0Lxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiF0LvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45749655E;
        Mon, 27 Jun 2022 04:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBE20B80DFB;
        Mon, 27 Jun 2022 11:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2A7C3411D;
        Mon, 27 Jun 2022 11:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330259;
        bh=gWzTgie9Nra0hMwrYC2G+Zrey5VdDZ6WS9sye20VHUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJTpHgK3M2FFRsb7ylzOoI4K4A9TPORh/9CWYpDwppkQhad0aZUJDattXdw7io3IB
         2ut3E0sEWgfeIIdgPHGWFK8QjR2k0XbjFWK5IaFj0ik5rrhv701F8wXtM/l/cgfpiQ
         Ql2LBZS1lYs/LO25tnKoflXb3Q43jRy/AVmU8ksI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 097/181] Revert "net/tls: fix tls_sk_proto_close executed repeatedly"
Date:   Mon, 27 Jun 2022 13:21:10 +0200
Message-Id: <20220627111947.372126973@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1b205d948fbb06a7613d87dcea0ff5fd8a08ed91 ]

This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.

This commit was just papering over the issue, ULP should not
get ->update() called with its own sk_prot. Each ULP would
need to add this check.

Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20220620191353.1184629-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fc60bef83f90..7b2b0e7ffee4 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -873,9 +873,6 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
-	if (sk->sk_prot == p)
-		return;
-
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
-- 
2.35.1



