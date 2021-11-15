Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301345244F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356633AbhKPBhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243063AbhKOSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1980619EA;
        Mon, 15 Nov 2021 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999753;
        bh=nUuDPaL+NsG5FJ4et5bDrR/LFmn5uAUVu71eZxuj4aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T73LciU1sO4EMnhOi1TDk6NxaDX7Y9XQrV1iBj1tIsq1D/cDVGFzdOhaLBXbfAGPV
         SjBD8m3LEs2x0NiPz7hy9tIfMTIZSI7ZfTWO/llSuxWA0CA+og4mTomO/nkCoS1ncI
         r29cMCeKgwpuBfhvbsP736eak8BvbPAOEn+kTGJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Gilad ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 411/849] crypto: ccree - avoid out-of-range warnings from clang
Date:   Mon, 15 Nov 2021 17:58:14 +0100
Message-Id: <20211115165434.164203186@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit cfd6fb45cfaf46fa9547421d8da387dc9c7997d4 ]

clang points out inconsistencies in the FIELD_PREP() invocation in
this driver that result from the 'mask' being a 32-bit value:

drivers/crypto/ccree/cc_driver.c:117:18: error: result of comparison of constant 18446744073709551615 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        cache_params |= FIELD_PREP(mask, val);
                        ^~~~~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:94:3: note: expanded from macro 'FIELD_PREP'
                __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:52:28: note: expanded from macro '__BF_FIELD_CHECK'
                BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,         \
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This does not happen in other places that just pass a constant here.

Work around the warnings by widening the type of the temporary variable.

Fixes: 05c2a705917b ("crypto: ccree - rework cache parameters handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Gilad ben-Yossef <gilad@benyossef.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index e599ac6dc162a..790fa9058a36d 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -103,7 +103,8 @@ MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
 static void init_cc_cache_params(struct cc_drvdata *drvdata)
 {
 	struct device *dev = drvdata_to_dev(drvdata);
-	u32 cache_params, ace_const, val, mask;
+	u32 cache_params, ace_const, val;
+	u64 mask;
 
 	/* compute CC_AXIM_CACHE_PARAMS */
 	cache_params = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-- 
2.33.0



