Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9845903A6
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiHKQ0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238129AbiHKQZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:25:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B840DFA1;
        Thu, 11 Aug 2022 09:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5736B821AE;
        Thu, 11 Aug 2022 16:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61860C433C1;
        Thu, 11 Aug 2022 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234014;
        bh=uKwMLGgnt8uS0p5ebOQ23qe32Pedis/Xf8xFcNBy+Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/nq0Mf/2N5Kvhj2/KUv3OpuxIDDJm7aHpK9+Mg3bwUydzDTyUZh7vXQ8Zfh7qDKf
         pTsxidSMjmQiBHAofJq37J5SgTHBJcK0KhBMJLoWB9HUqTplJon45IvmzansyUHZLf
         YCsjQQ90/7xFBkERfswx95URVs26OMJw0gtjHThq6evsvh86OxBaPTD5v4gPLF+7bB
         5UYq+6jJaCloN0mA0b49I64O3bCETpws3v7IvqZT8DWSxQ05u/i70CszpORdRyzvRk
         6DUu+LjI14TVmatJbk1ueUk6gd63WgfMCN7XtrgnNweWtGK2C4JIt3/KmUOog9cgwY
         NsDHVV/4zw+6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Breno Leitao <leitao@debian.org>,
        Sasha Levin <sashal@kernel.org>, nayna@linux.ibm.com,
        pfsmorigo@gmail.com, mpe@ellerman.id.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 30/46] crypto: vmx - Fix warning on p8_ghash_alg
Date:   Thu, 11 Aug 2022 12:03:54 -0400
Message-Id: <20220811160421.1539956-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index 14807ac2e3b9..e419be7381c9 100644
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

