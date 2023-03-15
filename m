Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8926BB25E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjCOMfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjCOMf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9F061888
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB72EB81E0D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D940C433EF;
        Wed, 15 Mar 2023 12:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883640;
        bh=05b9O+id9fdWxUMUqvGYbjFpl4C6EGrQ82+VpQIesVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1hrOsfWpcJ9tYFa3hAMW1WJf8W1YbhhqcXWbNXkhNVwgTH3nyXjbskQ/pKoIbf0/
         yhBA4oom4gUYeKJQ9LbpmJXkIdgxo8pfc1tP5KV+mBAqUdc2VSxmFUMbBj2xWVK0pb
         h+Yp11mJJbw5I3PoLAzKsHDXKbjJ71U7Yu22Bx9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/143] net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Date:   Wed, 15 Mar 2023 13:12:40 +0100
Message-Id: <20230315115742.798553090@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 49c47cc21b5b7a3d8deb18fc57b0aa2ab1286962 ]

ctx->crypto_send.info is not protected by lock_sock in
do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
and error paths of do_tls_setsockopt_conf() may lead to a use-after-free
or null-deref.

More discussion:  https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20230228023344.9623-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3735cb00905df..b32c112984dd9 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -405,13 +405,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -429,13 +427,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -451,13 +447,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(aes_ccm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_CCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_CCM_128_IV_SIZE);
 		memcpy(aes_ccm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, aes_ccm_128, sizeof(*aes_ccm_128)))
 			rc = -EFAULT;
 		break;
@@ -472,13 +466,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(chacha20_poly1305->iv,
 		       cctx->iv + TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE,
 		       TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE);
 		memcpy(chacha20_poly1305->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, chacha20_poly1305,
 				sizeof(*chacha20_poly1305)))
 			rc = -EFAULT;
@@ -493,13 +485,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(sm4_gcm_info->iv,
 		       cctx->iv + TLS_CIPHER_SM4_GCM_SALT_SIZE,
 		       TLS_CIPHER_SM4_GCM_IV_SIZE);
 		memcpy(sm4_gcm_info->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_SM4_GCM_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, sm4_gcm_info, sizeof(*sm4_gcm_info)))
 			rc = -EFAULT;
 		break;
@@ -513,13 +503,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(sm4_ccm_info->iv,
 		       cctx->iv + TLS_CIPHER_SM4_CCM_SALT_SIZE,
 		       TLS_CIPHER_SM4_CCM_IV_SIZE);
 		memcpy(sm4_ccm_info->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, sm4_ccm_info, sizeof(*sm4_ccm_info)))
 			rc = -EFAULT;
 		break;
@@ -535,13 +523,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aria_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_ARIA_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_ARIA_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aria_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aria_gcm_128,
 				 sizeof(*crypto_info_aria_gcm_128)))
@@ -559,13 +545,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aria_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_ARIA_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_ARIA_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aria_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aria_gcm_256,
 				 sizeof(*crypto_info_aria_gcm_256)))
@@ -614,11 +598,9 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 	if (len < sizeof(value))
 		return -EINVAL;
 
-	lock_sock(sk);
 	value = -EINVAL;
 	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
 		value = ctx->rx_no_pad;
-	release_sock(sk);
 	if (value < 0)
 		return value;
 
@@ -635,6 +617,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 	case TLS_RX:
@@ -651,6 +635,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
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



