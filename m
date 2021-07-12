Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EC33C4FBA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbhGLH1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345396AbhGLHZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DDA3611AF;
        Mon, 12 Jul 2021 07:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074559;
        bh=CO02HGpR4gwSOc93xPDJUXZ4YgGAb9nP2Ad9BgTe4B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLglfNtngbEqUGfKAiij62J/M+GPL3UaTSqHOoRnHPrwnKB2g5XEtUY/XGXntlIHp
         Ix0AKs+zScW6Oi3dyhsIn/gTa+EX4nDAGmOySiF2F0Qf6SVaQTDaN9hVVZejYJf4Zz
         Mcx5IO3Sx3lKEx7DF4uAMZ5vbq3EETrTCmuU23Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mathieu Othacehe <m.othacehe@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 618/700] iio: light: vcnl4000: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:41 +0200
Message-Id: <20210712061041.614826553@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit dce793c0ab00c35039028fdcd5ce123805a01361 ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Here an explicit structure is not used, because the holes would
necessitate the addition of an explict memset(), to avoid a kernel
data leak, making for a less minimal fix.

Found during an audit of all callers of iio_push_to_buffers_with_timestamp()

Fixes: 8fe78d5261e7 ("iio: vcnl4000: Add buffer support for VCNL4010/20.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mathieu Othacehe <m.othacehe@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-7-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index fff4b36b8b58..f4feb44903b3 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -910,7 +910,7 @@ static irqreturn_t vcnl4010_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4000_data *data = iio_priv(indio_dev);
 	const unsigned long *active_scan_mask = indio_dev->active_scan_mask;
-	u16 buffer[8] = {0}; /* 1x16-bit + ts */
+	u16 buffer[8] __aligned(8) = {0}; /* 1x16-bit + naturally aligned ts */
 	bool data_read = false;
 	unsigned long isr;
 	int val = 0;
-- 
2.30.2



