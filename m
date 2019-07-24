Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31A073C50
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405568AbfGXUCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404679AbfGXUCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:02:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00FF2205C9;
        Wed, 24 Jul 2019 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998564;
        bh=UWE2DN4Cd8hLRQMDE57ZxB+Xn521+jVhFIUc94A+9zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCEjR4u4TsC8cy5Xb9ypSXV/5TDHkfQuvxkAYUm23EUnD50vLoUyYgOonG/ZM3dWx
         QX3THGHAlwJjoNvvdYYf6PTMuPaIahmwQcVhpEciyf7MB8Za9rGQh4qUfqazeeGJgD
         QxGFu9fYDByp99Hq8w1Olz84ICuqKfXyiB2jDNV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/271] crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
Date:   Wed, 24 Jul 2019 21:18:25 +0200
Message-Id: <20190724191658.293730178@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 254f711f1934..41b288bdcdbf 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3193,7 +3193,10 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
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



