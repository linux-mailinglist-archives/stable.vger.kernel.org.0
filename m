Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857AD3836B0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242766AbhEQPfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245030AbhEQPcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 815C861CCF;
        Mon, 17 May 2021 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262322;
        bh=KdTy1TiYv9e7OYbkg9jdokQ+1XM365McWiNQqDYQK30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SApqSk4RzAFTUyaL09sJg8ylkvPOrFkLD+RAxyQH8N75g76O0E4f25h8MwX0VWOH
         38RRfxSEJ713Z2olv0N7GUsn4++clACEGB/yr3bS1QrDjOahb6u77CwV4hXcv5g8T2
         X2ucrAtOx4ktPIPwwMvWIH/BX5ErNY1NeFOf7XvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandru Ardelean <aardelean@deviqon.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 264/329] iio: core: return ENODEV if ioctl is unknown
Date:   Mon, 17 May 2021 16:02:55 +0200
Message-Id: <20210517140311.043391406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index c2e4c267c36b..afba32b57814 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1698,7 +1698,6 @@ static long iio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (!indio_dev->info)
 		goto out_unlock;
 
-	ret = -EINVAL;
 	list_for_each_entry(h, &iio_dev_opaque->ioctl_handlers, entry) {
 		ret = h->ioctl(indio_dev, filp, cmd, arg);
 		if (ret != IIO_IOCTL_UNHANDLED)
@@ -1706,7 +1705,7 @@ static long iio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	if (ret == IIO_IOCTL_UNHANDLED)
-		ret = -EINVAL;
+		ret = -ENODEV;
 
 out_unlock:
 	mutex_unlock(&indio_dev->info_exist_lock);
-- 
2.30.2



