Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECDE59410B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349032AbiHOVji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349039AbiHOVib (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:38:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12072DABF;
        Mon, 15 Aug 2022 12:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E74B81062;
        Mon, 15 Aug 2022 19:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8939EC433C1;
        Mon, 15 Aug 2022 19:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591691;
        bh=yEOsJkf0JUzDzGdTK4Ndj7FqnAcfm+AIdD0yILuhxek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTH+jBm02Q8WdLNeWmun/BZe9gvVujX9uh7/eDnKwsibv4umteRuW4sFgVyiRqBNK
         AvtnWBD2VMkgeF/9tQuY84Sm/6KOjeoRCgUgQHZOjROn9uvFzzwyB2gYNiN0UgFFI1
         oYxo8jV8I1gEawEEoPN8lv2bohrR62XWcRhzMqG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0626/1095] iio: common: ssp: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:25 +0200
Message-Id: <20220815180455.342707295@linuxfoundation.org>
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

[ Upstream commit 314d2b1978bb3d20b1ec239f4e28c394da493f36 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-43-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/common/ssp_sensors/ssp.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/common/ssp_sensors/ssp.h b/drivers/iio/common/ssp_sensors/ssp.h
index abb832795619..f649cdecc277 100644
--- a/drivers/iio/common/ssp_sensors/ssp.h
+++ b/drivers/iio/common/ssp_sensors/ssp.h
@@ -221,8 +221,7 @@ struct ssp_data {
 	struct iio_dev *sensor_devs[SSP_SENSOR_MAX];
 	atomic_t enable_refcount;
 
-	__le16 header_buffer[SSP_HEADER_BUFFER_SIZE / sizeof(__le16)]
-		____cacheline_aligned;
+	__le16 header_buffer[SSP_HEADER_BUFFER_SIZE / sizeof(__le16)] __aligned(IIO_DMA_MINALIGN);
 };
 
 void ssp_clean_pending_list(struct ssp_data *data);
-- 
2.35.1



