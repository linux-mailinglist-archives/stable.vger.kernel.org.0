Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07CA190F2E
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgCXNSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgCXNSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE6D208CA;
        Tue, 24 Mar 2020 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055894;
        bh=fgCakXjwGY+rUhPIQxjVi1O2wIJkX+bF8EbPDUz0qfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLfvnR1GURgpfapItce9trVLHOv+8ql6cbbdVAapUtr/qzMDMEef3iMDFtxMoohiA
         zSMKObCbDWgZU69dvF99JloTF4U2Va8zrgmD0+4+NhFKHM9rEJGUzGLrHjOaAJG3Ye
         yBsrdKjt8pHV/Qzo9K7kXupF5ueISreCJSqWWXUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Linus Waleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 060/102] iio: magnetometer: ak8974: Fix negative raw values in sysfs
Date:   Tue, 24 Mar 2020 14:10:52 +0100
Message-Id: <20200324130812.757689015@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit b500c086e4110829a308c23e83a7cdc65b26228a upstream.

At the moment, reading from in_magn_*_raw in sysfs tends to return
large values around 65000, even though the output of ak8974 is actually
limited to ±32768. This happens because the value is never converted
to the signed 16-bit integer variant.

Add an explicit cast to s16 to fix this.

Fixes: 7c94a8b2ee8c ("iio: magn: add a driver for AK8974")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Linus Waleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/magnetometer/ak8974.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/magnetometer/ak8974.c
+++ b/drivers/iio/magnetometer/ak8974.c
@@ -564,7 +564,7 @@ static int ak8974_read_raw(struct iio_de
 		 * We read all axes and discard all but one, for optimized
 		 * reading, use the triggered buffer.
 		 */
-		*val = le16_to_cpu(hw_values[chan->address]);
+		*val = (s16)le16_to_cpu(hw_values[chan->address]);
 
 		ret = IIO_VAL_INT;
 	}


