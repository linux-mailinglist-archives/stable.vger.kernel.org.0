Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD249942F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388649AbiAXUjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386438AbiAXUfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:35:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346EAC02C3EF;
        Mon, 24 Jan 2022 11:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4326B81239;
        Mon, 24 Jan 2022 19:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17880C340E5;
        Mon, 24 Jan 2022 19:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053726;
        bh=Im0F7TeBzMVqLpyKF0wuta0Ts2zCgNoPJI3BvjCBY7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN64lJdia7tRV5Lcr1DZuefAzYiXZyzKE+EBaAfEoFQ6ESFd+NTmiA/hDWCcx++kC
         R7Zg5wxyXRpJgfRYo4LLY22kxU9dkh1mXzpHkxXHGOlpaopfVuUR5kHh11HV4flMW8
         jjjqqKdpGoPajyJCK4+ryMrGrXsFfo0hww3f68DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/563] crypto: stm32/cryp - fix lrw chaining mode
Date:   Mon, 24 Jan 2022 19:38:43 +0100
Message-Id: <20220124184029.861362732@linuxfoundation.org>
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

[ Upstream commit fa97dc2d48b476ea98199d808d3248d285987e99 ]

This fixes the lrw autotest if lrw uses the CRYP as the AES block cipher
provider (as ecb(aes)). At end of request, CRYP should not update the IV
in case of ECB chaining mode. Indeed the ECB chaining mode never uses
the IV, but the software LRW chaining mode uses the IV field as
a counter and due to the (unexpected) update done by CRYP while the AES
block process, the counter get a wrong value when the IV overflow.

Fixes: 5f49f18d27cd ("crypto: stm32/cryp - update to return iv_out")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 061db567908ae..9943836a5c25c 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -644,7 +644,7 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 		/* Phase 4 : output tag */
 		err = stm32_cryp_read_auth_tag(cryp);
 
-	if (!err && (!(is_gcm(cryp) || is_ccm(cryp))))
+	if (!err && (!(is_gcm(cryp) || is_ccm(cryp) || is_ecb(cryp))))
 		stm32_cryp_get_iv(cryp);
 
 	if (cryp->sgs_copied) {
-- 
2.34.1



