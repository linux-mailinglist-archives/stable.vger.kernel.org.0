Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774B9594072
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348616AbiHOVgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348952AbiHOVgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C058552FCB;
        Mon, 15 Aug 2022 12:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78AE06100A;
        Mon, 15 Aug 2022 19:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B977C433D7;
        Mon, 15 Aug 2022 19:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591532;
        bh=DnZBMLmbY0UB+P699kmZk580RYZWU16RG1msKGGlh8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qk7mnq8KgzkVK0vICcmVEq0bnbP4eRMIlDo0atzHP8wwrYIWM67Qz/0YmutD5LtlU
         vKgcYdr2o+/4DwMmV67OyxHVlbawKZkB3xC4QXNZ8CjJwuMADepf6huPfhrINg1sU1
         +dKDuKNcvRAGN6nmUXWSoJz9zuz3maXzZOTPWgRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0609/1095] iio: adc: max1118: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:08 +0200
Message-Id: <20220815180454.708500910@linuxfoundation.org>
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

[ Upstream commit f746ab0bac5b335b09143dcd01db6f9f26d0c9ec ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: a9e9c7153e96 ("iio: adc: add max1117/max1118/max1119 ADC driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-26-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1118.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max1118.c b/drivers/iio/adc/max1118.c
index a41bc570be21..75ab57d9aef7 100644
--- a/drivers/iio/adc/max1118.c
+++ b/drivers/iio/adc/max1118.c
@@ -42,7 +42,7 @@ struct max1118 {
 		s64 ts __aligned(8);
 	} scan;
 
-	u8 data ____cacheline_aligned;
+	u8 data __aligned(IIO_DMA_MINALIGN);
 };
 
 #define MAX1118_CHANNEL(ch)						\
-- 
2.35.1



