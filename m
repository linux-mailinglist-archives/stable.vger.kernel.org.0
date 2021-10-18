Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57413431E0F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhJRN53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhJRNzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06F616138D;
        Mon, 18 Oct 2021 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564406;
        bh=RUSYGcUE9avAjSDc7pZPpcq1IGDFoer+waIvRGTiRgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00iMZdEhhc+wUYUyyLg+PYHlaDo4/4vdTrCTUee50d74pLndWJPUioTHQQ4ad6yW6
         hUD3c5MHNz9Lkk6Yi/6goLKuJ8RZY3Hgq8kD8I5hft8nGU5DvmDF+pk5wVM/KZ/T4F
         CrRb6umk3c/yDntYn41zARNwxI+/sWeGorvn4VSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 078/151] iio: adc: max1027: Fix the number of max1X31 channels
Date:   Mon, 18 Oct 2021 15:24:17 +0200
Message-Id: <20211018132343.224884198@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit f0cb5fed37ab37f6a6c5463c5fd39b58a45670c8 upstream.

The macro MAX1X29_CHANNELS() already calls MAX1X27_CHANNELS().
Calling MAX1X27_CHANNELS() before MAX1X29_CHANNELS() in the definition
of MAX1X31_CHANNELS() declares the first 8 channels twice. So drop this
extra call from the MAX1X31 channels list definition.

Fixes: 7af5257d8427 ("iio: adc: max1027: Prepare the introduction of different resolutions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210818111139.330636-3-miquel.raynal@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max1027.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -142,7 +142,6 @@ MODULE_DEVICE_TABLE(of, max1027_adc_dt_i
 	MAX1027_V_CHAN(11, depth)
 
 #define MAX1X31_CHANNELS(depth)			\
-	MAX1X27_CHANNELS(depth),		\
 	MAX1X29_CHANNELS(depth),		\
 	MAX1027_V_CHAN(12, depth),		\
 	MAX1027_V_CHAN(13, depth),		\


