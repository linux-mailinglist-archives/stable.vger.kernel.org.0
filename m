Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5966338315C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbhEQOgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240544AbhEQOep (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D347613EC;
        Mon, 17 May 2021 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261009;
        bh=MIvY5FmrqMXuwwvYDoseKKYf9f7cpLAd6tgjeFexTCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS/zySna6EVMPz83U4udcrgjRwjfm1aIu1Fw9LsIR7Eakfj8SfPwxVjvUiZhcfkz9
         CHRKatvFp2r0yfNiQ29XeVM0i+bstPHrfYQ/kHKzL8MJ5cJU7OcYG4R1Ho3ojNqpIH
         zz8d5S/yh506lS8+0e3zWp0tp7Bzn+phNmYxZLfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandru Ardelean <aardelean@deviqon.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 289/363] iio: core: return ENODEV if ioctl is unknown
Date:   Mon, 17 May 2021 16:02:35 +0200
Message-Id: <20210517140312.374745966@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <aardelean@deviqon.com>

[ Upstream commit af0670b0bf1b116fd729b1b1011cf814bc34e12e ]

When the ioctl() mechanism was introduced in IIO core to centralize the
registration of all ioctls in one place via commit 8dedcc3eee3ac ("iio:
core: centralize ioctl() calls to the main chardev"), the return code was
changed from ENODEV to EINVAL, when the ioctl code isn't known.

This was done by accident.

This change reverts back to the old behavior, where if the ioctl() code
isn't known, ENODEV is returned (vs EINVAL).

This was brought into perspective by this patch:
  https://lore.kernel.org/linux-iio/20210428150815.136150-1-paul@crapouillou.net/

Fixes: 8dedcc3eee3ac ("iio: core: centralize ioctl() calls to the main chardev")
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Tested-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 7db761afa578..2050d341746b 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1734,7 +1734,6 @@ static long iio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (!indio_dev->info)
 		goto out_unlock;
 
-	ret = -EINVAL;
 	list_for_each_entry(h, &iio_dev_opaque->ioctl_handlers, entry) {
 		ret = h->ioctl(indio_dev, filp, cmd, arg);
 		if (ret != IIO_IOCTL_UNHANDLED)
@@ -1742,7 +1741,7 @@ static long iio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	if (ret == IIO_IOCTL_UNHANDLED)
-		ret = -EINVAL;
+		ret = -ENODEV;
 
 out_unlock:
 	mutex_unlock(&indio_dev->info_exist_lock);
-- 
2.30.2



