Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9207A46D3CE
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhLHM6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLHM6L (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:58:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADA9C061746
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB7E5B820E8
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD4C00446;
        Wed,  8 Dec 2021 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968077;
        bh=WZ4CACbCAEkrcKbHESVDhCtGcOYZh4hkwWOM9IeVzU0=;
        h=Subject:To:From:Date:From;
        b=W4fXhyEHCscRaAPP0ZThcoN/hMrmPsLkIWa1JwAjwxtO4zCxBvj24wRWFp7Huqu2d
         tmNu7JUvLDmpu+sIs/PjSxMT8xmQ0eBMtxijCddGWGCAxYblNoAUO9u7BDQpyU6WU/
         ouIksL1RWtOmOXFlZMwXufdIw4Q1JWWsLE+D/6b4=
Subject: patch "iio: at91-sama5d2: Fix incorrect sign extension" added to char-misc-linus
To:     gwendal@chromium.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, eugen.hristev@microchip.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:58 +0100
Message-ID: <163896803895230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: at91-sama5d2: Fix incorrect sign extension

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 652e7df485c6884d552085ae2c73efa6cfea3547 Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Thu, 4 Nov 2021 01:24:08 -0700
Subject: iio: at91-sama5d2: Fix incorrect sign extension

Use scan_type when processing raw data which also fixes that the sign
extension was from the wrong bit.

Use channel definition as root of trust and replace constant
when reading elements directly using the raw sysfs attributes.

Fixes: 6794e23fa3fe ("iio: adc: at91-sama5d2_adc: add support for oversampling resolution")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Eugen Hristev <eugen.hristev@microchip.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211104082413.3681212-9-gwendal@chromium.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 4c922ef634f8..92a57cf10fba 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1586,7 +1586,8 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		*val = st->conversion_value;
 		ret = at91_adc_adjust_val_osr(st, val);
 		if (chan->scan_type.sign == 's')
-			*val = sign_extend32(*val, 11);
+			*val = sign_extend32(*val,
+					     chan->scan_type.realbits - 1);
 		st->conversion_done = false;
 	}
 
-- 
2.34.1


