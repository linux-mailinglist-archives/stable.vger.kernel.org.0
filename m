Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0D9590439
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbiHKQcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238957AbiHKQbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:31:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931EDBE0;
        Thu, 11 Aug 2022 09:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 407CEB821B4;
        Thu, 11 Aug 2022 16:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3DC43140;
        Thu, 11 Aug 2022 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234212;
        bh=Pg+XfWgrtZFFlriEM+X/TBribzCudz9MXofwvQyATJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I370Tn1yk+5CGUL3EnrFHbdMxySqVYhFxcDWUoaUcT0lb6+dfGKbn5kS8mjn8YRfM
         YKNuE3bLNnF2/Z1Qdk88Hr3ealrFBQFsSdkeZdqzlUIpnYsspSuECd/NtED1V2EH2P
         zG/zx0ctjb3juctoeKouwmbmmbXqtaRSQL07IWvUtu2gkYlrqNHnQwWd6usAazbVTz
         jdAazX4VdID/huDKRuoYgbSGWYtne7nISCvgTPsyX5UoxlCoAud2DFhe+kqFOCq9N9
         bEPFsgGYk61Az1w7cGuV5HpEYB8TV9C46mTAH0RGV3aydxpwUPZRxGAInTZWOidu6T
         fXjVwu1aQdf+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Breno Leitao <leitao@debian.org>,
        Sasha Levin <sashal@kernel.org>, nayna@linux.ibm.com,
        pfsmorigo@gmail.com, mpe@ellerman.id.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 08/14] crypto: vmx - Fix warning on p8_ghash_alg
Date:   Thu, 11 Aug 2022 12:09:36 -0400
Message-Id: <20220811160948.1542842-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160948.1542842-1-sashal@kernel.org>
References: <20220811160948.1542842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit cc8166bfc829043020b5cc3b7cdba02a17d03b6d ]

The compiler complains that p8_ghash_alg isn't declared which is
because the header file aesp8-ppc.h isn't included in ghash.c.
This patch fixes the warning.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/vmx/ghash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 2d1a8cd35509..b1b067203426 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -22,6 +22,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 #include <crypto/b128ops.h>
+#include "aesp8-ppc.h"
 
 #define IN_INTERRUPT in_interrupt()
 
-- 
2.35.1

