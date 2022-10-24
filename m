Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E6D60AC9C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiJXOK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiJXOJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:09:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F61C45BA;
        Mon, 24 Oct 2022 05:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB536125D;
        Mon, 24 Oct 2022 12:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEEBC433D6;
        Mon, 24 Oct 2022 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615764;
        bh=iLfJweqofE4ePh5lC+qqoU4eiN4c6k2V77N1oN0Csjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsMSp0hff9G0eD+2MaOH4EiWGMz8yxI7aO2m3iaBsxPZOD1mf9FedHN3SWg2polHQ
         F08yeYd+zbt76ZGdxC9q0T5pME0mSytJ9YnlytB7JQUKLFS1/OLBe/1V6vbIe5+rUq
         iNDNBYPayjdeUqEx8DL+fzs2qCuCe17IyqDD/Ato=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Cowgill <james.cowgill@blaize.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/530] hwrng: arm-smccc-trng - fix NO_ENTROPY handling
Date:   Mon, 24 Oct 2022 13:31:59 +0200
Message-Id: <20221024113102.010433645@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Cowgill <james.cowgill@blaize.com>

[ Upstream commit 042b4b169c6fb9d4df268d66282d7302dd73d37b ]

The SMCCC_RET_TRNG_NO_ENTROPY switch arm is never used because the
NO_ENTROPY return value is negative and negative values are handled
above the switch by immediately returning.

Fix by handling errors using a default arm in the switch.

Fixes: 0888d04b47a1 ("hwrng: Add Arm SMCCC TRNG based driver")
Signed-off-by: James Cowgill <james.cowgill@blaize.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/arm_smccc_trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/arm_smccc_trng.c b/drivers/char/hw_random/arm_smccc_trng.c
index b24ac39a903b..e34c3ea692b6 100644
--- a/drivers/char/hw_random/arm_smccc_trng.c
+++ b/drivers/char/hw_random/arm_smccc_trng.c
@@ -71,8 +71,6 @@ static int smccc_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 				  MAX_BITS_PER_CALL);
 
 		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND, bits, &res);
-		if ((int)res.a0 < 0)
-			return (int)res.a0;
 
 		switch ((int)res.a0) {
 		case SMCCC_RET_SUCCESS:
@@ -88,6 +86,8 @@ static int smccc_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 				return copied;
 			cond_resched();
 			break;
+		default:
+			return -EIO;
 		}
 	}
 
-- 
2.35.1



