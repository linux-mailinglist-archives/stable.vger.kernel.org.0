Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD921CAF02
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgEHNN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbgEHMrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CFD021473;
        Fri,  8 May 2020 12:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942069;
        bh=3x4YvyiJI3iSiS8ZYzwqW7VtbS7yPmj7iAdexXHtaqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+8rZm4r/aRe6tYKp6k9njEtGnZuiP55PtSoCxMr/aj3/5Cz6YznPZfUtw5F8JIAH
         eU8eeekv51dHbI8vBVUCI4uwaDRQli8i+6JMUIpAxoX4/sLF7pG5KNl8Tqa7fNSP/j
         9jR4XHG40eGFmUDX/Iyw3fOmTBRb/p1MF5rHypwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 285/312] hwrng: exynos - Disable runtime PM on driver unbind
Date:   Fri,  8 May 2020 14:34:36 +0200
Message-Id: <20200508123144.443758651@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 27d80fa8bccf8d28bef4f89709638efc624fef9a upstream.

Driver enabled runtime PM but did not revert this on removal. Re-binding
of a device triggered warning:
	exynos-rng 10830400.rng: Unbalanced pm_runtime_enable!

Fixes: b329669ea0b5 ("hwrng: exynos - Add support for Exynos random number generator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/exynos-rng.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -155,6 +155,14 @@ static int exynos_rng_probe(struct platf
 	return ret;
 }
 
+static int exynos_rng_remove(struct platform_device *pdev)
+{
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
 static int __maybe_unused exynos_rng_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -212,6 +220,7 @@ static struct platform_driver exynos_rng
 		.of_match_table = exynos_rng_dt_match,
 	},
 	.probe		= exynos_rng_probe,
+	.remove		= exynos_rng_remove,
 };
 
 module_platform_driver(exynos_rng_driver);


