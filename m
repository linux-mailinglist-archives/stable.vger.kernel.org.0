Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37AC11349D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbfLDSBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbfLDSBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:01:02 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E2B20659;
        Wed,  4 Dec 2019 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482462;
        bh=O4H8gKKIofBTYa/ahR2HGrSqNn62ReqrOkWXmkecmG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AM9dGkt+kmr0nHI4qgkoQnE580QpO/sjIQW2hg+lOe9dmffVAVQ+CMl8WY97eD7PC
         l+fwJh28t89sSwHvgjP/zHFvl7GJxTrZ2Z19Pu+MR7UeEGImW4CUnwO5NowPvMtDRp
         /SQHl/KY0HwXBXmMDmDwmVlC5P2K8htpIQRFTv2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lionel Debieve <lionel.debieve@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.4 91/92] hwrng: stm32 - fix unbalanced pm_runtime_enable
Date:   Wed,  4 Dec 2019 18:50:31 +0100
Message-Id: <20191204174335.613659568@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
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


