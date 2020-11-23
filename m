Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ED72C074F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732301AbgKWMji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbgKWMjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54D920857;
        Mon, 23 Nov 2020 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135176;
        bh=1b0Aao5rEShUAKqxO8dzn14MSNbOZz2LQvNYSXrlzeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQuzIfLU50N3/WVQD6FZ4mnrwSUtdwkmIbb6+DGhBu/KEpwejdTeo9RFQyE+jgSpM
         RnRfUdPPSEuHnJhBUClK6KdLXQ9tt5EcPFSL679pUfiFQMki7DfTVnYmvCuNVZuo4o
         zXuFf+tQSov1fc5l/8RGaISKQvL3FM6na0Yk2UKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 132/158] iio: adc: mediatek: fix unset field
Date:   Mon, 23 Nov 2020 13:22:40 +0100
Message-Id: <20201123121826.295492447@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Parent <fparent@baylibre.com>

commit 15207a92e019803d62687455d8aa2ff9eb3dc82c upstream.

dev_comp field is used in a couple of places but it is never set. This
results in kernel oops when dereferencing a NULL pointer. Set the
`dev_comp` field correctly in the probe function.

Fixes: 6d97024dce23 ("iio: adc: mediatek: mt6577-auxadc, add mt6765 support")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201018194644.3366846-1-fparent@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/mt6577_auxadc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/mt6577_auxadc.c
+++ b/drivers/iio/adc/mt6577_auxadc.c
@@ -9,9 +9,9 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/iopoll.h>
 #include <linux/io.h>
 #include <linux/iio/iio.h>
@@ -279,6 +279,8 @@ static int mt6577_auxadc_probe(struct pl
 		goto err_disable_clk;
 	}
 
+	adc_dev->dev_comp = device_get_match_data(&pdev->dev);
+
 	mutex_init(&adc_dev->lock);
 
 	mt6577_auxadc_mod_reg(adc_dev->reg_base + MT6577_AUXADC_MISC,


