Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D20593ED2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349022AbiHOVmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbiHOVjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:39:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FB22B266;
        Mon, 15 Aug 2022 12:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A686ECE10E7;
        Mon, 15 Aug 2022 19:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B98C433D6;
        Mon, 15 Aug 2022 19:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591704;
        bh=9zNDmu/zOk4ltrP6s2+OhrMweR1ou95kUO+IEG4hVQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi1MysNp9jmmL8E1DsWXl7e+vzERmoH18U+Msw2+YNTXXjv5SeCM2BklTd0+FcQlv
         5V3JL7eOO5dwBD9WMEDcV4gRoKPomb5Yd4cYfNtARO41eG/If4JVxG6+TuT545f6MK
         osg3GsvBvbZkg5iz6SndAwCIhHYP24kKv5TQLsAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0666/1095] iio: potentiometer: max5481: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:05 +0200
Message-Id: <20220815180456.946628371@linuxfoundation.org>
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

[ Upstream commit ec1ac1c0e7a14657d729159ccfbea72f434bdaf1 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: df1fd2de118e ("iio: max5481: Add support for Maxim digital potentiometers")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-83-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/max5481.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/potentiometer/max5481.c b/drivers/iio/potentiometer/max5481.c
index 098d144a8fdd..b40e5ac218d7 100644
--- a/drivers/iio/potentiometer/max5481.c
+++ b/drivers/iio/potentiometer/max5481.c
@@ -44,7 +44,7 @@ static const struct max5481_cfg max5481_cfg[] = {
 struct max5481_data {
 	struct spi_device *spi;
 	const struct max5481_cfg *cfg;
-	u8 msg[3] ____cacheline_aligned;
+	u8 msg[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define MAX5481_CHANNEL {					\
-- 
2.35.1



