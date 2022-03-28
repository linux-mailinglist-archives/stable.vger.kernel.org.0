Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950554E93D2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbiC1LZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241303AbiC1LXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6A0593A9;
        Mon, 28 Mar 2022 04:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA25E611BD;
        Mon, 28 Mar 2022 11:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912FBC340EC;
        Mon, 28 Mar 2022 11:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466431;
        bh=p4qOkgGo1/eyoeVeoSnjF3H2g47JG7CGB9P5oxsXQkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqnQmDx2im5mBqCmsC65tKlL9Tn9/jmBMJXAxCJidP9pOUJbLGDqPFnOlvrVExYSr
         H8emEdda9UkqGTvUpLwMUKX4ZwkUhmi5QXvE78fCzP4vr6QoT7Fnsgl0pJ0+EhhTYB
         nGX3m/DB8N9IRPhTAx1ZDWc21WiAhc37t/5BfCCQRZ+wJN3ZXn5w4oywA5TxDr6E7p
         Nw1ZxqFiA4rRVNd8E/i4nwN09t8kc0NgchhdGA2nFpdtsWJ4oTVESu3+uVKxHR1muF
         9nwFeGAoTWak9wLZfcIRmPSLt09YEYNXNvxyg6q74Vc+63yKWzsMP26USs+nPsypzG
         U2uiPn+yccquA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, rftc <rftc@gmx.de>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 11/35] crypto: xts - Add softdep on ecb
Date:   Mon, 28 Mar 2022 07:19:47 -0400
Message-Id: <20220328112011.1555169-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112011.1555169-1-sashal@kernel.org>
References: <20220328112011.1555169-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit dfe085d8dcd0bb1fe20cc2327e81c8064cead441 ]

The xts module needs ecb to be present as it's meant to work
on top of ecb.  This patch adds a softdep so ecb can be included
automatically into the initramfs.

Reported-by: rftc <rftc@gmx.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/xts.c b/crypto/xts.c
index 6c12f30dbdd6..63c85b9e64e0 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -466,3 +466,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
 MODULE_ALIAS_CRYPTO("xts");
 MODULE_IMPORT_NS(CRYPTO_INTERNAL);
+MODULE_SOFTDEP("pre: ecb");
-- 
2.34.1

