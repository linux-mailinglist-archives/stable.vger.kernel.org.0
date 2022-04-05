Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB604F3013
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbiDEJLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244681AbiDEIwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5B2D76D1;
        Tue,  5 Apr 2022 01:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B0960FFB;
        Tue,  5 Apr 2022 08:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687E9C385A3;
        Tue,  5 Apr 2022 08:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148113;
        bh=2O2qi9G29+1tq670OXCv1SbgmBO+GBQAThVfE/FwPEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtoMu2Qm8nfExsTi0ZzQ0Jo8aUq9g3g4cgTOeQdsH3My2cvEf4JkXbQijY89PPci9
         fPOLGu29T3rx1BqkEU3EsvT2jMT2UXZmaj3o0EEqb8/GGo2wPVTSCYdZ1duSFA1Az9
         4ncqwv51GVY9qfGwskhJejX5c7pYT9RD7owOnETA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0239/1017] crypto: gemini - call finalize with bh disabled
Date:   Tue,  5 Apr 2022 09:19:12 +0200
Message-Id: <20220405070401.351219897@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



