Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F852E669E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbgL1NSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731715AbgL1NSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:18:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 270CF20776;
        Mon, 28 Dec 2020 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161484;
        bh=nyTssKT5IpUGBYDlCrcVpP9V8Cl8LAaY6iLAzA6phSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYCtre89AQAnV7rxhfDDostnRvLJ1wTc4+NwLIbrN64CkmSyRLsF07/mAagq1l/N1
         iDAZGJbJQ25Iy/VGY9bBdT1jPn+QQe9fwrKoSO5Mdt1d70iuRi8N6zUYtVfD60EgYt
         cswuaQjHNqPfmhK2Z09O9xgfUOOTSlCKLjsEMDNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 228/242] iio: buffer: Fix demux update
Date:   Mon, 28 Dec 2020 13:50:33 +0100
Message-Id: <20201228124915.897529148@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit 19ef7b70ca9487773c29b449adf0c70f540a0aab upstream.

When updating the buffer demux, we will skip a scan element from the
device in the case `in_ind != out_ind` and we enter the while loop.
in_ind should only be refreshed with `find_next_bit()` in the end of the
loop.

Note, to cause problems we need a situation where we are skippig over
an element (channel not enabled) that happens to not have the same size
as the next element.   Whilst this is a possible situation we haven't
actually identified any cases in mainline where it happens as most drivers
have consistent channel storage sizes with the exception of the timestamp
which is the last element and hence never skipped over.

Fixes: 5ada4ea9be16 ("staging:iio: add demux optionally to path from device to buffer")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20201112144323.28887-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/industrialio-buffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -850,12 +850,12 @@ static int iio_buffer_update_demux(struc
 				       indio_dev->masklength,
 				       in_ind + 1);
 		while (in_ind != out_ind) {
-			in_ind = find_next_bit(indio_dev->active_scan_mask,
-					       indio_dev->masklength,
-					       in_ind + 1);
 			length = iio_storage_bytes_for_si(indio_dev, in_ind);
 			/* Make sure we are aligned */
 			in_loc = roundup(in_loc, length) + length;
+			in_ind = find_next_bit(indio_dev->active_scan_mask,
+					       indio_dev->masklength,
+					       in_ind + 1);
 		}
 		length = iio_storage_bytes_for_si(indio_dev, in_ind);
 		out_loc = roundup(out_loc, length);


