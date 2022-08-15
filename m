Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9578459503D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiHPEid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiHPEhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:37:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699209C8E9;
        Mon, 15 Aug 2022 13:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F59B80EB1;
        Mon, 15 Aug 2022 20:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7C7C433D7;
        Mon, 15 Aug 2022 20:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595226;
        bh=/9wTTWYpJmeNGuD84j1NlmzJZzRviZVkVE1BRX7+QXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scaUjlHdyzYSow7G0rwpo/+fJaVGTzkcNAijIoZMLUTeudSUdp/jDwc27mCNn6Rhf
         Az/MrnKy5pK/UD71U/aaDfQ6AmrH9uTWPtnOo3PsXsLLGFXSW/pqXairmYrDlxjnwH
         cPBNodUZdcQ7WrA/zIVLMfn/RA+JaI3XG8ZOPDso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Antoniu Miclaus <antoniu.miclaus@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0698/1157] iio: frequency: admv1014: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:54 +0200
Message-Id: <20220815180507.548968904@linuxfoundation.org>
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

[ Upstream commit a3e38a557a54df0edea791d7eb623515bb86e39a ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: f4eb9ac7842f ("iio: frequency: admv1014: add support for ADMV1014")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Antoniu Miclaus <antoniu.miclaus@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-70-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/admv1014.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/frequency/admv1014.c b/drivers/iio/frequency/admv1014.c
index 1aac5665b5de..865addd10db4 100644
--- a/drivers/iio/frequency/admv1014.c
+++ b/drivers/iio/frequency/admv1014.c
@@ -127,7 +127,7 @@ struct admv1014_state {
 	unsigned int			quad_se_mode;
 	unsigned int			p1db_comp;
 	bool				det_en;
-	u8				data[3] ____cacheline_aligned;
+	u8				data[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 static const int mixer_vgate_table[] = {106, 107, 108, 110, 111, 112, 113, 114,
-- 
2.35.1



