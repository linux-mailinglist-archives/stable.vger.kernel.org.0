Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2C9593FB7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348825AbiHOVmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349365AbiHOVlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:41:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89245A8A2;
        Mon, 15 Aug 2022 12:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8555CB81109;
        Mon, 15 Aug 2022 19:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE76AC433D7;
        Mon, 15 Aug 2022 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591740;
        bh=YXN664tHlqpao73ub4aCiZFPrlz/XdG5wd1w5nCQIKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLCzTh7veo/Yjnv1roYZj6lGgiyQauLj+XV+qe9kf4ShH2xtsonLc21wS9dS7itMb
         bJAnRyi18rqDOP5H13zowBp6+LVAfXIOqEZYDDQDeJamYmaBFfGT2A5nyy0j1rvxCU
         ZV21D2VRaHARZTs8FEhOxoBDGiyyiqqOTLc7sb5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <mranostay@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0674/1095] iio: temp: maxim_thermocouple: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:13 +0200
Message-Id: <20220815180457.255675593@linuxfoundation.org>
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

[ Upstream commit 10897f34309b3c7bc14698407436c82d11c07f47 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition

Fixes: 1f25ca11d84a ("iio: temperature: add support for Maxim thermocouple chips")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matt Ranostay <mranostay@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-93-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/maxim_thermocouple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/maxim_thermocouple.c b/drivers/iio/temperature/maxim_thermocouple.c
index 98c41cddc6f0..c28a7a6dea5f 100644
--- a/drivers/iio/temperature/maxim_thermocouple.c
+++ b/drivers/iio/temperature/maxim_thermocouple.c
@@ -122,7 +122,7 @@ struct maxim_thermocouple_data {
 	struct spi_device *spi;
 	const struct maxim_thermocouple_chip *chip;
 
-	u8 buffer[16] ____cacheline_aligned;
+	u8 buffer[16] __aligned(IIO_DMA_MINALIGN);
 	char tc_type;
 };
 
-- 
2.35.1



