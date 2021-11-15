Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4034511AA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbhKOTM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244124AbhKOTKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FAC6349F;
        Mon, 15 Nov 2021 18:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000325;
        bh=2HmUPyDs3060LsllgBth3gcpkGAkTP1Puee5FtiIpXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6sHxjnMIVI8mgEWwAGiQYLV4fhXWMcPBFRMhDc8XF4WuHpyYeVqSgIzAm/0OSQd+
         1EC7GWXiCgjvqzxdy4eh0WLBAdHGMv5eGI+TecjRw5en7CbE4T4e2RKc5yuXQ2gVye
         kduV6R6kPhJqQs+dq27+Y//a+pLm5hP5MRZXpb1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 620/849] iio: buffer: Fix double-free in iio_buffers_alloc_sysfs_and_mask()
Date:   Mon, 15 Nov 2021 18:01:43 +0100
Message-Id: <20211115165441.236315499@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 2801f3a650760..1dfd10831f379 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1623,7 +1623,7 @@ int iio_buffers_alloc_sysfs_and_mask(struct iio_dev *indio_dev)
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



