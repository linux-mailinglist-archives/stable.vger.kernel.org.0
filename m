Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01657431BB2
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhJRNeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232592AbhJRNc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C887C613A3;
        Mon, 18 Oct 2021 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563759;
        bh=ua89X3wkJH7YUfLcL3sxpZ8BGsUVN7KsUotGZZ66I9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEVsfMAyRaeS4SduEzIiSkV6Vm+Jxyat0Sgy1TCzQeoAB2my8h+HJmldMATloSSoy
         N5RfxdhwlFqUz4o3gAjKW4I//SGwdbtOonvA+e89XVpGoJo/UUCGioXupzacZseVTG
         5ZfhBf1g0S4/sOUuDB0E/ps3G5E9AZOWvfPA+dDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 27/50] iio: adc: aspeed: set driver data when adc probe.
Date:   Mon, 18 Oct 2021 15:24:34 +0200
Message-Id: <20211018132327.442140159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
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
@@ -188,6 +188,7 @@ static int aspeed_adc_probe(struct platf
 
 	data = iio_priv(indio_dev);
 	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, indio_dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	data->base = devm_ioremap_resource(&pdev->dev, res);


