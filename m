Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28911594A8B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351304AbiHPAEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357224AbiHPAD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4728C168A7A;
        Mon, 15 Aug 2022 13:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E6C61135;
        Mon, 15 Aug 2022 20:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6348C433D6;
        Mon, 15 Aug 2022 20:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595283;
        bh=Fz0Od070cEnkqYN5WQgTtuDbh/fruRSQCiM/ni+h/wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHd1e4coJ7OoQOdv+omKNQ/iIzK/e05qZMUTcD2ZgIj/tpfKu9UgI9MGhgXbGwzxz
         OGD7nWPepsIouUAKx1Bfnokn1MNwgsWbhBnM3zKshuIGq56WLhezJsg6BztrCs7rvd
         tnaEUNL/pwwH0rPOdUR5tNtc0BL2jM+x6txKxKBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0715/1157] iio: resolver: ad2s1200: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:11 +0200
Message-Id: <20220815180508.128391647@linuxfoundation.org>
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

[ Upstream commit 37882314d3bdc2ae775ebb9fa8ed7a94cd1aad61 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes tag is probably not where the issue was first introduced, but
is likely to be as far as anyone considers backporting this fix.

Fixes: 0bd3d338f61b ("staging: iio: ad2s1200: Improve readability with be16_to_cpup")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-89-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/resolver/ad2s1200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/resolver/ad2s1200.c b/drivers/iio/resolver/ad2s1200.c
index 9746bd935628..9d95241bdf8f 100644
--- a/drivers/iio/resolver/ad2s1200.c
+++ b/drivers/iio/resolver/ad2s1200.c
@@ -41,7 +41,7 @@ struct ad2s1200_state {
 	struct spi_device *sdev;
 	struct gpio_desc *sample;
 	struct gpio_desc *rdvel;
-	__be16 rx ____cacheline_aligned;
+	__be16 rx __aligned(IIO_DMA_MINALIGN);
 };
 
 static int ad2s1200_read_raw(struct iio_dev *indio_dev,
-- 
2.35.1



