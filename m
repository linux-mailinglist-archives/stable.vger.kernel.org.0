Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6992A4C0DFE
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 09:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiBWIEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 03:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiBWIEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 03:04:38 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BF467A99C;
        Wed, 23 Feb 2022 00:04:12 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B412BED1;
        Wed, 23 Feb 2022 00:04:11 -0800 (PST)
Received: from e122247.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A356B3F5A1;
        Wed, 23 Feb 2022 00:04:09 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: drbg: fix crypto api abuse
Date:   Wed, 23 Feb 2022 10:04:00 +0200
Message-Id: <20220223080400.139367-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

the drbg code was binding the same buffer to two different
scatter gather lists and submitting those as source and
destination to a crypto api operation, thus potentially
causing HW crypto drivers to perform overlapping DMA
mappings which are not aware it is the same buffer.

This can have serious consequences of data corruption of
internal DRBG buffers and wrong RNG output.

Fix this by reusing the same scatter gatther list for both
src and dst.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: r8a7795-salvator-x
Tested-on: xilinx-zc706
Fixes: 43490e8046b5d ("crypto: drbg - in-place cipher operation for CTR")
Cc: stable@vger.kernel.org
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 177983b6ae38..13824fd27627 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1851,7 +1851,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 		/* Use scratchpad for in-place operation */
 		inlen = scratchpad_use;
 		memset(drbg->outscratchpad, 0, scratchpad_use);
-		sg_set_buf(sg_in, drbg->outscratchpad, scratchpad_use);
+		sg_in = sg_out;
 	}
 
 	while (outlen) {
-- 
2.25.1

