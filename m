Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EA5431AD4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhJRN3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231888AbhJRN3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5017061354;
        Mon, 18 Oct 2021 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563579;
        bh=rIWa6rpM1wQOJGDR0U8LT59T6BkSDLn1mxZj4v0jirU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRZLmLvVUn9yUPVSoFhvbAp/fvVXYtkd3Gz3sokxnVPQOWxoR+KZzO+ee3vHDd+Gi
         wr9Zpp/1A6cloDvQ4gB7EBZ/Um39wELe7WROX/DOrbd3XzSp7SauqG/mGWrqi+A6kK
         H0u5U96Vzx/pWQiY8DzZVO433MwJHcxWpyuZJz4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 21/39] iio: adc: aspeed: set driver data when adc probe.
Date:   Mon, 18 Oct 2021 15:24:30 +0200
Message-Id: <20211018132326.131210487@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit eb795cd97365a3d3d9da3926d234a7bc32a3bb15 upstream.

Fix the issue when adc remove will get the null driver data.

Fixed: commit 573803234e72 ("iio: Aspeed ADC")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20210831071458.2334-2-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -187,6 +187,7 @@ static int aspeed_adc_probe(struct platf
 
 	data = iio_priv(indio_dev);
 	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, indio_dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	data->base = devm_ioremap_resource(&pdev->dev, res);


