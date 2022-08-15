Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1EE593FAD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348661AbiHOVhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348981AbiHOVgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DB6DD758;
        Mon, 15 Aug 2022 12:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A200BB81125;
        Mon, 15 Aug 2022 19:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07409C433C1;
        Mon, 15 Aug 2022 19:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591536;
        bh=fkS7l4Mv2LRZIz6RMO+Qh8fV/b9u3krpLRZn04lzIRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ6nuqlwws6y/45uLVJkEfVcQ1smW6bnrqUSbQlJlt2KV0Fb4TX2U4M3f3mbAdqUd
         V4gybGg8hPHU/45jtsxqBHeogoP/iMXTO9O8zt+TK5Oulg14sYLn1By1oXinKhNfXM
         MGFjC6wT3yUuEpO/ZA9assezAH+5Ps2pTdMpZTYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Lazar <alazar@startmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0610/1095] iio: adc: max1241: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:09 +0200
Message-Id: <20220815180454.743090611@linuxfoundation.org>
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

[ Upstream commit 9d7019e43ee67a48cef63f8f23f002233064d390 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 8a80a71d9020 ("iio: adc: Add MAX1241 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Alexandru Lazar <alazar@startmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-27-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1241.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max1241.c b/drivers/iio/adc/max1241.c
index a5afd84af58b..a815ad1f6913 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -26,7 +26,7 @@ struct max1241 {
 	struct regulator *vref;
 	struct gpio_desc *shutdown;
 
-	__be16 data ____cacheline_aligned;
+	__be16 data __aligned(IIO_DMA_MINALIGN);
 };
 
 static const struct iio_chan_spec max1241_channels[] = {
-- 
2.35.1



