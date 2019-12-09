Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB11116826
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfLIIaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfLIIaR (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 9 Dec 2019 03:30:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B683520721;
        Mon,  9 Dec 2019 08:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575880217;
        bh=PQTD7xqfPBbjG0tOTkki71gQu7gazzmzx5Q3j1eT1iw=;
        h=Subject:To:From:Date:From;
        b=ByxQ2AaQRdu+buO3bKv4K0bVMT0fvS3Jy469OELEO0HDMA5lRKZjvF793kkU9GH96
         +uzI86qAWRyH9vWOv560fq9m/nH1VSyEJa6Z/Pz7jAyMPUbOP/vP+y+/A4W0M07wq3
         8oJTahd9pTYxLp/+SBXDSzVXbLXEr5iOmkRi765k=
Subject: patch "iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting" added to staging-linus
To:     chris.lesiak@licor.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, matt.ranostay@konsulko.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Dec 2019 09:29:58 +0100
Message-ID: <1575880198214169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 342a6928bd5017edbdae376042d8ad6af3d3b943 Mon Sep 17 00:00:00 2001
From: Chris Lesiak <chris.lesiak@licor.com>
Date: Thu, 21 Nov 2019 20:39:42 +0000
Subject: iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

The IIO_HUMIDITYRELATIVE channel was being incorrectly reported back
as percent when it should have been milli percent. This is via an
incorrect scale value being returned to userspace.

Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/humidity/hdc100x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/humidity/hdc100x.c b/drivers/iio/humidity/hdc100x.c
index 963ff043eecf..7ecd2ffa3132 100644
--- a/drivers/iio/humidity/hdc100x.c
+++ b/drivers/iio/humidity/hdc100x.c
@@ -229,7 +229,7 @@ static int hdc100x_read_raw(struct iio_dev *indio_dev,
 			*val2 = 65536;
 			return IIO_VAL_FRACTIONAL;
 		} else {
-			*val = 100;
+			*val = 100000;
 			*val2 = 65536;
 			return IIO_VAL_FRACTIONAL;
 		}
-- 
2.24.0


