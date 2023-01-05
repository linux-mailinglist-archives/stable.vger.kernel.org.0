Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258F165EC65
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbjAENJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbjAENI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:08:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A715A8B0
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5517ACE1AD0
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C452C433EF;
        Thu,  5 Jan 2023 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672924114;
        bh=vO1ewa/Miew2TXPc90Oe5RNcqAZT0nj5paSJNmiJc4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0OrPk1+4xvmM30kzMtDU5BWNjhkguQJ9wYKujEC28hfdAr+lrRFxVsDHN8eOEoXw
         syWDqAteMdg9gzkp5d1iilsL/0rRDapom5pzaXoEl62PU6crCri8VX6tqIyonxJHME
         R/Q1rc5/+I4MFeojk4XcD96iN4YTJ0by71Oa6tpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, stable@kernel.org
Subject: [PATCH 4.9 239/251] crypto: n2 - add missing hash statesize
Date:   Thu,  5 Jan 2023 13:56:16 +0100
Message-Id: <20230105125345.818293656@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Corentin Labbe <clabbe@baylibre.com>

commit 76a4e874593543a2dff91d249c95bac728df2774 upstream.

Add missing statesize to hash templates.
This is mandatory otherwise no algorithms can be registered as the core
requires statesize to be set.

CC: stable@kernel.org # 4.3+
Reported-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Fixes: 0a625fd2abaa ("crypto: n2 - Add Niagara2 crypto driver")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/n2_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1271,6 +1271,7 @@ struct n2_hash_tmpl {
 	const u32	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1302,6 +1303,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1310,6 +1312,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1318,6 +1321,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1326,6 +1330,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1465,6 +1470,7 @@ static int __n2_register_one_ahash(const
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);


