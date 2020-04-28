Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA61BCB66
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgD1Saa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbgD1Saa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDA12137B;
        Tue, 28 Apr 2020 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098629;
        bh=okFhcd/SyvEwUKm90K1+K90VGZtWh3QimsVJ6c3i+xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZyZzam2x+HP4634tR7RYRFx+e+cLjP8qE63qOttiNR1tIzgaK5PKjXCo4S7kiq8v
         ZRwMLhqKQh/PpS/GOjey0kWHKTRHJEbPdcwpBojwEAtKTA5LZc/IyPQgAzqZFD+46E
         loydkCsb8fMI6hFWb46B5MnV56z6kIr3MvM0MNNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 088/167] iio: xilinx-xadc: Fix sequencer configuration for aux channels in simultaneous mode
Date:   Tue, 28 Apr 2020 20:24:24 +0200
Message-Id: <20200428182236.086602548@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8bef455c8b1694547ee59e8b1939205ed9d901a6 upstream.

The XADC has two internal ADCs. Depending on the mode it is operating in
either one or both of them are used. The device manual calls this
continuous (one ADC) and simultaneous (both ADCs) mode.

The meaning of the sequencing register for the aux channels changes
depending on the mode.

In continuous mode each bit corresponds to one of the 16 aux channels. And
the single ADC will convert them one by one in order.

In simultaneous mode the aux channels are split into two groups the first 8
channels are assigned to the first ADC and the other 8 channels to the
second ADC. The upper 8 bits of the sequencing register are unused and the
lower 8 bits control both ADCs. This means a bit needs to be set if either
the corresponding channel from the first group or the second group (or
both) are set.

Currently the driver does not have the special handling required for
simultaneous mode. Add it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/xilinx-xadc-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -798,6 +798,16 @@ static int xadc_preenable(struct iio_dev
 	if (ret)
 		goto err;
 
+	/*
+	 * In simultaneous mode the upper and lower aux channels are samples at
+	 * the same time. In this mode the upper 8 bits in the sequencer
+	 * register are don't care and the lower 8 bits control two channels
+	 * each. As such we must set the bit if either the channel in the lower
+	 * group or the upper group is enabled.
+	 */
+	if (seq_mode == XADC_CONF1_SEQ_SIMULTANEOUS)
+		scan_mask = ((scan_mask >> 8) | scan_mask) & 0xff0000;
+
 	ret = xadc_write_adc_reg(xadc, XADC_REG_SEQ(1), scan_mask >> 16);
 	if (ret)
 		goto err;


