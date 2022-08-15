Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1059502A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiHPEhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiHPEgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A0A9DB5E;
        Mon, 15 Aug 2022 13:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11642B811A2;
        Mon, 15 Aug 2022 20:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A178C43141;
        Mon, 15 Aug 2022 20:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595232;
        bh=PatvG9eaTtQbGqYAXTyhKleN5tMw5LZqmxtcyReqGO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfoKCw4C/2xjQtWAziJQwomT6AIe0iqbWUTBhQ0WwBgXe/GDFX+OsPfcI6TvsWvNh
         gDeRLm6hdKjvOlGlxgYG19BDmQytiMDbpIN2ZMFDaDo/cmcrS2XNlMkNK29Jc/uf9K
         QlWIWGdHrqvEmFlsbhZkumjL/z39KRQyVoEN4C3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Antoniu Miclaus <antoniu.miclaus@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0700/1157] iio: frequency: adrf6780: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:56 +0200
Message-Id: <20220815180507.610123308@linuxfoundation.org>
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

[ Upstream commit 9a5b11884cb72780cb824cac8aab47094654a84f ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 63aaf6d06d87 ("iio: frequency: adrf6780: add support for ADRF6780")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Antoniu Miclaus <antoniu.miclaus@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-72-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adrf6780.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/frequency/adrf6780.c b/drivers/iio/frequency/adrf6780.c
index 8255ffd174f6..21878bad0909 100644
--- a/drivers/iio/frequency/adrf6780.c
+++ b/drivers/iio/frequency/adrf6780.c
@@ -86,7 +86,7 @@ struct adrf6780_state {
 	bool			uc_bias_en;
 	bool			lo_sideband;
 	bool			vdet_out_en;
-	u8			data[3] ____cacheline_aligned;
+	u8			data[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 static int __adrf6780_spi_read(struct adrf6780_state *st, unsigned int reg,
-- 
2.35.1



