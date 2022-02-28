Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C54C7695
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiB1SFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbiB1SD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA86286EB;
        Mon, 28 Feb 2022 09:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74E4060748;
        Mon, 28 Feb 2022 17:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C765C340E7;
        Mon, 28 Feb 2022 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070450;
        bh=6Bs3KRMBEnBHVY5wgZ6eTF3ehTlTDXNCkx6jttAQhII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE/ongn3/EKvL94wJNutZP23/r9GoWqvXSIjZyYkxYLd1Gs78eG9KjZNFau0lxIsf
         /8gPR2xoMW8Z6dkYtN/T49STwbc5iC9Snktas0znQ9/eKke0bFzsiRlSVwMCF+sCoW
         ZnITRDpB4/o94INiLzq1B4hv8VF8NkORxL3AlTLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Pineda <julia.pineda@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.16 114/164] iio:imu:adis16480: fix buffering for devices with no burst mode
Date:   Mon, 28 Feb 2022 18:24:36 +0100
Message-Id: <20220228172410.775930203@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit b0e85f95e30d4d2dc22ea123a30dba36406879a1 upstream.

The trigger handler defined in the driver assumes that burst mode is
being used. Hence, for devices that do not support it, we have to use
the adis library default trigger implementation.

Tested-by: Julia Pineda <julia.pineda@analog.com>
Fixes: 941f130881fa9 ("iio: adis16480: support burst read function")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220114132608.241-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16480.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -1403,6 +1403,7 @@ static int adis16480_probe(struct spi_de
 {
 	const struct spi_device_id *id = spi_get_device_id(spi);
 	const struct adis_data *adis16480_data;
+	irq_handler_t trigger_handler = NULL;
 	struct iio_dev *indio_dev;
 	struct adis16480 *st;
 	int ret;
@@ -1474,8 +1475,12 @@ static int adis16480_probe(struct spi_de
 		st->clk_freq = st->chip_info->int_clk;
 	}
 
+	/* Only use our trigger handler if burst mode is supported */
+	if (adis16480_data->burst_len)
+		trigger_handler = adis16480_trigger_handler;
+
 	ret = devm_adis_setup_buffer_and_trigger(&st->adis, indio_dev,
-						 adis16480_trigger_handler);
+						 trigger_handler);
 	if (ret)
 		return ret;
 


