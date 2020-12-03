Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A042CE07C
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 22:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgLCVT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 16:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730147AbgLCVT1 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 3 Dec 2020 16:19:27 -0500
Subject: patch "iio: buffer: Fix demux update" added to staging-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607030326;
        bh=uhoGbLsT1y6iPbCgSVfT8/e33WG0UHLvwVvlRZ8oW5Q=;
        h=To:From:Date:From;
        b=lmeDLfVwabbHAVfONnnmjyqqVVVsgBs8iJfQ9VbOACvtyuxITrzmKL/inHNQoY1j4
         FD6vstaKQgFsoLsVnLXUCaGeIBllZNJZ8wUIaLmxXTr7J0FN4MookdXSznd8WXD6w3
         ZDs7aV3uSJCwcLsaiUQH4tZntgklh3asPaz53ys0=
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Dec 2020 22:18:50 +0100
Message-ID: <160703033036147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: buffer: Fix demux update

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 19ef7b70ca9487773c29b449adf0c70f540a0aab Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Thu, 12 Nov 2020 15:43:22 +0100
Subject: iio: buffer: Fix demux update
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/iio/industrialio-buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 9663dec3dcf3..2f7426a2f47c 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -853,12 +853,12 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
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
-- 
2.29.2


