Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EAC451476
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349301AbhKOUGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344415AbhKOTYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B3D963487;
        Mon, 15 Nov 2021 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002643;
        bh=HY49olzyPNqCdwCu8ATKCYOu/MZkJTlc5ImAGco7tFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCdKeXgry5mAu7ypO53QysVTs4yEdAAgqnF4aTtJIyMbTfidg1DXOqLfh1i0p2kaQ
         hQ2JdA8l5F0ARZHaj/T8Tfbk3qnWumJQowZMgwnADgINFX3RlaHxGmw3WMGwXsNNrq
         4ZO11fW0P88NdxXv2Ku+ofENmaDGg9sEbvkbXlJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 645/917] iio: buffer: Fix double-free in iio_buffers_alloc_sysfs_and_mask()
Date:   Mon, 15 Nov 2021 18:02:20 +0100
Message-Id: <20211115165450.725630884@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 09776d9374e635b1580b3736c19b95b788fbaa85 ]

When __iio_buffer_alloc_sysfs_and_mask() failed, 'unwind_idx' should be
set to 'i - 1' to prevent double-free when cleanup resources.

BUG: KASAN: double-free or invalid-free in __iio_buffer_free_sysfs_and_mask+0x32/0xb0 [industrialio]
Call Trace:
 kfree+0x117/0x4c0
 __iio_buffer_free_sysfs_and_mask+0x32/0xb0 [industrialio]
 iio_buffers_alloc_sysfs_and_mask+0x60d/0x1570 [industrialio]
 __iio_device_register+0x483/0x1a30 [industrialio]
 ina2xx_probe+0x625/0x980 [ina2xx_adc]

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: ee708e6baacd ("iio: buffer: introduce support for attaching more IIO buffers")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211013094923.2473-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 7f4e3ceaafec6..2f98ba70e3d78 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1624,7 +1624,7 @@ int iio_buffers_alloc_sysfs_and_mask(struct iio_dev *indio_dev)
 		buffer = iio_dev_opaque->attached_buffers[i];
 		ret = __iio_buffer_alloc_sysfs_and_mask(buffer, indio_dev, i);
 		if (ret) {
-			unwind_idx = i;
+			unwind_idx = i - 1;
 			goto error_unwind_sysfs_and_mask;
 		}
 	}
-- 
2.33.0



