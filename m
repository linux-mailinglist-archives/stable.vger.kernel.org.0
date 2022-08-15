Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A745940FC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348579AbiHOVe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348591AbiHOVds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BC85FF78;
        Mon, 15 Aug 2022 12:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 683B56101F;
        Mon, 15 Aug 2022 19:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CC3C433D6;
        Mon, 15 Aug 2022 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591480;
        bh=Rc89W/iujlQ4wimzvMqL0A9iZ4hEsIzX4Ta5xrszvkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXJDZrdgtkcnRoZzJk6ChSw4JQ67+kOjDuUNTgjioHbSUkqFDKTtsS5Yl8En2Xy6s
         MTyJ1+FflflAyolTYxbNQTVPr3NEQBSw+eXrN+1oVXKIPxLyfyl0swYeQyHPB9TBYO
         BlWb/X6raJ3y24/ixvccC76epeA2+q8mBvcwqKDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0594/1095] iio: adc: ad7280a: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:53 +0200
Message-Id: <20220815180454.131911748@linuxfoundation.org>
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

[ Upstream commit 4e2008429588b857bbc13d048b67b931a8d84816 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 003f1d48de52 ("staging:iio:adc:ad7280a: Split buff[2] into tx and rx parts")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-11-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7280a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7280a.c b/drivers/iio/adc/ad7280a.c
index ec9acbf12b9a..047a9d0dbcf7 100644
--- a/drivers/iio/adc/ad7280a.c
+++ b/drivers/iio/adc/ad7280a.c
@@ -183,7 +183,7 @@ struct ad7280_state {
 	unsigned char			cb_mask[AD7280A_MAX_CHAIN];
 	struct mutex			lock; /* protect sensor state */
 
-	__be32				tx ____cacheline_aligned;
+	__be32				tx __aligned(IIO_DMA_MINALIGN);
 	__be32				rx;
 };
 
-- 
2.35.1



