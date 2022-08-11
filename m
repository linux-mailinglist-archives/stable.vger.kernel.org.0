Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7554459007D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiHKPlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbiHKPkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:40:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE74698A74;
        Thu, 11 Aug 2022 08:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36584B82157;
        Thu, 11 Aug 2022 15:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA78C433C1;
        Thu, 11 Aug 2022 15:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232177;
        bh=6sRasSLSlcwEFv1YfjylIL2Tv62U0qLVFef2gp8bkIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvmXfE3yzDQ2z8xa2isrxo6r4DxPTOj3152u8+zQTqxCwRM0fPwgzocJGpeFIodzX
         O/ZziC2Ph1FI43IhU/YambZpzDp8IFkWh/JZbtuzrRoCWRxRCFfIiPh3DAg2rqMMmc
         J2XUtC7R6LMFtyZlp0ryigONVyZC23D7+Zwchiw9yfBrHLHx/3jls5lWdWpwo2rmVQ
         IaifRdqZV0RS9pcupmsCw8ay39HWHz4JCuRggSg4tyLzDIlFRq1Ta5YT2K7tNcN0RA
         NCKOgB9T2W6BL3oHQ/TLppDPlUBkuMQBtVdRAIXEMQhFnILx5V4TM9IAUXKm3Es4Sl
         RpfYH+LzEoBBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Breno Leitao <leitao@debian.org>,
        Sasha Levin <sashal@kernel.org>, nayna@linux.ibm.com,
        pfsmorigo@gmail.com, mpe@ellerman.id.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 065/105] crypto: vmx - Fix warning on p8_ghash_alg
Date:   Thu, 11 Aug 2022 11:27:49 -0400
Message-Id: <20220811152851.1520029-65-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
index 5bc5710a6de0..77eca20bc7ac 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -23,6 +23,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/b128ops.h>
+#include "aesp8-ppc.h"
 
 void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
 void gcm_gmult_p8(u64 Xi[2], const u128 htable[16]);
-- 
2.35.1

