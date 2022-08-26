Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EAB5A2019
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 07:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiHZFFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 01:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiHZFFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 01:05:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131921CFE3;
        Thu, 25 Aug 2022 22:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C155CB82F77;
        Fri, 26 Aug 2022 05:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306AAC433C1;
        Fri, 26 Aug 2022 05:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661490306;
        bh=8yQmsLqSZ3CuFmHZG83IrH41ZXlR5zI210dsVdUm9/0=;
        h=From:To:Cc:Subject:Date:From;
        b=o5pUNKFLdz2De65FImK8eRL+RZP1ZMKFXAfOUUrzWZMOQ0pJtVW1w8gNYusDmQua7
         Y0yORGvnxuYDMV12ID6LA6ZDmAoP6NoZgLfEVtNNzKaOojdGhe1h3ry4VF7lGQLzwl
         hMspS6OlRLUQKx4kg+nNjqzL9635eVR6VNbightJtPuwzHzOL/ZvPpMXun8dyFojTe
         GGUxXT8EJc0ZKATV8dg1z7eNhgjjvgtt0dI8OhHUQReDXBAuYfmtEJdZZtlgmi2ykX
         c3g0Kdz7nF5e7CgiVyWM0YhBv4x0MjZZRiGZCiPfwSj2QkYViPixQUsQ9K1G8ck5rh
         JjSaJvx8+Nruw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A . Donenfeld " <Jason@zx2c4.com>,
        "Justin M . Forbes" <jforbes@fedoraproject.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] crypto: lib - remove unneeded selection of XOR_BLOCKS
Date:   Thu, 25 Aug 2022 22:04:56 -0700
Message-Id: <20220826050456.101321-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
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

From: Eric Biggers <ebiggers@google.com>

CRYPTO_LIB_CHACHA_GENERIC doesn't need to select XOR_BLOCKS.  It perhaps
was thought that it's needed for __crypto_xor, but that's not the case.

Enabling XOR_BLOCKS is problematic because the XOR_BLOCKS code runs a
benchmark when it is initialized.  That causes a boot time regression on
systems that didn't have it enabled before.

Therefore, remove this unnecessary and problematic selection.

Fixes: e56e18985596 ("lib/crypto: add prompts back to crypto libraries")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I've separated this fix out from the larger patch
https://lore.kernel.org/r/20220725183636.97326-3-ebiggers@kernel.org
that is currently queued in cryptodev.

 lib/crypto/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 9ff549f63540fa..47816af9a9d7e1 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -33,7 +33,6 @@ config CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
-	select XOR_BLOCKS
 	help
 	  This symbol can be depended upon by arch implementations of the
 	  ChaCha library interface that require the generic code as a

base-commit: 4c612826bec1441214816827979b62f84a097e91
-- 
2.37.2

