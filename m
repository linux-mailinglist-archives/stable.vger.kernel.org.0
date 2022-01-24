Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A3249A338
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386344AbiAXX5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845987AbiAXXOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148CDC09425D;
        Mon, 24 Jan 2022 11:48:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A77FE614BB;
        Mon, 24 Jan 2022 19:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C47C340E5;
        Mon, 24 Jan 2022 19:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053714;
        bh=f21MzGFvooadYexLUcwxb1T6t4IyhWjyJE0ILpkgpd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8SVuJYM1jxrOJ2Z4g3sQ4ijb0UCKmXO0XvDZ438zozri5UuvDBIncKfsbGsUZczC
         InIflB162PkT5DZEuEUaUvITL0NxjUgl/NbJnzab+UrYD060m+1eesCWYwsitBLZXo
         5wxykPTK/J+UbsUHkUP1pAS8HlfpFw/eHwSVbchg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/563] crypto: stm32/cryp - fix CTR counter carry
Date:   Mon, 24 Jan 2022 19:38:39 +0100
Message-Id: <20220124184029.722778646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>

[ Upstream commit 41c76690b0990efacd15d35cfb4e77318cd80ebb ]

STM32 CRYP hardware doesn't manage CTR counter bigger than max U32, as
a workaround, at each block the current IV is saved, if the saved IV
lower u32 is 0xFFFFFFFF, the full IV is manually incremented, and set
in hardware.
Fixes: bbb2832620ac ("crypto: stm32 - Fix sparse warnings")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 7389a0536ff02..d13b262b36252 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -163,7 +163,7 @@ struct stm32_cryp {
 	struct scatter_walk     in_walk;
 	struct scatter_walk     out_walk;
 
-	u32                     last_ctr[4];
+	__be32                  last_ctr[4];
 	u32                     gcm_ctr;
 };
 
@@ -1217,27 +1217,26 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 {
 	u32 cr;
 
-	if (unlikely(cryp->last_ctr[3] == 0xFFFFFFFF)) {
-		cryp->last_ctr[3] = 0;
-		cryp->last_ctr[2]++;
-		if (!cryp->last_ctr[2]) {
-			cryp->last_ctr[1]++;
-			if (!cryp->last_ctr[1])
-				cryp->last_ctr[0]++;
-		}
+	if (unlikely(cryp->last_ctr[3] == cpu_to_be32(0xFFFFFFFF))) {
+		/*
+		 * In this case, we need to increment manually the ctr counter,
+		 * as HW doesn't handle the U32 carry.
+		 */
+		crypto_inc((u8 *)cryp->last_ctr, sizeof(cryp->last_ctr));
 
 		cr = stm32_cryp_read(cryp, CRYP_CR);
 		stm32_cryp_write(cryp, CRYP_CR, cr & ~CR_CRYPEN);
 
-		stm32_cryp_hw_write_iv(cryp, (__be32 *)cryp->last_ctr);
+		stm32_cryp_hw_write_iv(cryp, cryp->last_ctr);
 
 		stm32_cryp_write(cryp, CRYP_CR, cr);
 	}
 
-	cryp->last_ctr[0] = stm32_cryp_read(cryp, CRYP_IV0LR);
-	cryp->last_ctr[1] = stm32_cryp_read(cryp, CRYP_IV0RR);
-	cryp->last_ctr[2] = stm32_cryp_read(cryp, CRYP_IV1LR);
-	cryp->last_ctr[3] = stm32_cryp_read(cryp, CRYP_IV1RR);
+	/* The IV registers are BE  */
+	cryp->last_ctr[0] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0LR));
+	cryp->last_ctr[1] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0RR));
+	cryp->last_ctr[2] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1LR));
+	cryp->last_ctr[3] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1RR));
 }
 
 static bool stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
-- 
2.34.1



