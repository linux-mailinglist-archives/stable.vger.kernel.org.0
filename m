Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A52593644
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243490AbiHOSwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244482AbiHOSvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:51:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC83459BC;
        Mon, 15 Aug 2022 11:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB528CE1264;
        Mon, 15 Aug 2022 18:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703DBC433C1;
        Mon, 15 Aug 2022 18:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588149;
        bh=8NDVX8rGIyuK8un0KHxKdn2+1yKhDm+2GnDz3ZQSE4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTXlv3SxIZ9/0GHsVMtT1hq4jNplVPC2FazjdNoktnKGSVgg096oDflRZv23LFjeJ
         iGz6sH6WW8eKZjpcCTfjCZAYZETr9YdD/f8NIK4L7GMGUORjeIXTcFilvLOF0b7tkZ
         opSwfvlW7yPe2075JZ4TYGlar/UuNNl/wH8p8LN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <quic_qiancai@quicinc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/779] crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE
Date:   Mon, 15 Aug 2022 19:59:14 +0200
Message-Id: <20220815180350.547966746@linuxfoundation.org>
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

From: Qian Cai <quic_qiancai@quicinc.com>

[ Upstream commit fac76f2260893dde5aa05bb693b4c13e8ed0454b ]

Otherwise, we could fail to compile.

ld: arch/arm64/crypto/ghash-ce-glue.o: in function 'ghash_ce_mod_exit':
ghash-ce-glue.c:(.exit.text+0x24): undefined reference to 'crypto_unregister_aead'
ld: arch/arm64/crypto/ghash-ce-glue.o: in function 'ghash_ce_mod_init':
ghash-ce-glue.c:(.init.text+0x34): undefined reference to 'crypto_register_aead'

Fixes: 537c1445ab0b ("crypto: arm64/gcm - implement native driver using v8 Crypto Extensions")
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 55f19450091b..1a5406e599ba 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -59,6 +59,7 @@ config CRYPTO_GHASH_ARM64_CE
 	select CRYPTO_HASH
 	select CRYPTO_GF128MUL
 	select CRYPTO_LIB_AES
+	select CRYPTO_AEAD
 
 config CRYPTO_CRCT10DIF_ARM64_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
-- 
2.35.1



