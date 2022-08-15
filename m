Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E877594FEA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiHPEeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiHPEeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:34:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D0B16DC53;
        Mon, 15 Aug 2022 13:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11F73B80EAD;
        Mon, 15 Aug 2022 20:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336C1C433D6;
        Mon, 15 Aug 2022 20:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595122;
        bh=o+aJkkxQg1xdwE3GE8FcNT0QI3kL4+w+o02wQgstK8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuS4abClBbLwXD1a1q/ZxmvGca0vZK9CLgNKim+fuP1UDnkWbeb6+TrmrAH2ReJ88
         W9zxt3nOurxqLJWAQShbiAt5aGRpTHdZ+0ZIOkljJ7FnJmXHN2QtwEOtZ9IS8vmUqT
         yHiDd157DGYquTLloybqI6nz8/2maBUTPuNaHiS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Tomislav Denis <tomislav.denis@avl.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0664/1157] iio: adc: ti-ads131e08: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:20 +0200
Message-Id: <20220815180506.284127352@linuxfoundation.org>
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

[ Upstream commit 55afdd050c063ae4b8dbd566107a030c00d005fd ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: d935eddd2799 ("iio: adc: Add driver for Texas Instruments ADS131E0x ADC family")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Tomislav Denis <tomislav.denis@avl.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-36-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads131e08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads131e08.c b/drivers/iio/adc/ti-ads131e08.c
index 80a09817c119..32237cacc9a3 100644
--- a/drivers/iio/adc/ti-ads131e08.c
+++ b/drivers/iio/adc/ti-ads131e08.c
@@ -105,7 +105,7 @@ struct ads131e08_state {
 		s64 ts __aligned(8);
 	} tmp_buf;
 
-	u8 tx_buf[3] ____cacheline_aligned;
+	u8 tx_buf[3] __aligned(IIO_DMA_MINALIGN);
 	/*
 	 * Add extra one padding byte to be able to access the last channel
 	 * value using u32 pointer
-- 
2.35.1



