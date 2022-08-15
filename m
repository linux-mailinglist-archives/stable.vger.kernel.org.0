Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EADE593F27
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbiHOVJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347896AbiHOVHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A35247C;
        Mon, 15 Aug 2022 12:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01950B8107A;
        Mon, 15 Aug 2022 19:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D93BC433D6;
        Mon, 15 Aug 2022 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590980;
        bh=LirXWrjAmt9goQwEFSLoY6YoxSifPxKeann4ZciL/hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDUy/XulmV7Rs2QYyQgAtGFp0x6rb0iLrwYf1w+veivGJD2V7JbNBfWP7h5f2El+x
         ric1ruIkhRl7BBFx8V/tfd8XU3LySm0i59syzwnWdt9v6fCUkS8yDkNvDQzwAw+++K
         nhrnodNZhU4nyYU1EEuUV9Ipv2FK3LaSK4s3slWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <quic_qiancai@quicinc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0402/1095] crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE
Date:   Mon, 15 Aug 2022 19:56:41 +0200
Message-Id: <20220815180446.326140313@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 2a965aa0188d..bdca34283c06 100644
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



