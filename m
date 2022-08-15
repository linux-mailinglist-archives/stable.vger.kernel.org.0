Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC9B593FC7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348831AbiHOVix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244325AbiHOVhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:37:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B9A625D;
        Mon, 15 Aug 2022 12:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54ED56102C;
        Mon, 15 Aug 2022 19:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415B8C433D6;
        Mon, 15 Aug 2022 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591644;
        bh=qC+fTR72lKNazJDRxV9oVf7A+NTEtgKs6MUoauoVF+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbahZjsL/YSn9Jiyu9ZnmMeC1OejoZLunMebMxszgRmtJ0loWsAswBlS3BlOMIj2E
         oY/JD21p8HhOLf4MSitLBDmvM9od7n7Y0lohmrDCbgAu7mczIiZbseOgXghLDa19Ek
         iGn+f3bO7J2MbwpqN0sr4MAngKm0+LOUYY2nsHU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0646/1095] iio: dac: ti-dac5571: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:45 +0200
Message-Id: <20220815180456.117078873@linuxfoundation.org>
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

[ Upstream commit 58e22371539e01c742be5c30295f591a6a17e348 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: df38a4a72a3b ("iio: dac: add TI DAC5571 family support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-63-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ti-dac5571.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ti-dac5571.c b/drivers/iio/dac/ti-dac5571.c
index 0b775f943db3..ba68ea1e3455 100644
--- a/drivers/iio/dac/ti-dac5571.c
+++ b/drivers/iio/dac/ti-dac5571.c
@@ -52,7 +52,7 @@ struct dac5571_data {
 	struct dac5571_spec const *spec;
 	int (*dac5571_cmd)(struct dac5571_data *data, int channel, u16 val);
 	int (*dac5571_pwrdwn)(struct dac5571_data *data, int channel, u8 pwrdwn);
-	u8 buf[3] ____cacheline_aligned;
+	u8 buf[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define DAC5571_POWERDOWN(mode)		((mode) + 1)
-- 
2.35.1



