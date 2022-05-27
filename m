Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F2B535CC7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244676AbiE0JCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350811AbiE0JAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60818BC6D9;
        Fri, 27 May 2022 01:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 422C8CE238F;
        Fri, 27 May 2022 08:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22770C34100;
        Fri, 27 May 2022 08:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641823;
        bh=nLdAsEGvnPJOV1DT4zKmSsg8xSsGXYqF6g9l0kyd1rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6VQjbbY4H3TE1mP5hdJPL+sPZWRxs5xeLDdo8HHEXiaT7iIM/3moHW+IurLDln/J
         uYENpEl1hXoJ71/KrV1hiG8EAs88gTs4tWwHdBZhy49USYNhgPP25zUCTILRGUYD9N
         mBsth2cUn2moPK+l2VbagaliUg6s+zNJHRDMHnfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 015/163] crypto: lib/blake2s - Move selftest prototype into header file
Date:   Fri, 27 May 2022 10:48:15 +0200
Message-Id: <20220527084830.306314203@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit ce0d5d63e897cc7c3a8fd043c7942fc6a78ec6f4 upstream.

This patch fixes a missing prototype warning on blake2s_selftest.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/internal/blake2s.h |    2 ++
 lib/crypto/blake2s-selftest.c     |    2 +-
 lib/crypto/blake2s.c              |    2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -16,6 +16,8 @@ void blake2s_compress_generic(struct bla
 void blake2s_compress_arch(struct blake2s_state *state,const u8 *block,
 			   size_t nblocks, const u32 inc);
 
+bool blake2s_selftest(void);
+
 static inline void blake2s_set_lastblock(struct blake2s_state *state)
 {
 	state->f[0] = -1;
--- a/lib/crypto/blake2s-selftest.c
+++ b/lib/crypto/blake2s-selftest.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#include <crypto/blake2s.h>
+#include <crypto/internal/blake2s.h>
 #include <linux/string.h>
 
 /*
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -17,8 +17,6 @@
 #include <linux/bug.h>
 #include <asm/unaligned.h>
 
-bool blake2s_selftest(void);
-
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 {
 	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;


