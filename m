Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B7C500EFA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243294AbiDNNXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244163AbiDNNWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:22:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEFB98F5E;
        Thu, 14 Apr 2022 06:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC7760BAF;
        Thu, 14 Apr 2022 13:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9E5C385A1;
        Thu, 14 Apr 2022 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942275;
        bh=OpD1BDYPwMtTDZCSK+H85PSOkBIsB6lrv4Odz2brAJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2VGkjpOcaS6+nb3ZFUqX5BL56TdgfibeSsBTXTH/d04EF6uz4ycqyApJvvstFZja
         HvLdQeZ/EnBgqim8krlPaurmbii4gp7iOVO3vXEzc775ZEbnYlSZNxGK3hngi2yFNp
         VdLDHQjWX3azrb8yZEszzH52ldVWWLQBV/VvDcMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Petr Vorel <pvorel@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/338] crypto: vmx - add missing dependencies
Date:   Thu, 14 Apr 2022 15:09:41 +0200
Message-Id: <20220414110841.119838433@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Petr Vorel <pvorel@suse.cz>

[ Upstream commit 647d41d3952d726d4ae49e853a9eff68ebad3b3f ]

vmx-crypto module depends on CRYPTO_AES, CRYPTO_CBC, CRYPTO_CTR or
CRYPTO_XTS, thus add them.

These dependencies are likely to be enabled, but if
CRYPTO_DEV_VMX=y && !CRYPTO_MANAGER_DISABLE_TESTS
and either of CRYPTO_AES, CRYPTO_CBC, CRYPTO_CTR or CRYPTO_XTS is built
as module or disabled, alg_test() from crypto/testmgr.c complains during
boot about failing to allocate the generic fallback implementations
(2 == ENOENT):

[    0.540953] Failed to allocate xts(aes) fallback: -2
[    0.541014] alg: skcipher: failed to allocate transform for p8_aes_xts: -2
[    0.541120] alg: self-tests for p8_aes_xts (xts(aes)) failed (rc=-2)
[    0.544440] Failed to allocate ctr(aes) fallback: -2
[    0.544497] alg: skcipher: failed to allocate transform for p8_aes_ctr: -2
[    0.544603] alg: self-tests for p8_aes_ctr (ctr(aes)) failed (rc=-2)
[    0.547992] Failed to allocate cbc(aes) fallback: -2
[    0.548052] alg: skcipher: failed to allocate transform for p8_aes_cbc: -2
[    0.548156] alg: self-tests for p8_aes_cbc (cbc(aes)) failed (rc=-2)
[    0.550745] Failed to allocate transformation for 'aes': -2
[    0.550801] alg: cipher: Failed to load transform for p8_aes: -2
[    0.550892] alg: self-tests for p8_aes (aes) failed (rc=-2)

Fixes: c07f5d3da643 ("crypto: vmx - Adding support for XTS")
Fixes: d2e3ae6f3aba ("crypto: vmx - Enabling VMX module for PPC64")

Suggested-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/vmx/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
index c3d524ea6998..f39eeca87932 100644
--- a/drivers/crypto/vmx/Kconfig
+++ b/drivers/crypto/vmx/Kconfig
@@ -1,7 +1,11 @@
 config CRYPTO_DEV_VMX_ENCRYPT
 	tristate "Encryption acceleration support on P8 CPU"
 	depends on CRYPTO_DEV_VMX
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_CTR
 	select CRYPTO_GHASH
+	select CRYPTO_XTS
 	default m
 	help
 	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
-- 
2.34.1



