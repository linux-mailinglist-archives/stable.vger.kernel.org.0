Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE56330331C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbhAZEqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:46:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbhAYSnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CEC229C5;
        Mon, 25 Jan 2021 18:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600179;
        bh=0KM3P452JV5sRjpfsh+9a+nhHk68faqHIAIwdiEHptc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+kjOxK8jbfw8fbQkICn7lfepQD2K7kr51u/iWOL4klb0yA/7UTvwYBuTu0dcp/FI
         5OFOC5M4eOuia9VjMHAJG0OQe+5ff9PsQXt5BT9z0h2+8UekW2ralBa9TXCEkvV2nt
         7wgJFMFPVF48hUiWuQ513ihlDcfdjl2qM5nx63Lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 31/58] iio: ad5504: Fix setting power-down state
Date:   Mon, 25 Jan 2021 19:39:32 +0100
Message-Id: <20210125183158.039145976@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit efd597b2839a9895e8a98fcb0b76d2f545802cd4 upstream.

The power-down mask of the ad5504 is actually a power-up mask. Meaning if
a bit is set the corresponding channel is powered up and if it is not set
the channel is powered down.

The driver currently has this the wrong way around, resulting in the
channel being powered up when requested to be powered down and vice versa.

Fixes: 3bbbf150ffde ("staging:iio:dac:ad5504: Use strtobool for boolean values")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201209104649.5794-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/dac/ad5504.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/dac/ad5504.c
+++ b/drivers/iio/dac/ad5504.c
@@ -189,9 +189,9 @@ static ssize_t ad5504_write_dac_powerdow
 		return ret;
 
 	if (pwr_down)
-		st->pwr_down_mask |= (1 << chan->channel);
-	else
 		st->pwr_down_mask &= ~(1 << chan->channel);
+	else
+		st->pwr_down_mask |= (1 << chan->channel);
 
 	ret = ad5504_spi_write(st, AD5504_ADDR_CTRL,
 				AD5504_DAC_PWRDWN_MODE(st->pwr_down_mode) |


