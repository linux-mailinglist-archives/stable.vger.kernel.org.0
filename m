Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C73043887E
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhJXLRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLRj (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:17:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76F460FED;
        Sun, 24 Oct 2021 11:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074119;
        bh=k0ttl6fA7KDTRT6sHJQUnzlg9zKAs4XF5BJ1tuWl/jE=;
        h=Subject:To:From:Date:From;
        b=cAZ1CdSxRyd4+L/QC157dl4kizJAOaWiBGG1A3fWot4g13b7zkhsSxV1rVk8+HaT2
         C9VHRXD24jfiO3OiMJiHaKH6eW7kmV8jZGOMq2a/F7ZW5N5B1mOS6WJX6dxvlRmSzB
         Tk4OwGCw73Xk5QHPrVQKpaTlEB5JyOvVBqpZA64I=
Subject: patch "drivers: iio: dac: ad5766: Fix dt property name" added to char-misc-next
To:     mihail.chindris@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:05 +0200
Message-ID: <1635074105134137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers: iio: dac: ad5766: Fix dt property name

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From d9de0fbdeb0103a204055efb69cb5cc8f5f12a6a Mon Sep 17 00:00:00 2001
From: Mihail Chindris <mihail.chindris@analog.com>
Date: Thu, 7 Oct 2021 08:00:34 +0000
Subject: drivers: iio: dac: ad5766: Fix dt property name

In the documentation the name for the property is
output-range-microvolts which is a standard name, therefore this name
must be used.

Fixes: fd9373e41b9ba ("iio: dac: ad5766: add driver support for AD5766")
Signed-off-by: Mihail Chindris <mihail.chindris@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20211007080035.2531-5-mihail.chindris@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5766.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/dac/ad5766.c b/drivers/iio/dac/ad5766.c
index 3104ec32dfac..dafda84fdea3 100644
--- a/drivers/iio/dac/ad5766.c
+++ b/drivers/iio/dac/ad5766.c
@@ -503,13 +503,13 @@ static int ad5766_get_output_range(struct ad5766_state *st)
 	int i, ret, min, max, tmp[2];
 
 	ret = device_property_read_u32_array(&st->spi->dev,
-					     "output-range-voltage",
+					     "output-range-microvolts",
 					     tmp, 2);
 	if (ret)
 		return ret;
 
-	min = tmp[0] / 1000;
-	max = tmp[1] / 1000;
+	min = tmp[0] / 1000000;
+	max = tmp[1] / 1000000;
 	for (i = 0; i < ARRAY_SIZE(ad5766_span_tbl); i++) {
 		if (ad5766_span_tbl[i].min != min ||
 		    ad5766_span_tbl[i].max != max)
-- 
2.33.1


