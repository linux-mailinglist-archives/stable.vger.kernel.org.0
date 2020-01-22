Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72D614560F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgAVNUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgAVNUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:11 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239112467A;
        Wed, 22 Jan 2020 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699210;
        bh=Pnms0mdwSSW50PLMZds+9J5iQ+280m3bmjraUAgTnto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUM76JBNXhaxPLyE9cMjz5ZK1jGPQsxQ//MYvznp1+0rXRlmy3c03gDrcxxiRiIw0
         cHkpTkubKk95ptjtG9D0iWdAz+jhkMtdXyCdXlyZ9cKnhD/TKbJRGr0ix4xTyHsCco
         fKbAdnru/+nCjcKfijJbOoJ/xg9xT1HodZbQYTl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 038/222] iio: adc: ad7124: Fix DT channel configuration
Date:   Wed, 22 Jan 2020 10:27:04 +0100
Message-Id: <20200122092836.253449337@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

commit d7857e4ee1ba69732b16c73b2f2dde83ecd78ee4 upstream.

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
 drivers/iio/adc/ad7124.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -494,13 +494,11 @@ static int ad7124_of_parse_channel_confi
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


