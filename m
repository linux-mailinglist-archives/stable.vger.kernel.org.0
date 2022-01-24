Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9777E498F91
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357901AbiAXTxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45688 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349931AbiAXTse (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9862E61523;
        Mon, 24 Jan 2022 19:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6E6C340E5;
        Mon, 24 Jan 2022 19:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053711;
        bh=Ta3/1LLC6DwEG0sQyMUdKfg8TkHsYZQsq1+TVOjRIwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhyOhbMqhyCT9G+k1P89DP9zEyt0Su+Jij8psdXAjNHqvViWM32FdfljUJqNAMQbn
         whBZrEGvUR7mFxenIyL16lqwA/MwmJnSHMtU9/I4AM+Zkimy3H7f6FpQefOG1KZu2A
         rlEu80YBX9AZndlYyHaf98oyLodk/SwToeTKI6+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/563] crypto: stm32 - Fix last sparse warning in stm32_cryp_check_ctr_counter
Date:   Mon, 24 Jan 2022 19:38:38 +0100
Message-Id: <20220124184029.691958504@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 81064c96d88180ad6995d52419e94a78968308a2 ]

This patch changes the cast in stm32_cryp_check_ctr_counter from
u32 to __be32 to match the prototype of stm32_cryp_hw_write_iv
correctly.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 7999b26a16ed0..7389a0536ff02 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1229,7 +1229,7 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 		cr = stm32_cryp_read(cryp, CRYP_CR);
 		stm32_cryp_write(cryp, CRYP_CR, cr & ~CR_CRYPEN);
 
-		stm32_cryp_hw_write_iv(cryp, (u32 *)cryp->last_ctr);
+		stm32_cryp_hw_write_iv(cryp, (__be32 *)cryp->last_ctr);
 
 		stm32_cryp_write(cryp, CRYP_CR, cr);
 	}
-- 
2.34.1



