Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36245AAFD0
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbiIBMoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbiIBMnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CAEEA882;
        Fri,  2 Sep 2022 05:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2457B82AC9;
        Fri,  2 Sep 2022 12:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A26BC4347C;
        Fri,  2 Sep 2022 12:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121921;
        bh=K07g13l32rClJcNoxbLcDmonK4zHo/OsvyUnY5GNgG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6pgUYJZrSFKYp2Xw3kmWaAmHyXVkWNwx2utBm3esCBN0IOlG7tHRudY6PgtGQBGY
         1S95xZPM3ZJmNL2r1rGUtC0UYfCTeu2KKQiDN2qxuCt1NAjnM2N97eFgqKiqwWHtuL
         drZFLwBuQvfXiHirYmv9PNXMJrGOa1+ZFYMHL67Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 07/73] crypto: lib - remove unneeded selection of XOR_BLOCKS
Date:   Fri,  2 Sep 2022 14:18:31 +0200
Message-Id: <20220902121404.687586651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 874b301985ef2f89b8b592ad255e03fb6fbfe605 upstream.

CRYPTO_LIB_CHACHA_GENERIC doesn't need to select XOR_BLOCKS.  It perhaps
was thought that it's needed for __crypto_xor, but that's not the case.

Enabling XOR_BLOCKS is problematic because the XOR_BLOCKS code runs a
benchmark when it is initialized.  That causes a boot time regression on
systems that didn't have it enabled before.

Therefore, remove this unnecessary and problematic selection.

Fixes: e56e18985596 ("lib/crypto: add prompts back to crypto libraries")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -33,7 +33,6 @@ config CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
-	select XOR_BLOCKS
 	help
 	  This symbol can be depended upon by arch implementations of the
 	  ChaCha library interface that require the generic code as a


