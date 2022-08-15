Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3486C594AD0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355974AbiHPAGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357247AbiHPAD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BAF16F899;
        Mon, 15 Aug 2022 13:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B7660EE9;
        Mon, 15 Aug 2022 20:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D852AC433D6;
        Mon, 15 Aug 2022 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595292;
        bh=Ld/+h+6Y3JmehVI9m60Wd4KS1sk9c3Xu6SM3lKeK55E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb6rb4LTZz71kTp6SNfXFLbYmZQsTnTukhfgTko9ZJYxycX7AFqvcLwvXfx29now/
         HLypM+Qz2N7vUj3c6HhhbW6r0qKbVpjHC3JvB0PeqzaEfZqsUtLFcadl7IX/LAu2fm
         nBA93Us/Ippi7NdJvHVAnuaIHr4eQkXOQgmjxI1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0717/1157] iio: temp: ltc2983: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:13 +0200
Message-Id: <20220815180508.193549352@linuxfoundation.org>
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

[ Upstream commit 732f2cb2fbb51bd5bc03a114bd102ab3b2f537fe ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-91-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/ltc2983.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 4fc654275155..4b7f2b8a9758 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -204,11 +204,11 @@ struct ltc2983_data {
 	u8 num_channels;
 	u8 iio_channels;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * Holds the converted temperature
 	 */
-	__be32 temp ____cacheline_aligned;
+	__be32 temp __aligned(IIO_DMA_MINALIGN);
 };
 
 struct ltc2983_sensor {
-- 
2.35.1



