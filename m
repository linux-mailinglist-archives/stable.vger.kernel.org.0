Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF1B2E165A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgLWCSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgLWCSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764EC233EE;
        Wed, 23 Dec 2020 02:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689861;
        bh=YTtdSqMawXFVA+HPyBMMCI2ZrtMdgwZ0Zmbdxko0Y0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7t5eI2MqPG51qB9vvTTjjRJv/EOvTCicbRBrAWfmr5wPnoLehlmCjO975VWwYMk8
         eBkNtUGAfiuRdg2cBn7CDskh/oEzw+hQvzXmytwRpaVqcQYi0W1z5cVUcj3QR/vsgZ
         WjF6GU3Lww8mg1RIxhO0D1QCwtQ0s7LOMJT+ZW0knTxyH1oDOhrkROSz5wy5KW1Zcb
         kxCAuhs5+36QilRERXXoCo95+4Vd46uw67wPgtnyfs8hP369nVMzwSMrqGFbuOaxXe
         5ZFLQfYqXfgDx6bCcMzhP+eMQ64FbcYO28JO2xoBTwmOMq6eQn501HlpumA20cmEXA
         04hBe8lhm5goA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 057/217] s390/trng: set quality to 1024
Date:   Tue, 22 Dec 2020 21:13:46 -0500
Message-Id: <20201223021626.2790791-57-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit d041315ef75cf52df19613f56a2da2c5911c163c ]

The s390-trng does provide 100% entropy. The quality value is supported
to be between 1 and 1024 and not 1..1000.  Use 1024 to make this driver
the preferred one. If we ever have a better driver that has the same
quality but is faster we can change this again when merging the new
driver. No need to be conservative.

This makes sure that the hw variant is preferred over things like
virtio-rng, where the hypervisor has a potential to be misconfigured
and thus should have a slightly lower confidence.

Cc: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/s390-trng.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/s390-trng.c b/drivers/char/hw_random/s390-trng.c
index 413cacbb08e26..7c673afd72419 100644
--- a/drivers/char/hw_random/s390-trng.c
+++ b/drivers/char/hw_random/s390-trng.c
@@ -192,14 +192,15 @@ static int trng_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 /*
  * hwrng register struct
- * The trng is suppost to have 100% entropy, and thus
- * we register with a very high quality value.
+ * The trng is supposed to have 100% entropy, and thus we register with a very
+ * high quality value. If we ever have a better driver in the future, we should
+ * change this value again when we merge this driver.
  */
 static struct hwrng trng_hwrng_dev = {
 	.name		= "s390-trng",
 	.data_read	= trng_hwrng_data_read,
 	.read		= trng_hwrng_read,
-	.quality	= 999,
+	.quality	= 1024,
 };
 
 
-- 
2.27.0

