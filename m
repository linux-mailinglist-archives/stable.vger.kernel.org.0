Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33B6138FC9
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgAMLIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728646AbgAMLIy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 13 Jan 2020 06:08:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ECFC207E0;
        Mon, 13 Jan 2020 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578913733;
        bh=398y/PZw8xulsxfpVFTr1FAcCAvJhJ/kSdizepY3lhY=;
        h=Subject:To:From:Date:From;
        b=twa731KCxgQpWomR1qBuRWDTmbHYU0jD+/KPnafQbxyfLjH5333Zd5ehcWqGfeE+P
         267ue1eG0Zyfw28kGY0xyEEhAcqJAvy4tmb2iftGuhmj1QbgSquNNKJyg2+QpAVwaR
         rKCABb/igx1cT79Zn1QdafiwX0OQjWgercBKmipQ=
Subject: patch "iio: adc: ad7124: Fix DT channel configuration" added to staging-linus
To:     alexandru.tachici@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gregkh@linuxfoundation.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jan 2020 12:08:50 +0100
Message-ID: <1578913730124148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7124: Fix DT channel configuration

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d7857e4ee1ba69732b16c73b2f2dde83ecd78ee4 Mon Sep 17 00:00:00 2001
From: Alexandru Tachici <alexandru.tachici@analog.com>
Date: Fri, 20 Dec 2019 12:07:19 +0200
Subject: iio: adc: ad7124: Fix DT channel configuration

This patch fixes device tree channel configuration.

ad7124 driver reads channels configuration from the device tree.
It expects to find channel specifications as child nodes.
Before this patch ad7124 driver assumed that the child nodes are parsed
by for_each_available_child_of_node in the order 0,1,2,3...

This is wrong and the real order of the children can be seen by running:
dtc -I fs /sys/firmware/devicetree/base on the machine.

For example, running this on an rpi 3B+ yields the real
children order: 4,2,0,7,5,3,1,6

Before this patch the driver assigned the channel configuration
like this:
        - 0 <- 4
        - 1 <- 2
        - 2 <- 0
        ........
For example, the symptoms can be observed by connecting the 4th channel
to a 1V tension and then reading the in_voltage0-voltage19_raw sysfs
(multiplied of course by the scale) one would see that channel 0
measures 1V and channel 4 measures only noise.

Now the driver uses the reg property of each child in order to
correctly identify to which channel the parsed configuration
belongs to.

Fixes b3af341bbd966: ("iio: adc: Add ad7124 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 3f03abf100b5..306bf15023a7 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -494,13 +494,11 @@ static int ad7124_of_parse_channel_config(struct iio_dev *indio_dev,
 		st->channel_config[channel].buf_negative =
 			of_property_read_bool(child, "adi,buffered-negative");
 
-		*chan = ad7124_channel_template;
-		chan->address = channel;
-		chan->scan_index = channel;
-		chan->channel = ain[0];
-		chan->channel2 = ain[1];
-
-		chan++;
+		chan[channel] = ad7124_channel_template;
+		chan[channel].address = channel;
+		chan[channel].scan_index = channel;
+		chan[channel].channel = ain[0];
+		chan[channel].channel2 = ain[1];
 	}
 
 	return 0;
-- 
2.24.1


