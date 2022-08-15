Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F28859424C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349581AbiHOVsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350212AbiHOVr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6336524A;
        Mon, 15 Aug 2022 12:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6928BB810C6;
        Mon, 15 Aug 2022 19:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E89EC433D6;
        Mon, 15 Aug 2022 19:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591874;
        bh=an4bUhqZY3EouznEf8JWpPb3qALmzTCafVC8Jys3Shk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tA3JDqiG2U0crjp0ddWGGsULGjdw+s+D+tsmAwq5jvtOnS+Cy/W5iCjia7+G7MhZr
         spu8g7GS257+oqVoUdtXhTx/sVL9lqZ6ySAaW9hBj1vogaUvrln1BDMXrwtg0wMBIb
         UeP10lFyiXlUdappCojc8JxSKjyyDJRn3Spk6qGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Phil Reid <preid@electromag.com.au>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0665/1095] iio: potentiometer: ad5272: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:04 +0200
Message-Id: <20220815180456.906096386@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit da803652534271dbb4af0802bd678c759e27e6de ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 79e8a32d2aa9 ("iio: ad5272: Add support for Analog Devices digital potentiometers")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Phil Reid <preid@electromag.com.au>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-82-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/ad5272.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/potentiometer/ad5272.c b/drivers/iio/potentiometer/ad5272.c
index d8cbd170262f..ed5fc0b50fe9 100644
--- a/drivers/iio/potentiometer/ad5272.c
+++ b/drivers/iio/potentiometer/ad5272.c
@@ -50,7 +50,7 @@ struct ad5272_data {
 	struct i2c_client       *client;
 	struct mutex            lock;
 	const struct ad5272_cfg *cfg;
-	u8                      buf[2] ____cacheline_aligned;
+	u8                      buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 static const struct iio_chan_spec ad5272_channel = {
-- 
2.35.1



