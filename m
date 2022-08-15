Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25050594143
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348658AbiHOVie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348667AbiHOVhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CF32E4;
        Mon, 15 Aug 2022 12:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7F8610A3;
        Mon, 15 Aug 2022 19:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FC7C433C1;
        Mon, 15 Aug 2022 19:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591612;
        bh=ZxyM/5s66vFtuDDP4J/0MFczF9QSWxEyXjL60nT96AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4J8NacJkVa2rfvCuXuFmNLXAm0VNy9z5I0OlBp6RKOyUHb+yzf/RI8KRUtgokO9Q
         3KNK/A68Lh3Ie/qbIiJwCsQZURtSNNj4RTdZVFrsARYYu7rAQYFCBd2+HfBViPxgPx
         wCHmICwuVhi6zPTqKKGQpKknE1rkXuMtst9DR/+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0637/1095] iio: dac: ad5766: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:36 +0200
Message-Id: <20220815180455.770895356@linuxfoundation.org>
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

[ Upstream commit c32be7f035ae430ba9c142b03ceb9f935b09ed6b ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: fd9373e41b9b ("iio: dac: ad5766: add driver support for AD5766")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-54-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5766.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5766.c b/drivers/iio/dac/ad5766.c
index 43189af2fb1f..899894523752 100644
--- a/drivers/iio/dac/ad5766.c
+++ b/drivers/iio/dac/ad5766.c
@@ -123,7 +123,7 @@ struct ad5766_state {
 		u32	d32;
 		u16	w16[2];
 		u8	b8[4];
-	} data[3] ____cacheline_aligned;
+	} data[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 struct ad5766_span_tbl {
-- 
2.35.1



