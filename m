Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B316D4740
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjDCOSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbjDCOSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57932952D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7097261A2D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E0C4339B;
        Mon,  3 Apr 2023 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531517;
        bh=VPNXqtJay/NDsyz6ETXPJ12aCdP/GFaBQ9c43DwefPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRu4quTs6mqrhLWWnIBDvePlTc2GlVayB/6N3yz6YVoOIJ9hQ6matCk40uxrzzS3f
         NaSNsamlDUWURHVm+34DV/x3vNyaAteFfV/h0tgXdIGREYxiSYyDiu4uxkmPO3l4Yh
         u0VfC2AFdcRqc9j2RmnPfaGa3IhWbeuzz3XZf+S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Meena Shanmugam <meenashanmugam@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/104] net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Date:   Mon,  3 Apr 2023 16:07:53 +0200
Message-Id: <20230403140403.847323570@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 49c47cc21b5b7a3d8deb18fc57b0aa2ab1286962 upstream.

ctx->crypto_send.info is not protected by lock_sock in
do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
and error paths of do_tls_setsockopt_conf() may lead to a use-after-free
or null-deref.

More discussion:  https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20230228023344.9623-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7aba4ee77aba3..cb51a2f46b11d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -371,13 +371,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -395,13 +393,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -421,6 +417,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 		rc = do_tls_getsockopt_tx(sk, optval, optlen);
@@ -429,6 +427,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = -ENOPROTOOPT;
 		break;
 	}
+
+	release_sock(sk);
+
 	return rc;
 }
 
-- 
2.39.2



