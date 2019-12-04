Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26818113288
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfLDSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbfLDSJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:10 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A421820675;
        Wed,  4 Dec 2019 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482950;
        bh=O4H8gKKIofBTYa/ahR2HGrSqNn62ReqrOkWXmkecmG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skNItj/2Y5Cek6Sjnx+Y/Hp16YWFxEbo6OLKP5E+c1boFeT4gqXiDvx9/WYEWFWgH
         xI4KySnPIj5LJD7890z2KggqppORopYqc0DV75P1PgpN/mq2cVK1uHliLZexPZPpLO
         9I7/n4qqSbCVD7Yd8xezZqvjGFIx76SOh0N3jAg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lionel Debieve <lionel.debieve@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 201/209] hwrng: stm32 - fix unbalanced pm_runtime_enable
Date:   Wed,  4 Dec 2019 18:56:53 +0100
Message-Id: <20191204175337.324862662@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Debieve <lionel.debieve@st.com>

commit af0d4442dd6813de6e77309063beb064fa8e89ae upstream.

No remove function implemented yet in the driver.
Without remove function, the pm_runtime implementation
complains when removing and probing again the driver.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/stm32-rng.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -166,6 +166,13 @@ static int stm32_rng_probe(struct platfo
 	return devm_hwrng_register(dev, &priv->rng);
 }
 
+static int stm32_rng_remove(struct platform_device *ofdev)
+{
+	pm_runtime_disable(&ofdev->dev);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int stm32_rng_runtime_suspend(struct device *dev)
 {
@@ -202,6 +209,7 @@ static struct platform_driver stm32_rng_
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
+	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);


