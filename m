Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB9E594A9B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352536AbiHPAFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356477AbiHPAC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E35D169456;
        Mon, 15 Aug 2022 13:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D8D860EE9;
        Mon, 15 Aug 2022 20:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC76C433C1;
        Mon, 15 Aug 2022 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595029;
        bh=1ZM8t4XUhuzWdK3a2YEu+0EkEQ6u6byYIrpokLIX+HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IddozKMcffejg3/Ujrbx/Wk4P2r4YPj7CKNbNYCd1mIyyMfg6p7bjIZJZ9bTXdrmr
         U/KorXTkMWSK4i8aP+T/ivpEsTdTDphqVmZwU93ro22o5rfVnCLG6bq0qmTqnRcHw7
         TxjTqOHAu2/4vtP180DsrdP94kJBPQCRqrXjgZVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0635/1157] iio: accel: bma220: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:51 +0200
Message-Id: <20220815180505.095176557@linuxfoundation.org>
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

[ Upstream commit 38e71240e2ff97184cdcdaf877cf62d3f16678e2 ]

____cacheline_aligned is insufficient guarantee for non-coherent DMA.
Switch to the updated IIO_DMA_MINALIGN definition.

Fixes: bf2a5600a3ebc ("iio: accel: Add support for Bosch BMA220")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-6-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma220_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index 74024d7ce5ac..b6d9ab8e2054 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -67,7 +67,7 @@ struct bma220_data {
 		/* Ensure timestamp is naturally aligned. */
 		s64 timestamp __aligned(8);
 	} scan;
-	u8 tx_buf[2] ____cacheline_aligned;
+	u8 tx_buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 static const struct iio_chan_spec bma220_channels[] = {
-- 
2.35.1



