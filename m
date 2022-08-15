Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C0959417E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349112AbiHOVjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348832AbiHOVho (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03922764B;
        Mon, 15 Aug 2022 12:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A7560EF0;
        Mon, 15 Aug 2022 19:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86967C433D6;
        Mon, 15 Aug 2022 19:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591648;
        bh=p602ogtdB0tsIU314uDoYRHO1tao2jzK++pqzAL2gtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQbxzwexEAQIeXQProorV61ubUcd7oXbwc3bSaMEvQl3ZLus8/KuiA4/m1ydlc6h1
         Drx+e0wY5m7u+cmQ838mpPQqbzPwF4YpMktpchqSY/LUqCPITN0KLiy/OMAo7May0c
         0hELwNb+zBt5GH0rIpXLjDZuGFs4JKQvgxqmwBik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Charles-Antoine Couret <charles-antoine.couret@essensium.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0647/1095] iio: dac: ti-dac7311: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:46 +0200
Message-Id: <20220815180456.156169522@linuxfoundation.org>
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

[ Upstream commit 3637c49ed54632d7c221af718d2d7b1d381d4b6e ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 7a02ef7907d8 ("iio:dac:ti-dac7311 Add driver for Texas Instrument DAC7311")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Charles-Antoine Couret <charles-antoine.couret@essensium.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-64-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ti-dac7311.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ti-dac7311.c b/drivers/iio/dac/ti-dac7311.c
index e10d17e60ed3..dd0a7b77838d 100644
--- a/drivers/iio/dac/ti-dac7311.c
+++ b/drivers/iio/dac/ti-dac7311.c
@@ -52,7 +52,7 @@ struct ti_dac_chip {
 	bool powerdown;
 	u8 powerdown_mode;
 	u8 resolution;
-	u8 buf[2] ____cacheline_aligned;
+	u8 buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 static u8 ti_dac_get_power(struct ti_dac_chip *ti_dac, bool powerdown)
-- 
2.35.1



