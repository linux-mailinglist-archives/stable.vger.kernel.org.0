Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D7A10BD68
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfK0U6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfK0U6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599E42084D;
        Wed, 27 Nov 2019 20:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888282;
        bh=OKqeG2P+tPeyHFAyZKVWcBe8xkMu2lCZ2qbbeu6ZUeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+Wm45zeLQg0eRG/yQge8a7zbK5adzzvENgx0F5qEuV4Yt1aTjs76eLAXe/tvaxvc
         WeaL6yTt1xTnAU3+Cp2+A+BUZUZSmuJ0mVB1Cf6wSqauNt8OXrH4cxdQHPDY4vsWN9
         dg0QbnXaLujRBtmCCGwQyUWGz0rJz6dBJgdmRMeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/306] crypto: ccree - avoid implicit enum conversion
Date:   Wed, 27 Nov 2019 21:28:44 +0100
Message-Id: <20191127203120.260795091@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 18e732b8035d175181aae2ded127994cb01694f7 ]

Clang warns when one enumerated type is implicitly converted to another
and this happens in several locations in this driver, ultimately related
to the set_cipher_{mode,config0} functions. set_cipher_mode expects a mode
of type drv_cipher_mode and set_cipher_config0 expects a mode of type
drv_crypto_direction.

drivers/crypto/ccree/cc_ivgen.c:58:35: warning: implicit conversion from
enumeration type 'enum cc_desc_direction' to different enumeration type
'enum drv_crypto_direction' [-Wenum-conversion]
        set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);

drivers/crypto/ccree/cc_hash.c:99:28: warning: implicit conversion from
enumeration type 'enum cc_hash_conf_pad' to different enumeration type
'enum drv_crypto_direction' [-Wenum-conversion]
                set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);

drivers/crypto/ccree/cc_aead.c:1643:30: warning: implicit conversion
from enumeration type 'enum drv_hash_hw_mode' to different enumeration
type 'enum drv_cipher_mode' [-Wenum-conversion]
        set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);

Since this fundamentally isn't a problem because these values just
represent simple integers for a shift operation, make it clear to Clang
that this is okay by making the mode parameter in both functions an int.

Link: https://github.com/ClangBuiltLinux/linux/issues/46
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_hw_queue_defs.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index a091ae57f9024..45985b955d2c8 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -449,8 +449,7 @@ static inline void set_flow_mode(struct cc_hw_desc *pdesc,
  * @pdesc: pointer HW descriptor struct
  * @mode:  Any one of the modes defined in [CC7x-DESC]
  */
-static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
-				   enum drv_cipher_mode mode)
+static inline void set_cipher_mode(struct cc_hw_desc *pdesc, int mode)
 {
 	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_MODE, mode);
 }
@@ -461,8 +460,7 @@ static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
  * @pdesc: pointer HW descriptor struct
  * @mode: Any one of the modes defined in [CC7x-DESC]
  */
-static inline void set_cipher_config0(struct cc_hw_desc *pdesc,
-				      enum drv_crypto_direction mode)
+static inline void set_cipher_config0(struct cc_hw_desc *pdesc, int mode)
 {
 	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF0, mode);
 }
-- 
2.20.1



