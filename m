Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156424154BF
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 02:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbhIWAlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 20:41:19 -0400
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:46704 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbhIWAlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 20:41:18 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 18N0cOp8021009; Thu, 23 Sep 2021 09:38:24 +0900
X-Iguazu-Qid: 34trpS1as3D6kN5JwW
X-Iguazu-QSIG: v=2; s=0; t=1632357504; q=34trpS1as3D6kN5JwW; m=2Qg8Y8ZLIZDUjzusAcKEvFVb7XFD+a0C5pESEGmiZs0=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1513) id 18N0cMom036928
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Sep 2021 09:38:23 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id A6CBC100133;
        Thu, 23 Sep 2021 09:38:22 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 18N0cMaD016061;
        Thu, 23 Sep 2021 09:38:22 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.9, 4.14, 4.19] crypto: talitos - fix max key size for sha384 and sha512
Date:   Thu, 23 Sep 2021 09:38:19 +0900
X-TSB-HOP: ON
Message-Id: <20210923003819.29736-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 192125ed5ce62afba24312d8e7a0314577565b4a upstream.

Below commit came with a typo in the CONFIG_ symbol, leading
to a permanently reduced max key size regarless of the driver
capabilities.

Reported-by: Horia Geantă <horia.geanta@nxp.com>
Fixes: b8fbdc2bc4e7 ("crypto: talitos - reduce max key size for SEC1")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 07e1a286ee4313..78b4f0f172ae59 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -853,7 +853,7 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
 #else
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
-- 
2.33.0


