Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6FF395E0C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhEaNxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhEaNva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 805D86186A;
        Mon, 31 May 2021 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467949;
        bh=sg8BA99lz8X4n17e5wbLXqVoyRIWCYyTeQ0xl9m3Ti0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ml2jmd3N50bwkwee2V80T6W0eXeJL0w075wmyfO1bB75mNXxN538fLvLmEW/CyDOb
         iXeFVJXKz0JcFHuPDIV5Ad2/WW4AysK/GC+qD26SThldFiU/0WHc4CL59KMhWUSCm8
         5dtO8PR21gkIo73akZga5jPrGTO83GAuq8HYtWQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stankus <lucas.p.stankus@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.10 060/252] staging: iio: cdc: ad7746: avoid overwrite of num_channels
Date:   Mon, 31 May 2021 15:12:05 +0200
Message-Id: <20210531130700.012141532@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stankus <lucas.p.stankus@gmail.com>

commit 04f5b9f539ce314f758d919a14dc7a669f3b7838 upstream.

AD7745 devices don't have the CIN2 pins and therefore can't handle related
channels. Forcing the number of AD7746 channels may lead to enabling more
channels than what the hardware actually supports.
Avoid num_channels being overwritten after first assignment.

Signed-off-by: Lucas Stankus <lucas.p.stankus@gmail.com>
Fixes: 83e416f458d53 ("staging: iio: adc: Replace, rewrite ad7745 from scratch.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/cdc/ad7746.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/iio/cdc/ad7746.c
+++ b/drivers/staging/iio/cdc/ad7746.c
@@ -700,7 +700,6 @@ static int ad7746_probe(struct i2c_clien
 		indio_dev->num_channels = ARRAY_SIZE(ad7746_channels);
 	else
 		indio_dev->num_channels =  ARRAY_SIZE(ad7746_channels) - 2;
-	indio_dev->num_channels = ARRAY_SIZE(ad7746_channels);
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
 	if (pdata) {


