Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9A28DBC8
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfHNRDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbfHNRDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A6D208C2;
        Wed, 14 Aug 2019 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802186;
        bh=6K1pZaqhlCYLETUu0L6vQfLqj8yj0kpEznabffwYKXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di3uVsof1YRxsTb9qKshj/LaSfN99mi/iFNtxepWdccdAggouQDKcqdwtB7oID+n3
         tzzy5gqDTuXcm9Jh3Re+ZQ2pMDCkGi7QiAZKknU5bhYQf2teXXcWZWtyUSLE+c2OJN
         4FCKphb3CDmcveod7viNgVKc43+TkRQqU/yTLndI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.2 003/144] iio: cros_ec_accel_legacy: Fix incorrect channel setting
Date:   Wed, 14 Aug 2019 18:59:19 +0200
Message-Id: <20190814165759.616580469@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit 6cdff99c9f7d7d28b87cf05dd464f7c7736332ae upstream.

INFO_SCALE is set both for each channel and all channels.
iio is using all channel setting, so the error was not user visible.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/cros_ec_accel_legacy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/iio/accel/cros_ec_accel_legacy.c
+++ b/drivers/iio/accel/cros_ec_accel_legacy.c
@@ -319,7 +319,6 @@ static const struct iio_chan_spec_ext_in
 		.modified = 1,					        \
 		.info_mask_separate =					\
 			BIT(IIO_CHAN_INFO_RAW) |			\
-			BIT(IIO_CHAN_INFO_SCALE) |			\
 			BIT(IIO_CHAN_INFO_CALIBBIAS),			\
 		.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_SCALE),	\
 		.ext_info = cros_ec_accel_legacy_ext_info,		\


