Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237F83C4700
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhGLGa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235847AbhGLG3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60DDB6120A;
        Mon, 12 Jul 2021 06:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071160;
        bh=Y99GdsWKTvk70lkouPOA4ECshFl5149s7UG2EM3wNa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEs6l4DuCsuyFMBj4v1/Wm/HN5nse9Jw4R8pJRdgYST4EAULT1of/vq4I5IC1rpDg
         9y75R6PUcmuDmpuxqz64OFdAlaqqxGdoqWuBzmizeQakDElH7LYeiui/cT59TPSY2k
         Fp9l6fL549gU57X9Gu48FwoiJY6A2JULk9e9ysFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 258/348] iio: adis_buffer: do not return ints in irq handlers
Date:   Mon, 12 Jul 2021 08:10:42 +0200
Message-Id: <20210712060737.399490629@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit d877539ad8e8fdde9af69887055fec6402be1a13 ]

On an IRQ handler we should not return normal error codes as 'irqreturn_t'
is expected.

Not necessarily stable material as the old check cannot fail, so it's a bug
we can not hit.

Fixes: ccd2b52f4ac69 ("staging:iio: Add common ADIS library")
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210422101911.135630-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis_buffer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iio/imu/adis_buffer.c b/drivers/iio/imu/adis_buffer.c
index 4998a89d083d..8f8c1a87567b 100644
--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -125,9 +125,6 @@ static irqreturn_t adis_trigger_handler(int irq, void *p)
 	struct adis *adis = iio_device_get_drvdata(indio_dev);
 	int ret;
 
-	if (!adis->buffer)
-		return -ENOMEM;
-
 	if (adis->data->has_paging) {
 		mutex_lock(&adis->txrx_lock);
 		if (adis->current_page != 0) {
-- 
2.30.2



