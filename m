Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCA9595006
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiHPEgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiHPEfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAC7CAC87;
        Mon, 15 Aug 2022 13:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C2960EE9;
        Mon, 15 Aug 2022 20:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC13C433C1;
        Mon, 15 Aug 2022 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595267;
        bh=an4bUhqZY3EouznEf8JWpPb3qALmzTCafVC8Jys3Shk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WENeyCTmxQQolZMPz6I/xTTwVkVe8Nr41bH0P0EcFQD+Ej0fRsg8N/EABJNVlOT05
         Pe1bCQXkYw5KMZuzJFl0OpAFW+vmBE8cEUcFyEqd9SwuM9jMezWeZNwZUz5oLkbq76
         gXPIBKiKBkQ7C/7FkJ3O/IivMoKwbnnFv5ij1zKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Phil Reid <preid@electromag.com.au>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0710/1157] iio: potentiometer: ad5272: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:06 +0200
Message-Id: <20220815180507.949624603@linuxfoundation.org>
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



