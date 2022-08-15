Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FC4593FB0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbiHOVmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349312AbiHOVkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:40:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480A75A3F9;
        Mon, 15 Aug 2022 12:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1A9761089;
        Mon, 15 Aug 2022 19:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3453C433D6;
        Mon, 15 Aug 2022 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591737;
        bh=Crn7UfGD8TI4bN32FbgUjAZlJe0HbeYgeSEAu/snc6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MunsartTcujR8ctq+/7Z41qMfWAs7qhoKtdCkY/k8SJnbRFtmvnSkOYlH6M9YKwPe
         P8vP6Pa9vpPUBgUTfpzpyogFeb59w1bL7+UcmrwA+FzH828d5HeyTQPp3BGXM6wCC+
         KHDG2qtsiULWo3WNtbMtOGtlb7oq7UgD5QEr2Sck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0658/1095] iio: gyro: adxrs450: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:57 +0200
Message-Id: <20220815180456.624957730@linuxfoundation.org>
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

[ Upstream commit 966d2f4ee7f6e189df47abf67223266ad31e201f ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes tag is inaccurate but unlikely anyone will be interested in
backporting beyond that point.

Fixes: 53ac8500ba9b ("staging:iio:adxrs450: Move header file contents to main file")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-75-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/adxrs450.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/gyro/adxrs450.c b/drivers/iio/gyro/adxrs450.c
index 04f350025215..f84438e0c42c 100644
--- a/drivers/iio/gyro/adxrs450.c
+++ b/drivers/iio/gyro/adxrs450.c
@@ -73,7 +73,7 @@ enum {
 struct adxrs450_state {
 	struct spi_device	*us;
 	struct mutex		buf_lock;
-	__be32			tx ____cacheline_aligned;
+	__be32			tx __aligned(IIO_DMA_MINALIGN);
 	__be32			rx;
 
 };
-- 
2.35.1



