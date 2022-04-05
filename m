Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95394F3151
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiDEIh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbiDEIV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:21:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74266BC3A;
        Tue,  5 Apr 2022 01:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD355CE1BF3;
        Tue,  5 Apr 2022 08:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4637C385A0;
        Tue,  5 Apr 2022 08:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146770;
        bh=p4qOkgGo1/eyoeVeoSnjF3H2g47JG7CGB9P5oxsXQkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+XWc1pzqMLtf75U6M/wKunLDgsOa1ngaFndAdVk2QNL9GquBwQuPOWDp3ReXXpmV
         8lXmZJjCmefJ544lFzc8u59sG8PIbOXhKGU53PYnzHRq4cbkLnfFKKyS1J9399SqEu
         /ASQ54wDN/34RPYE0MdVf8WpS6TnbPsIRRtS3LTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rftc <rftc@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0844/1126] crypto: xts - Add softdep on ecb
Date:   Tue,  5 Apr 2022 09:26:31 +0200
Message-Id: <20220405070432.325069788@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



