Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C7F594235
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiHOVrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349376AbiHOVpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:45:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33864C9EAA;
        Mon, 15 Aug 2022 12:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94D49B81062;
        Mon, 15 Aug 2022 19:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA6FC433D6;
        Mon, 15 Aug 2022 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591806;
        bh=rqdC4nZwbSnbxPw0o+7GJSE6FDRyxJqDCjoWH0/UZjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8zxx/mDsjwsvbPa+jaRyGihBRpyFOmBT+VK71qE6f38zE/t75TJ1wHz+TRvIAoQ0
         bu6nMCj1mSLAKwHQ1Tzyi23fHaYbvItWti/QasNaFcNXb7Pw59C7+lAChXIBP8J0qd
         XvfpaKv/TzrtwLLxNwnxM72HDvu5UX+KAuN1wfQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Robert Jones <rjones@gateworks.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0660/1095] iio: imu: fxos8700: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:59 +0200
Message-Id: <20220815180456.707717476@linuxfoundation.org>
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

[ Upstream commit c9a8417a13ed9c81383662fca8a4b89f84d31e78 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Robert Jones <rjones@gateworks.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-77-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/fxos8700_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index ab288186f36e..423cfe526f2a 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -167,7 +167,7 @@
 struct fxos8700_data {
 	struct regmap *regmap;
 	struct iio_trigger *trig;
-	__be16 buf[FXOS8700_DATA_BUF_SIZE] ____cacheline_aligned;
+	__be16 buf[FXOS8700_DATA_BUF_SIZE] __aligned(IIO_DMA_MINALIGN);
 };
 
 /* Regmap info */
-- 
2.35.1



