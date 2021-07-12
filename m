Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEF93C551F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353354AbhGLIJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352869AbhGLIAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5507F61C28;
        Mon, 12 Jul 2021 07:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076423;
        bh=clL+tDJYbKO7141C4vwWEHJR2V9LUOIGvKOSYJMVTiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQRVrC4LVBV6cmHPTXzW/47yzYGPsa2bRyyf9bVTNOmL5tAehne0pwsChNyDV7U91
         iaDKXimWOIB2K2jtAypVDMN6g4AkzDPRi9+yubJP36CBxoGpV/0yGD6AiG1fs4ZjvG
         +Z4DGOnyYcbXa98il5dt1QI2Cs9Av0+hgVhOTyNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 637/800] iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:00 +0200
Message-Id: <20210712061034.887465335@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 8979b67ec61abc232636400ee8c758a16a73c95f ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Here structure is not used, because this buffer is also used
elsewhere in the driver.

Fixes: 67e17300dc1d ("iio: potentiostat: add LMP91000 support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Link: https://lore.kernel.org/r/20210501171352.512953-8-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiostat/lmp91000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/potentiostat/lmp91000.c b/drivers/iio/potentiostat/lmp91000.c
index 8a9c576616ee..ff39ba975da7 100644
--- a/drivers/iio/potentiostat/lmp91000.c
+++ b/drivers/iio/potentiostat/lmp91000.c
@@ -71,8 +71,8 @@ struct lmp91000_data {
 
 	struct completion completion;
 	u8 chan_select;
-
-	u32 buffer[4]; /* 64-bit data + 64-bit timestamp */
+	/* 64-bit data + 64-bit naturally aligned timestamp */
+	u32 buffer[4] __aligned(8);
 };
 
 static const struct iio_chan_spec lmp91000_channels[] = {
-- 
2.30.2



