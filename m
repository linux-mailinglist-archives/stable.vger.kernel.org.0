Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE12593D37
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbiHOUCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346211AbiHOUBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F17D1D2;
        Mon, 15 Aug 2022 11:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29147B810A2;
        Mon, 15 Aug 2022 18:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746FBC433C1;
        Mon, 15 Aug 2022 18:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589635;
        bh=vDkvebUt7MZA8+U3hS5joEOkD7qc/yPP/d1mBQwSSSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0c/NMwkaW1FioGdS3uC/aME3rs3lNq+8Lo83Rl7X93MqcyT9tbKH28Rn6DMZnRpj
         /++reb+quQuAhhz/9SIxT6PEKSmYIVpOj3OSdve7wnmnvNjnPk8p/3lC/+1+M1oEVv
         U2k2TdPpczjZ1+ViJhU4iyH/5FJ9U/CSqFbKpBd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 764/779] crypto: lib/blake2s - reduce stack frame usage in self test
Date:   Mon, 15 Aug 2022 20:06:48 +0200
Message-Id: <20220815180410.068767541@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit d6c14da474bf260d73953fbf7992c98d9112aec7 upstream.

Using 3 blocks here doesn't give us much more than using 2, and it
causes a stack frame size warning on certain compiler/config/arch
combinations:

   lib/crypto/blake2s-selftest.c: In function 'blake2s_selftest':
>> lib/crypto/blake2s-selftest.c:632:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     632 | }
         | ^

So this patch just reduces the block from 3 to 2, which makes the
warning go away.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-crypto/202206200851.gE3MHCgd-lkp@intel.com
Fixes: 2d16803c562e ("crypto: blake2s - remove shash module")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/blake2s-selftest.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/crypto/blake2s-selftest.c
+++ b/lib/crypto/blake2s-selftest.c
@@ -593,7 +593,7 @@ bool __init blake2s_selftest(void)
 		enum { TEST_ALIGNMENT = 16 };
 		u8 unaligned_block[BLAKE2S_BLOCK_SIZE + TEST_ALIGNMENT - 1]
 					__aligned(TEST_ALIGNMENT);
-		u8 blocks[BLAKE2S_BLOCK_SIZE * 3];
+		u8 blocks[BLAKE2S_BLOCK_SIZE * 2];
 		struct blake2s_state state1, state2;
 
 		get_random_bytes(blocks, sizeof(blocks));
@@ -603,8 +603,8 @@ bool __init blake2s_selftest(void)
     defined(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S)
 		memcpy(&state1, &state, sizeof(state1));
 		memcpy(&state2, &state, sizeof(state2));
-		blake2s_compress(&state1, blocks, 3, BLAKE2S_BLOCK_SIZE);
-		blake2s_compress_generic(&state2, blocks, 3, BLAKE2S_BLOCK_SIZE);
+		blake2s_compress(&state1, blocks, 2, BLAKE2S_BLOCK_SIZE);
+		blake2s_compress_generic(&state2, blocks, 2, BLAKE2S_BLOCK_SIZE);
 		if (memcmp(&state1, &state2, sizeof(state1))) {
 			pr_err("blake2s random compress self-test %d: FAIL\n",
 			       i + 1);


