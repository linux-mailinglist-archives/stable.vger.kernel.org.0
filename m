Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C3C4F2C5B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349399AbiDEKup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiDEJnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E86248E65;
        Tue,  5 Apr 2022 02:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0AE5B81C9D;
        Tue,  5 Apr 2022 09:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA92C385A0;
        Tue,  5 Apr 2022 09:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150913;
        bh=2O2qi9G29+1tq670OXCv1SbgmBO+GBQAThVfE/FwPEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkcd2uI/3Ksdkfm6Y18GcXCa+2AF9IOSCZmua+mZM2nW/TTAJf3q8bWS7zpykuY3i
         ZUS+jRiOqvQhOLe3s8mL1WbZ2rFpLGt8SobJthuyYXTXPITu56l619Hw1gbGxqAtV9
         LelD8kGXoDKtSsU8mAbBnhL8W1kNtzr3qOju9NgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/913] crypto: gemini - call finalize with bh disabled
Date:   Tue,  5 Apr 2022 09:21:28 +0200
Message-Id: <20220405070346.631698308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 7f22421103c5a7f9a1726f0ed125274c38174ddb ]

Doing ipsec produces a spinlock recursion warning.
This is due to not disabling BH during crypto completion function.

Fixes: 46c5338db7bd45b2 ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index c1c2b1d86663..f2be0a7d7f7a 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -264,7 +264,9 @@ static int sl3516_ce_handle_cipher_request(struct crypto_engine *engine, void *a
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
 
 	err = sl3516_ce_cipher(breq);
+	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, breq, err);
+	local_bh_enable();
 
 	return 0;
 }
-- 
2.34.1



