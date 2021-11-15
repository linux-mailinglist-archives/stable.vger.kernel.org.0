Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811254513B9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348643AbhKOTyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343893AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 483C8633A2;
        Mon, 15 Nov 2021 18:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002081;
        bh=OvQjb5L/MnyxUI5jdUwSaRCSWLG+glPe0AryTFQtWes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOoDdGtZFbwAR3Sx7qS6Zhj9TmVV4w7bb9+wHBeq27Q+BLrBgL50fV99aOTLi3OhR
         6BAUKYqS7b81qkjmWYbDpZB7mv271SU2iqDLuNbOyApWvxWd0LtFQ0+JohwA8WABDH
         BUztDNxLj4MxEQYe0j7RJIfS2bPo7iPbzbRsoInw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/917] hwrng: mtk - Force runtime pm ops for sleep ops
Date:   Mon, 15 Nov 2021 17:58:29 +0100
Message-Id: <20211115165442.826221312@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit b6f5f0c8f72d348b2d07b20d7b680ef13a7ffe98 ]

Currently mtk_rng_runtime_suspend/resume is called for both runtime pm
and system sleep operations.

This is wrong as these should only be runtime ops as the name already
suggests. Currently freezing the system will lead to a call to
mtk_rng_runtime_suspend even if the device currently isn't active. This
leads to a clock warning because it is disabled/unprepared although it
isn't enabled/prepared currently.

This patch fixes this by only setting the runtime pm ops and forces to
call the runtime pm ops from the system sleep ops as well if active but
not otherwise.

Fixes: 81d2b34508c6 ("hwrng: mtk - add runtime PM support")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/mtk-rng.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 8ad7b515a51b8..6c00ea0085553 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -166,8 +166,13 @@ static int mtk_rng_runtime_resume(struct device *dev)
 	return mtk_rng_init(&priv->rng);
 }
 
-static UNIVERSAL_DEV_PM_OPS(mtk_rng_pm_ops, mtk_rng_runtime_suspend,
-			    mtk_rng_runtime_resume, NULL);
+static const struct dev_pm_ops mtk_rng_pm_ops = {
+	SET_RUNTIME_PM_OPS(mtk_rng_runtime_suspend,
+			   mtk_rng_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+};
+
 #define MTK_RNG_PM_OPS (&mtk_rng_pm_ops)
 #else	/* CONFIG_PM */
 #define MTK_RNG_PM_OPS NULL
-- 
2.33.0



