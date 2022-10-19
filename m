Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835D4603EA3
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiJSJQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiJSJP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6410654D;
        Wed, 19 Oct 2022 02:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 627BC6187F;
        Wed, 19 Oct 2022 09:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FB0C4347C;
        Wed, 19 Oct 2022 09:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170361;
        bh=iLfJweqofE4ePh5lC+qqoU4eiN4c6k2V77N1oN0Csjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDzkrgwQnXDapFPdh9QMtR881QEw7jGStuap9KEUbFqqY9iDeH+9EsGFuh0BKouOM
         GOf44V+HbOMw40aLQ+lzKqNDSJnj1M6jAZ9vlyZ87QmtJ52PpbYpZd6pe9u5ueO3YK
         rh/MgSFLAb4eeYhmXMEe7g2UMgulLnHIe/fVTyZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Cowgill <james.cowgill@blaize.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 626/862] hwrng: arm-smccc-trng - fix NO_ENTROPY handling
Date:   Wed, 19 Oct 2022 10:31:53 +0200
Message-Id: <20221019083317.585926624@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



