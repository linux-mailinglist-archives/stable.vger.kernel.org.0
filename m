Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222D711B67D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbfLKQBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbfLKPNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0608424654;
        Wed, 11 Dec 2019 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077213;
        bh=YEsL8fnV5oRLJ3Z306dsBmpxsyykbyKz9/Cdu3UFYAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkOScIMLeoZq1mxGQybnWTGoGngPfkMhvQ1RKyCPx98Wll8FBrAzp05T4X0gOnRi6
         bpDrHv1R/Arv2OxiJ/Foh0fIEQDX2qeqR+YJuTmG8z818KgK2ru1uyLuyG4JsyFfb1
         CzeBzy/KEtQLV/oNG9jI/sjPV2FAQhDlsG3pn6YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, emamd001@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 060/105] Input: Fix memory leak in psxpad_spi_probe
Date:   Wed, 11 Dec 2019 16:05:49 +0100
Message-Id: <20191211150245.026703773@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

In the implementation of psxpad_spi_probe() the allocated memory for
pdev is leaked if psxpad_spi_init_ff() or input_register_polled_device()
fail. The solution is using device managed allocation, like the one used
for pad. Perform the allocation using
devm_input_allocate_polled_device().

Fixes: 8be193c7b1f4 ("Input: add support for PlayStation 1/2 joypads connected via SPI")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/psxpad-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/psxpad-spi.c
+++ b/drivers/input/joystick/psxpad-spi.c
@@ -292,7 +292,7 @@ static int psxpad_spi_probe(struct spi_d
 	if (!pad)
 		return -ENOMEM;
 
-	pdev = input_allocate_polled_device();
+	pdev = devm_input_allocate_polled_device(&spi->dev);
 	if (!pdev) {
 		dev_err(&spi->dev, "failed to allocate input device\n");
 		return -ENOMEM;


