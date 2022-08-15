Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3712D594A9E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352660AbiHPAFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357146AbiHPADt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7338316DC7E;
        Mon, 15 Aug 2022 13:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 105AC6108B;
        Mon, 15 Aug 2022 20:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE41C433C1;
        Mon, 15 Aug 2022 20:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595134;
        bh=5YLn6KVnTu45C/6F30pnuNxkCjssGKF9M3riSTvOykY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOtkso0pLNPdLZbi7WZGtNk/WcDcj22UKSJbXUDAPZ1YCVBb07OtWOc1DUD50Y6Dn
         HFhTscTElXe1m59Qf8QLgGItZWffXB6oMppSLJ0XfM9dviRiowuKLfwjOrjbhymW52
         J1vh5Wvry2Aiwh1aiuv/Up3+X5vqaKQpsJqlkjrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0668/1157] iio: adc: ti-tlc4541: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:24 +0200
Message-Id: <20220815180506.428128993@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 62fa19bf484bfeb52c56b7c6d6a6b1222c597f9c ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: ac2bec9d587c ("iio: adc: tlc4541: add support for TI tlc4541 adc")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-40-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-tlc4541.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti-tlc4541.c b/drivers/iio/adc/ti-tlc4541.c
index 2406eda9dfc6..30f629a553a1 100644
--- a/drivers/iio/adc/ti-tlc4541.c
+++ b/drivers/iio/adc/ti-tlc4541.c
@@ -37,12 +37,12 @@ struct tlc4541_state {
 	struct spi_message              scan_single_msg;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * 2 bytes data + 6 bytes padding + 8 bytes timestamp when
 	 * call iio_push_to_buffers_with_timestamp.
 	 */
-	__be16                          rx_buf[8] ____cacheline_aligned;
+	__be16                          rx_buf[8] __aligned(IIO_DMA_MINALIGN);
 };
 
 struct tlc4541_chip_info {
-- 
2.35.1



