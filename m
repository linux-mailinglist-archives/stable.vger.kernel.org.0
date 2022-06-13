Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B34E548DD0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381510AbiFMOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381452AbiFMOEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707A39FC7;
        Mon, 13 Jun 2022 04:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE7BB80EC6;
        Mon, 13 Jun 2022 11:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797AFC34114;
        Mon, 13 Jun 2022 11:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120376;
        bh=A7yp75K1ZjPXGfXpDlsSFQSDKF3BAbS8e9qL2isonl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWa+TZ3JqBhhoL2lhhCSFDLVdyrp7zTcU4XgIt+BdWSPGk8o73RUcQNoveQsGhVFI
         iJBY4ve2nQeJwktqOOTaZgH6baa5isQ0tyNCwHlJpKo+By6Jms2phlopJTF+CetJ3o
         djnlpMSrnbxLOwGcF+p4Ts8guIKVwPP/OLNXoXtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 003/298] iio: adc: ad7124: Remove shift from scan_type
Date:   Mon, 13 Jun 2022 12:08:17 +0200
Message-Id: <20220613094925.023847249@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

[ Upstream commit fe78ccf79b0e29fd6d8dc2e2c3b0dbeda4ce3ad8 ]

The 24 bits data is stored in 32 bits in BE. There
is no need to shift it. This confuses user-space apps.

Fixes: b3af341bbd966 ("iio: adc: Add ad7124 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Link: https://lore.kernel.org/r/20220322105029.86389-2-alexandru.tachici@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index b400bbe291aa..c22d8dcaa100 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -188,7 +188,6 @@ static const struct iio_chan_spec ad7124_channel_template = {
 		.sign = 'u',
 		.realbits = 24,
 		.storagebits = 32,
-		.shift = 8,
 		.endianness = IIO_BE,
 	},
 };
-- 
2.35.1



