Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CC1145638
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVNWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729425AbgAVNWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:47 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7432468D;
        Wed, 22 Jan 2020 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699367;
        bh=As0BFpKYdf8bREqme8P5/YpjihCcV/hXG3yG8sQOQCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6kLxPL+gaAoOJgZayM1q+SSKprAdO9ZbXaOUwcH4CX9DOFHtsX8P2id6ZtmERScl
         h2jndKqZMQPdboAZZrg/Uleuj3bXkwaL3l/rQNRThFBeN6LpvD0I006DVKZsksnkL2
         bsGr9O9yhPP2t1D7iKqRT1iJnj4g+S+dk9AWR4ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 123/222] i2c: iop3xx: Fix memory leak in probe error path
Date:   Wed, 22 Jan 2020 10:28:29 +0100
Message-Id: <20200122092842.556199913@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit e64175776d06a8ceebbfd349d7e66a4a46ca39ef upstream.

When handling devm_gpiod_get_optional() errors, free the memory already
allocated.  This fixes Smatch warnings:

    drivers/i2c/busses/i2c-iop3xx.c:437 iop3xx_i2c_probe() warn: possible memory leak of 'new_adapter'
    drivers/i2c/busses/i2c-iop3xx.c:442 iop3xx_i2c_probe() warn: possible memory leak of 'new_adapter'

Fixes: fdb7e884ad61 ("i2c: iop: Use GPIO descriptors")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-iop3xx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -433,13 +433,17 @@ iop3xx_i2c_probe(struct platform_device
 	adapter_data->gpio_scl = devm_gpiod_get_optional(&pdev->dev,
 							 "scl",
 							 GPIOD_ASIS);
-	if (IS_ERR(adapter_data->gpio_scl))
-		return PTR_ERR(adapter_data->gpio_scl);
+	if (IS_ERR(adapter_data->gpio_scl)) {
+		ret = PTR_ERR(adapter_data->gpio_scl);
+		goto free_both;
+	}
 	adapter_data->gpio_sda = devm_gpiod_get_optional(&pdev->dev,
 							 "sda",
 							 GPIOD_ASIS);
-	if (IS_ERR(adapter_data->gpio_sda))
-		return PTR_ERR(adapter_data->gpio_sda);
+	if (IS_ERR(adapter_data->gpio_sda)) {
+		ret = PTR_ERR(adapter_data->gpio_sda);
+		goto free_both;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {


