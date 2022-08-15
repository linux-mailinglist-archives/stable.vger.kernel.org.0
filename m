Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA46594AB2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353265AbiHPAFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356481AbiHPAC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D73161017;
        Mon, 15 Aug 2022 13:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5960560F71;
        Mon, 15 Aug 2022 20:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4921AC433C1;
        Mon, 15 Aug 2022 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595019;
        bh=pDQAiluEMFznMnl6qm26vpua8zn+CoKeaErTyh8RvIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Coybwr/Nm55If6dNXLBT2KF8M0N9zgzR9X6+yU6NlrLOiuNhjhQXKyxHfxDNZFF7n
         2hUec21780P7Ui5KKLjwWRxj9upZL6auXRHvSPCpoSyFm6sGpp2Er8zPhazk9zZjgg
         +lkTxwTwP+AdyD0wWlskj7MoE5VUNuLPXtPjkl5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0632/1157] iio: accel: adxl313: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:48 +0200
Message-Id: <20220815180504.971801232@linuxfoundation.org>
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

[ Upstream commit f68a0445ee86e48dafbfdea50163ad6fc6dba268 ]

____cacheline_aligned is insufficient guarantee for non-coherent DMA.
Switch to the updated IIO_DMA_MINALIGN definition.

Fixes: 636d44633039 ("iio: accel: Add driver support for ADXL313")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-3-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl313_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl313_core.c b/drivers/iio/accel/adxl313_core.c
index 9e4193e64765..afeef779e1d0 100644
--- a/drivers/iio/accel/adxl313_core.c
+++ b/drivers/iio/accel/adxl313_core.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL_NS_GPL(adxl313_writable_regs_table, IIO_ADXL313);
 struct adxl313_data {
 	struct regmap	*regmap;
 	struct mutex	lock; /* lock to protect transf_buf */
-	__le16		transf_buf ____cacheline_aligned;
+	__le16		transf_buf __aligned(IIO_DMA_MINALIGN);
 };
 
 static const int adxl313_odr_freqs[][2] = {
-- 
2.35.1



