Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7C2E157C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgLWCWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgLWCWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D169F22525;
        Wed, 23 Dec 2020 02:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690086;
        bh=kFX56l2DA+/DCghewOJUSjVM9juC4QCbi3IWQQGPhCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrBcZq9oG90tTn0BQkUT/PlzOZc1j1jemIb9IUa9k4MFJbaU4T9P8AbG4t/oDAImM
         /NKXhNWmlZ7gcNfAqS9aies4ddyP7omgTIxifL3KTunca8Bj+q0JBfK9OlSah2M6CG
         VRkL9d3zcDbYq59hF/okOluwH1AsN33TmENbb+T3a9Yi6Rf0lK0oF6Qz4NagxikqxE
         eP3cSD318v2X3DKQu9kvpcVR1ToKXEv6+5dKPBbHhBf/gfRZFydqKES6RCzM/79Whp
         BXfldA3dOIzlTT27wrrsMFwqFZBjOYJ/sco96wJ2E7SygY3hps7NR5hCAA/H9bH1Us
         g0gkz4Pg1aDrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/87] s390/trng: set quality to 1024
Date:   Tue, 22 Dec 2020 21:19:54 -0500
Message-Id: <20201223022103.2792705-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index aca48e893fca1..14747fb23a57f 100644
--- a/drivers/char/hw_random/s390-trng.c
+++ b/drivers/char/hw_random/s390-trng.c
@@ -196,14 +196,15 @@ static int trng_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
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

