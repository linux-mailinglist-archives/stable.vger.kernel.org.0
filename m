Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486238D44D
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhEVHvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHvy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51C861244;
        Sat, 22 May 2021 07:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669830;
        bh=uTV11IcDzqbra5DR3bW/3XJOIFy34VE0IXPfkwhF8FI=;
        h=Subject:To:From:Date:From;
        b=vcQqBDrEMFdKvynJfsx0FeApEBzyHo1Evgtw6Ac5jPybZPbVFtilM9Iu7qN4RCoTF
         xpmw4+fZLh2qinr8vgQpAsETbfOMoJWUEpeH+4h0M0heDbgCZtUQ5Sh/ca0XoWU/Wy
         /uybxmwB+OhHTfrJemZrcmCs0YPsIQTyyMny7VuI=
Subject: patch "staging: iio: cdc: ad7746: avoid overwrite of num_channels" added to staging-linus
To:     lucas.p.stankus@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:19 +0200
Message-ID: <162166981925589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: iio: cdc: ad7746: avoid overwrite of num_channels

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 04f5b9f539ce314f758d919a14dc7a669f3b7838 Mon Sep 17 00:00:00 2001
From: Lucas Stankus <lucas.p.stankus@gmail.com>
Date: Tue, 11 May 2021 17:54:18 -0300
Subject: staging: iio: cdc: ad7746: avoid overwrite of num_channels

AD7745 devices don't have the CIN2 pins and therefore can't handle related
channels. Forcing the number of AD7746 channels may lead to enabling more
channels than what the hardware actually supports.
Avoid num_channels being overwritten after first assignment.

Signed-off-by: Lucas Stankus <lucas.p.stankus@gmail.com>
Fixes: 83e416f458d53 ("staging: iio: adc: Replace, rewrite ad7745 from scratch.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
---
 drivers/staging/iio/cdc/ad7746.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/iio/cdc/ad7746.c b/drivers/staging/iio/cdc/ad7746.c
index dfd71e99e872..eab534dc4bcc 100644
--- a/drivers/staging/iio/cdc/ad7746.c
+++ b/drivers/staging/iio/cdc/ad7746.c
@@ -700,7 +700,6 @@ static int ad7746_probe(struct i2c_client *client,
 		indio_dev->num_channels = ARRAY_SIZE(ad7746_channels);
 	else
 		indio_dev->num_channels =  ARRAY_SIZE(ad7746_channels) - 2;
-	indio_dev->num_channels = ARRAY_SIZE(ad7746_channels);
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
 	if (pdata) {
-- 
2.31.1


