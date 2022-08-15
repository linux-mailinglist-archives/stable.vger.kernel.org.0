Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD86595024
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiHPEhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiHPEgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:36:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72599C210;
        Mon, 15 Aug 2022 13:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65A9F61089;
        Mon, 15 Aug 2022 20:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513DDC433C1;
        Mon, 15 Aug 2022 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595204;
        bh=LKS5fls3b0rL9L9SXSmCMaU/hrG7AW6TsELGrKgnn0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flzSJmrxRTmkzfDlkOXrNGn/tmEms6D3dcF4dZvczKkAyyck39Mw0GGFndyNcg3UV
         ktyFpQkHSxNRyS/DUNsmfSo3l81f3S+7U1se/fBvQ00FpjJNc4qiiNzTtHIVfyu3SL
         IqEMD6QrsXE+gJEh3P/NPNVhyeey721EwhdBenEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0658/1157] iio: adc: ti-adc084s021: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:14 +0200
Message-Id: <20220815180506.053821625@linuxfoundation.org>
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

[ Upstream commit bb102fd600d1d6c0020a4514197c0604c4a218d9 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: 3691e5a69449 ("iio: adc: add driver for the ti-adc084s021 chip")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Mårten Lindahl <marten.lindahl@axis.com>
Link: https://lore.kernel.org/r/20220508175712.647246-30-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-adc084s021.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti-adc084s021.c b/drivers/iio/adc/ti-adc084s021.c
index c9b5d9aec3dc..1f6e53832e06 100644
--- a/drivers/iio/adc/ti-adc084s021.c
+++ b/drivers/iio/adc/ti-adc084s021.c
@@ -32,10 +32,10 @@ struct adc084s021 {
 		s64 ts __aligned(8);
 	} scan;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache line.
 	 */
-	u16 tx_buf[4] ____cacheline_aligned;
+	u16 tx_buf[4] __aligned(IIO_DMA_MINALIGN);
 	__be16 rx_buf[5]; /* First 16-bits are trash */
 };
 
-- 
2.35.1



