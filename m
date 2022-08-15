Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18782595033
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiHPEh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiHPEhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:37:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DFE9DF9E;
        Mon, 15 Aug 2022 13:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33B20B8119E;
        Mon, 15 Aug 2022 20:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DABC4314C;
        Mon, 15 Aug 2022 20:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595235;
        bh=z1xUNYx42fke/EV5QP7IxecBd8URVJ29kBbGoG4kACI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMdG5dQotN5xonSMsDsIrrkPeoZj6ToHNLk30ILY4hgXP5FXoa9v6u6sIU33+b5Pl
         8icaf+7tgmJxMzHfIlvR3htasRZIbG4iJ+2/gCp2wBh992BZOca0OSTdkauUT8DfrH
         KkFl9aMx5Qp5QK+J/9j1gz9H/jjFaJU0tCoDDqto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0701/1157] iio: gyro: adis16080: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:57 +0200
Message-Id: <20220815180507.650801423@linuxfoundation.org>
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

[ Upstream commit ae6eeb534924ecc2afd5a394964fd6de0ca54d39 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes tag is inaccurate but unlikely anyone will backport this
beyond that point so I haven't chased the history futher than 2013.

Fixes: 3c80372dae17 ("staging:iio:adis16080: be16 cleanups")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-73-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/adis16080.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/gyro/adis16080.c b/drivers/iio/gyro/adis16080.c
index acef59d822b1..14b3abf6dce9 100644
--- a/drivers/iio/gyro/adis16080.c
+++ b/drivers/iio/gyro/adis16080.c
@@ -45,7 +45,7 @@ struct adis16080_state {
 	const struct adis16080_chip_info *info;
 	struct mutex			lock;
 
-	__be16 buf ____cacheline_aligned;
+	__be16 buf __aligned(IIO_DMA_MINALIGN);
 };
 
 static int adis16080_read_sample(struct iio_dev *indio_dev,
-- 
2.35.1



