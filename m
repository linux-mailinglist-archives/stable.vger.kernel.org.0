Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5324F68C38
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbfGONuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbfGONuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:50:05 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364F82086C;
        Mon, 15 Jul 2019 13:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198604;
        bh=JAnLtsV+A+ImHI4VW2GLzMDKqOtvxsK3+J+mNbFY1wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meoQ41taQaswH3RRJL6bGSxM4Gtk9eC2pxDXY4NGFoHW4SeGSGvWqdSLN+P51Ij5+
         aRQlfcJFm6X2/s9Q/msQQeKwq1VXB28MfpBGxpzOqHw4NB40rF8qgtxgKJ8upn+0m7
         72X3VTwTCuxKpQF8XT3X2eyndGcvJr5ed7DdJnxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 057/249] crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
Date:   Mon, 15 Jul 2019 09:43:42 -0400
Message-Id: <20190715134655.4076-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit c9cca7034b34a2d82e9a03b757de2485c294851c ]

The MPC885 reference manual states:

SEC Lite-initiated 8xx writes can occur only on 32-bit-word boundaries, but
reads can occur on any byte boundary. Writing back a header read from a
non-32-bit-word boundary will yield unpredictable results.

In order to ensure that, cra_alignmask is set to 3 for SEC1.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 9c4a79653b35 ("crypto: talitos - Freescale integrated security engine (SEC) driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index eec880909fdf..b6433d58df41 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3278,7 +3278,10 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg->cra_priority = t_alg->algt.priority;
 	else
 		alg->cra_priority = TALITOS_CRA_PRIORITY;
-	alg->cra_alignmask = 0;
+	if (has_ftr_sec1(priv))
+		alg->cra_alignmask = 3;
+	else
+		alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
 	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
 
-- 
2.20.1

